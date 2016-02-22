//
//  ArithmeticProblemGenerator.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 19/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface ArithmeticProblemGenerator : NSObject
- (id)init;
- (id)initWithDifficulty: (Difficulties) difficulty;
- (void) setUpWithDifficulty: (Difficulties) difficulty;
- (NSString*) getResultString;

typedef NS_OPTIONS(NSInteger, Operators) {
    OperatorPlus = 1 << 0,
    OperatorMinus = 1 << 1,
    OperatorMultiply = 1 << 2,
    OperatorDivide = 1 << 3
};

@property Difficulties chosenDifficulty;
@property NSNumber* operandsRangeX;
@property NSNumber* operandsRangeY;
@property NSNumber* resultRangeX;
@property NSNumber* resultRangeY;
@property NSNumber* numberOfOperands;
@property NSNumber* operatorsFlag;

@property (strong, nonatomic) NSMutableArray* operands;
@property (strong, nonatomic) NSMutableArray* operators;
@property int result;

@end
