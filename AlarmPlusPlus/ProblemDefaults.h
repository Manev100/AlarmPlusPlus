//
//  ProblemDefaults.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 19/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface ProblemDefaults : NSObject
+(NSDictionary*) getArithmeticProblemDefaultsForDifficulty: (Difficulties) difficulty;
+(NSDictionary*) getEquationProblemDefaultsForDifficulty: (Difficulties) difficulty;
+(NSDictionary*) getPrimeProblemDefaultsForDifficulty: (Difficulties) difficulty;
+(void) saveArithmeticProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary;
+(void) saveEquationProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary;
+(void) savePrimeProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary;
+(void) resetValues;
@end
