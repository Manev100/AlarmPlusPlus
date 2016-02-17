//
//  PrimeViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PrimeViewController.h"

@interface PrimeViewController ()

@end

@implementation PrimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.primes = @[@(2), @(3), @(5), @(7), @(11), @(13), @(17), @(19), @(23), @(29), @(31), @(37), @(41), @(43), @(47), @(53), @(59), @(61), @(67), @(71), @(73), @(79), @(83), @(89), @(97), @(101), @(103), @(107), @(109), @(113), @(127), @(131), @(137), @(139), @(149), @(151), @(157), @(163), @(167), @(173), @(179), @(181), @(191), @(193), @(197), @(199)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setupViewForDifficulty: (Difficulties) difficulty{
    [self.primeSelectSegmentControl removeAllSegments];
    
    int numberOfOptions = 8;
    int numberOfprimes = 1;
    
    
    NSMutableArray *randomPrimes = [self getPrimesArrayOfSize:numberOfprimes];
    NSMutableArray *randomNonPrimes = [self getNonPrimesArrayOfSize:(numberOfOptions - numberOfprimes)];
    
    NSMutableArray *numbersToBeAdded = [NSMutableArray arrayWithArray:randomPrimes];
    [numbersToBeAdded addObjectsFromArray:randomNonPrimes];
    
    // shuffle array by iterating through the array and swapping each object with a random object elsewhere in the array. Not an ideal method but works for now.
    for(int i = 0; i < [numbersToBeAdded count]; i++){
        int indexToSwapWith = arc4random_uniform((int)[numbersToBeAdded count]);
        [numbersToBeAdded exchangeObjectAtIndex:i withObjectAtIndex:indexToSwapWith];
    }
    
    // memorise indices of primes
    self.correctSelections = [NSMutableIndexSet indexSet];
    for(NSNumber *prime in randomPrimes){
        NSUInteger index = [numbersToBeAdded indexOfObject:prime];
        [self.correctSelections addIndex:index];
    }
    
    for(int i = 0; i< numberOfOptions; i++){
        NSNumber *numberToAdd = (NSNumber*)[numbersToBeAdded objectAtIndex:i];
        NSString *numberString = [numberToAdd stringValue];
        [self.primeSelectSegmentControl insertSegmentWithTitle:numberString atIndex:i animated:false];
    }
   
    [self.primeSelectSegmentControl selectAllSegments:false];
    
}

-(BOOL) confirmResult{
    if(self.correctSelections == nil){
        NSLog(@"Not appropiately initialised. Need to call setupViewForDifficulty first.");
        return false;
    }
    
    if([self.correctSelections isEqualToIndexSet:self.primeSelectSegmentControl.selectedSegmentIndexes]){
        return true;
    }
    return false;
}

// potentially endless loop when self.primes.count < size
-(NSMutableArray*) getPrimesArrayOfSize: (int) size{
    NSMutableIndexSet *picks = [NSMutableIndexSet indexSet];
    do {
        [picks addIndex:arc4random_uniform((int) [self.primes count])];
    } while ([picks count] < size);
    
    NSMutableArray *output = [NSMutableArray arrayWithArray:[self.primes objectsAtIndexes:picks]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
