//
//  EquationProblemGenerator.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 23/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"
@interface EquationProblemGenerator : NSObject
- (id)init;
- (id)initWithDifficulty: (Difficulties) difficulty;
- (id)initWithDictionary: (NSDictionary*) dictionary;
- (void) setUpWithDifficulty: (Difficulties) difficulty;
- (NSString*) getResultString;

@property Difficulties chosenDifficulty;
@property NSDictionary *equationRanges;
@property BOOL problemIsLinear;
@property BOOL problemIsQuadratic;

@property NSNumber* a;
@property NSNumber* b;
@property NSNumber* c;
@property NSNumber* x1;
@property NSNumber* x2;
@end
