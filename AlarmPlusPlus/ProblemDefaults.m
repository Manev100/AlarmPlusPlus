//
//  ProblemDefaults.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 19/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "ProblemDefaults.h"

@implementation ProblemDefaults
+(NSDictionary*) getArithmeticProblemDefaultsForDifficulty: (Difficulties) difficulty{
    NSMutableDictionary* theDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
    switch (difficulty) {
        case DifficultyEasy:
            [theDictionary setObject:@(0) forKey:@"operandsRangeX"];
            [theDictionary setObject:@(100) forKey:@"operandsRangeY"];
            [theDictionary setObject:@(0) forKey:@"resultRangeX"];
            [theDictionary setObject:@(100) forKey:@"resultRangeY"];
            [theDictionary setObject:@(2) forKey:@"numberOfOperands"];
            [theDictionary setObject:@(1) forKey:@"operatorsFlag"];
            break;
        case DifficultyNormal:
            [theDictionary setObject:@(0) forKey:@"operandsRangeX"];
            [theDictionary setObject:@(100) forKey:@"operandsRangeY"];
            [theDictionary setObject:@(0) forKey:@"resultRangeX"];
            [theDictionary setObject:@(100) forKey:@"resultRangeY"];
            [theDictionary setObject:@(3) forKey:@"numberOfOperands"];
            [theDictionary setObject:@(3) forKey:@"operatorsFlag"];
            break;
            
        case DifficultyHard:
            [theDictionary setObject:@(0) forKey:@"operandsRangeX"];
            [theDictionary setObject:@(100) forKey:@"operandsRangeY"];
            [theDictionary setObject:@(0) forKey:@"resultRangeX"];
            [theDictionary setObject:@(200) forKey:@"resultRangeY"];
            [theDictionary setObject:@(4) forKey:@"numberOfOperands"];
            [theDictionary setObject:@(15) forKey:@"operatorsFlag"];
            break;
            
        case DifficultyCustom:
            //TODO: plists
            [theDictionary setObject:@(0) forKey:@"operandsRangeX"];
            [theDictionary setObject:@(100) forKey:@"operandsRangeY"];
            [theDictionary setObject:@(0) forKey:@"resultRangeX"];
            [theDictionary setObject:@(200) forKey:@"resultRangeY"];
            [theDictionary setObject:@(4) forKey:@"numberOfOperands"];
            [theDictionary setObject:@(15) forKey:@"operatorsFlag"];
            break;
        default:
            break;
    }
    
    return theDictionary;
}

+(NSDictionary*) getEquationProblemDefaultsForDifficulty: (Difficulties) difficulty{
    NSMutableDictionary* theDictionary = [NSMutableDictionary dictionaryWithCapacity:15];
    switch (difficulty) {
        case DifficultyEasy:
            
            break;
        case DifficultyNormal:
            
            break;
            
        case DifficultyHard:
            
            break;
            
        case DifficultyCustom:
            
            break;
        default:
            break;
    }
    
    return theDictionary;
}

+(NSDictionary*) getPrimeProblemDefaultsForDifficulty: (Difficulties) difficulty{
    NSMutableDictionary* theDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    switch (difficulty) {
        case DifficultyEasy:
            
            break;
        case DifficultyNormal:
            
            break;
            
        case DifficultyHard:
            
            break;
            
        case DifficultyCustom:
            
            break;
        default:
            break;
    }
    
    return theDictionary;
}


@end
