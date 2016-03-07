//
//  PrimeViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PrimeViewController.h"
#import "PrimesProblemGenerator.h"

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
    PrimesProblemGenerator * pPGen = [[PrimesProblemGenerator alloc] initWithDifficulty:difficulty];

    for(int i = 0; i< [pPGen.numberOfOptions intValue]; i++){
        NSNumber *numberToAdd = (NSNumber*)[pPGen.selectableNumbers objectAtIndex:i];
        NSString *numberString = [numberToAdd stringValue];
        [self.primeSelectSegmentControl insertSegmentWithTitle:numberString atIndex:i animated:false];
    }
    
    [self.primeSelectSegmentControl selectAllSegments:false];
    self.correctSelections = pPGen.correctSelections;
    
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

@end
