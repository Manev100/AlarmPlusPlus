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

- (void) setUpWithDifficulty: (Difficulties) difficulty{
    NSDictionary* defaultValues = [ProblemDefaults getPrimeProblemDefaultsForDifficulty:difficulty];
    self.numberOfOptions = (NSNumber*)[defaultValues objectForKey:@"numberOfOptions"];
    self.numberOfPrimes = (NSNumber*)[defaultValues objectForKey:@"numberOfPrimes"];
    self.maxPrime = (NSNumber*)[defaultValues objectForKey:@"maxPrime"];
    
    [self computeProblem];
    
}

- (void) computeProblem{
    int numberOfOptions = [self.numberOfOptions intValue];
    int numberOfPrimes = [self.numberOfPrimes intValue];
    
    NSMutableArray *randomPrimes = [self getPrimesArrayOfSize: numberOfPrimes];
    NSMutableArray *randomNonPrimes = [self getNonPrimesArrayOfSize:(numberOfOptions - numberOfPrimes)];
    
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

-(NSMutableArray*) getPrimesArrayOfSize: (int) size{
    // we need subarray of the primesarray up to maxPrime, first find last index of the subarray, then get the subarray
    int lastIndex = 0;
    for (int i = 0; i< [self.primes count]; i++) {
        NSNumber *prime = [self.primes objectAtIndex:i];
        if([prime intValue] > [self.maxPrime intValue]){
            lastIndex = i-1;
            break;
        }
    }
    NSIndexSet *indexesOfPrimes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, lastIndex)];
    NSMutableArray *partOfPrimesArray = [NSMutableArray arrayWithArray:[self.primes objectsAtIndexes:indexesOfPrimes] ];
    
    
    NSMutableIndexSet *picks = [NSMutableIndexSet indexSet];
    do {
        [picks addIndex:arc4random_uniform((int) [partOfPrimesArray count])];
    } while ([picks count] < size);
    
    NSMutableArray *output = [NSMutableArray arrayWithArray:[partOfPrimesArray objectsAtIndexes:picks]];
    return output;
}

-(NSMutableArray*) getNonPrimesArrayOfSize: (int) size{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:size];
    
    int nonPrimesFound = 0;
    do{
        NSNumber *number = [NSNumber numberWithInt:arc4random_uniform(200)];
        if(![self.primes containsObject:number] && ![output containsObject:number]){
            [output addObject:number];
            nonPrimesFound++;
        }
    }while(nonPrimesFound < size);
    return output;
}

@end
