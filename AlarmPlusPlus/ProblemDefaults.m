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
            [theDictionary setObject:@(YES) forKey:@"lin"];
            [theDictionary setObject:@(NO) forKey:@"quad"];
            [theDictionary setObject:@(1) forKey:@"linAX"];
            [theDictionary setObject:@(1) forKey:@"linAY"];
            [theDictionary setObject:@(0) forKey:@"linBX"];
            [theDictionary setObject:@(10) forKey:@"linBY"];
            [theDictionary setObject:@(1) forKey:@"quadAX"];
            [theDictionary setObject:@(1) forKey:@"quadAY"];
            [theDictionary setObject:@(0) forKey:@"quadBX"];
            [theDictionary setObject:@(10) forKey:@"quadBY"];
            [theDictionary setObject:@(0) forKey:@"quadCX"];
            [theDictionary setObject:@(10) forKey:@"quadCY"];
            break;
        case DifficultyNormal:
            [theDictionary setObject:@(YES) forKey:@"lin"];
            [theDictionary setObject:@(NO) forKey:@"quad"];
            [theDictionary setObject:@(0) forKey:@"linAX"];
            [theDictionary setObject:@(10) forKey:@"linAY"];
            [theDictionary setObject:@(-10) forKey:@"linBX"];
            [theDictionary setObject:@(10) forKey:@"linBY"];
            [theDictionary setObject:@(1) forKey:@"quadAX"];
            [theDictionary setObject:@(1) forKey:@"quadAY"];
            [theDictionary setObject:@(0) forKey:@"quadBX"];
            [theDictionary setObject:@(10) forKey:@"quadBY"];
            [theDictionary setObject:@(0) forKey:@"quadCX"];
            [theDictionary setObject:@(10) forKey:@"quadCY"];
            break;
            
        case DifficultyHard:
            [theDictionary setObject:@(NO) forKey:@"lin"];
            [theDictionary setObject:@(YES) forKey:@"quad"];
            [theDictionary setObject:@(0) forKey:@"linAX"];
            [theDictionary setObject:@(10) forKey:@"linAY"];
            [theDictionary setObject:@(-10) forKey:@"linBX"];
            [theDictionary setObject:@(10) forKey:@"linBY"];
            [theDictionary setObject:@(1) forKey:@"quadAX"];
            [theDictionary setObject:@(1) forKey:@"quadAY"];
            [theDictionary setObject:@(-10) forKey:@"quadBX"];
            [theDictionary setObject:@(10) forKey:@"quadBY"];
            [theDictionary setObject:@(-10) forKey:@"quadCX"];
            [theDictionary setObject:@(10) forKey:@"quadCY"];
            break;
            
        case DifficultyCustom:
            //TODO: plist
            [theDictionary setObject:@(NO) forKey:@"lin"];
            [theDictionary setObject:@(YES) forKey:@"quad"];
            [theDictionary setObject:@(0) forKey:@"linAX"];
            [theDictionary setObject:@(10) forKey:@"linAY"];
            [theDictionary setObject:@(-10) forKey:@"linBX"];
            [theDictionary setObject:@(10) forKey:@"linBY"];
            [theDictionary setObject:@(1) forKey:@"quadAX"];
            [theDictionary setObject:@(1) forKey:@"quadAY"];
            [theDictionary setObject:@(-10) forKey:@"quadBX"];
            [theDictionary setObject:@(10) forKey:@"quadBY"];
            [theDictionary setObject:@(-10) forKey:@"quadCX"];
            [theDictionary setObject:@(10) forKey:@"quadCY"];
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
            [theDictionary setObject:@(4) forKey:@"numberOfOptions"];
            [theDictionary setObject:@(1) forKey:@"numberOfPrimes"];
            [theDictionary setObject:@(50) forKey:@"maxPrime"];
            break;
        case DifficultyNormal:
            [theDictionary setObject:@(8) forKey:@"numberOfOptions"];
            [theDictionary setObject:@(2) forKey:@"numberOfPrimes"];
            [theDictionary setObject:@(100) forKey:@"maxPrime"];
            break;
            
        case DifficultyHard:
            [theDictionary setObject:@(8) forKey:@"numberOfOptions"];
            [theDictionary setObject:@(4) forKey:@"numberOfPrimes"];
            [theDictionary setObject:@(200) forKey:@"maxPrime"];
            break;
            
        case DifficultyCustom:
            //TODO: plists
            [theDictionary setObject:@(8) forKey:@"numberOfOptions"];
            [theDictionary setObject:@(4) forKey:@"numberOfPrimes"];
            [theDictionary setObject:@(200) forKey:@"maxPrime"];
            break;
        default:
            break;
    }
    
    return theDictionary;
}


@end
