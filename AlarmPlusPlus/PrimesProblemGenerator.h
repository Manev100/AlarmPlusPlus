//
//  PrimesProblemGenerator.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 22/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface PrimesProblemGenerator : NSObject
- (id)init;
- (id)initWithDifficulty: (Difficulties) difficulty;
- (void) setUpWithDifficulty: (Difficulties) difficulty;

@property Difficulties chosenDifficulty;
@property NSNumber* numberOfOptions;
@property NSNumber* numberOfPrimes;
@property NSNumber* maxPrime;
@property (strong, nonatomic) NSArray *primes;


@property (strong, nonatomic) NSMutableArray *selectableNumbers;
@property (strong, nonatomic) NSMutableIndexSet *correctSelections;


@end
