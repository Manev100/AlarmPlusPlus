//
//  PrimesProblemGenerator.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 22/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PrimesProblemGenerator.h"
#import "ProblemDefaults.h"

@implementation PrimesProblemGenerator
#pragma mark - Initialization
- (id)init{
    return [self initWithDifficulty:DifficultyNormal];
}

- (id)initWithDifficulty: (Difficulties) difficulty{
    if (self = [super init]) {
        self.chosenDifficulty = difficulty;
         self.primes = @[@(2), @(3), @(5), @(7), @(11), @(13), @(17), @(19), @(23), @(29), @(31), @(37), @(41), @(43), @(47), @(53), @(59), @(61), @(67), @(71), @(73), @(79), @(83), @(89), @(97), @(101), @(103), @(107), @(109), @(113), @(127), @(131), @(137), @(139), @(149), @(151), @(157), @(163), @(167), @(173), @(179), @(181), @(191), @(193), @(197), @(199), @(211)];
        [self setUpWithDifficulty:difficulty];
       
        
    }
    return self;
}

- (id)initWithDictionary: (NSDictionary*) dictionary{
    if (self = [super init]) {
        self.primes = @[@(2), @(3), @(5), @(7), @(11), @(13), @(17), @(19), @(23), @(29), @(31), @(37), @(41), @(43), @(47), @(53), @(59), @(61), @(67), @(71), @(73), @(79), @(83), @(89), @(97), @(101), @(103), @(107), @(109), @(113), @(127), @(131), @(137), @(139), @(149), @(151), @(157), @(163), @(167), @(173), @(179), @(181), @(191), @(193), @(197), @(199), @(211)];
        [self setUpWithDictionary:dictionary];
    }
    return self;
}

/// Loads default values from ProblemDefaults and continues to setup
- (void) setUpWithDifficulty: (Difficulties) difficulty{
    NSDictionary* defaultValues = [ProblemDefaults getPrimeProblemDefaultsForDifficulty:difficulty];
    [self setUpWithDictionary:defaultValues];
}

/// Extracts default values from dictionary and computes a arithmetic problem with them
- (void)setUpWithDictionary: (NSDictionary*) dictionary{
    // check if dictionary has required values
    NSArray* requiredKeys = [NSArray arrayWithObjects:@"numberOfOptions",@"numberOfPrimes", @"maxPrime", nil];
    NSArray* objectsFound = [dictionary objectsForKeys:requiredKeys notFoundMarker:[NSNull null]];
    if([objectsFound containsObject:[NSNull null]]){
        NSLog(@"Invalid dictionary. Does not contain all necessary values.");
    }
    
    self.numberOfOptions = (NSNumber*)[dictionary objectForKey:@"numberOfOptions"];
    self.numberOfPrimes = (NSNumber*)[dictionary objectForKey:@"numberOfPrimes"];
    self.maxPrime = (NSNumber*)[dictionary objectForKey:@"maxPrime"];
    
    [self computeProblem];
}

#pragma mark - Computation
/// Computes a prime problem and its result, and returns if one could be found
- (void) computeProblem{
    int numberOfOptions = [self.numberOfOptions intValue];
    int numberOfPrimes = [self.numberOfPrimes intValue];
    
    // get proper random primes and non primes
    NSMutableArray *randomPrimes = [self getPrimesArrayOfSize: numberOfPrimes];
    NSMutableArray *randomNonPrimes = [self getNonPrimesArrayOfSize:(numberOfOptions - numberOfPrimes)];
    
    // copy them to one array
    self.selectableNumbers = [NSMutableArray arrayWithArray:randomPrimes];
    [self.selectableNumbers addObjectsFromArray:randomNonPrimes];
    
    // shuffle array by iterating through the array and swapping each object with a random object elsewhere in the array. Not an ideal method but works for now.
    for(int i = 0; i < [self.selectableNumbers count]; i++){
        int indexToSwapWith = arc4random_uniform((int)[self.selectableNumbers count]);
        [self.selectableNumbers exchangeObjectAtIndex:i withObjectAtIndex:indexToSwapWith];
    }
    
    // memorise indices of primes
    self.correctSelections = [NSMutableIndexSet indexSet];
    for(NSNumber *prime in randomPrimes){
        NSUInteger index = [self.selectableNumbers indexOfObject:prime];
        [self.correctSelections addIndex:index];
    }
    
}

/// returns an array with primes of a given size while making sure that they are in the default values range
-(NSMutableArray*) getPrimesArrayOfSize: (int) size{
    // we need subarray of the primesarray up to maxPrime
    // first find last index of this subarray, then get the subarray
    int lastIndex = 0;
    for (int i = 0; i< [self.primes count]; i++) {
        NSNumber *prime = [self.primes objectAtIndex:i];
        if([prime intValue] > [self.maxPrime intValue]){
            lastIndex = i-1;
            break;
        }
    }
    // all primes with index > lastindex are greater than maxPrime
    NSIndexSet *indexesOfPrimes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, lastIndex)];
    NSMutableArray *partOfPrimesArray = [NSMutableArray arrayWithArray:[self.primes objectsAtIndexes:indexesOfPrimes] ];
    
    // pick random primes from this subarray
    NSMutableIndexSet *picks = [NSMutableIndexSet indexSet];
    do {
        [picks addIndex:arc4random_uniform((int) [partOfPrimesArray count])];
    } while ([picks count] < size);
    
    NSMutableArray *output = [NSMutableArray arrayWithArray:[partOfPrimesArray objectsAtIndexes:picks]];
    return output;
}

/// returns an array with primes of a given size
-(NSMutableArray*) getNonPrimesArrayOfSize: (int) size{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:size];
    if(size != 0){
        int nonPrimesFound = 0;
        do{
            // choose a random number and check if it's not prime and wasn't already picked
            NSNumber *number = [NSNumber numberWithInt:arc4random_uniform(200)];
            if(![self.primes containsObject:number] && ![output containsObject:number]){
                [output addObject:number];
                nonPrimesFound++;
            }
        }while(nonPrimesFound < size);
    }
    return output;
}

@end
