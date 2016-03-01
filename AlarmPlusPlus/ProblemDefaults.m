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
            theDictionary = [self loadValuesFromFile:@"ArithmeticProblemValues.plist"];
            if(theDictionary == nil){
                NSLog(@"No plist found, creating plist with default values...");
                theDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
                [theDictionary setObject:@(0) forKey:@"operandsRangeX"];
                [theDictionary setObject:@(100) forKey:@"operandsRangeY"];
                [theDictionary setObject:@(0) forKey:@"resultRangeX"];
                [theDictionary setObject:@(200) forKey:@"resultRangeY"];
                [theDictionary setObject:@(4) forKey:@"numberOfOperands"];
                [theDictionary setObject:@(15) forKey:@"operatorsFlag"];
                BOOL success = [self saveValuesFromDictionary:theDictionary ToFile:@"ArithmeticProblemValues.plist"];
                if(!success){
                    NSLog(@"Creating plist failed");
                }
            }
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
            [theDictionary setObject:@(-10) forKey:@"linBX"];
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
            [theDictionary setObject:@(-2) forKey:@"linAX"];
            [theDictionary setObject:@(2) forKey:@"linAY"];
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
            theDictionary = [self loadValuesFromFile:@"EquationProblemValues.plist"];
            if(theDictionary == nil){
                NSLog(@"No plist found, creating plist with default values...");
                theDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
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
                BOOL success = [self saveValuesFromDictionary:theDictionary ToFile:@"EquationProblemValues.plist"];
                if(!success){
                    NSLog(@"Creating plist failed");
                }
            }
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
            theDictionary = [self loadValuesFromFile:@"PrimeProblemValues.plist"];
            if(theDictionary == nil){
                NSLog(@"No plist found, creating plist with default values...");
                theDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
                [theDictionary setObject:@(8) forKey:@"numberOfOptions"];
                [theDictionary setObject:@(4) forKey:@"numberOfPrimes"];
                [theDictionary setObject:@(200) forKey:@"maxPrime"];
                BOOL success = [self saveValuesFromDictionary:theDictionary ToFile:@"PrimeProblemValues.plist"];
                if(!success){
                    NSLog(@"Creating plist failed");
                }
            }
            break;
        default:
            break;
    }
    
    return theDictionary;
}

+(NSMutableDictionary*) loadValuesFromFile: (NSString*) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *finalPath = [documentsPath stringByAppendingString:filename];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    if(dict == nil){
        return nil;
    }else{
        return [NSMutableDictionary dictionaryWithDictionary:dict];
    }
}

+(BOOL)saveValuesFromDictionary:(NSMutableDictionary*) theDictionary ToFile:(NSString*) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *finalPath = [documentsPath stringByAppendingString:fileName];
    
    return [theDictionary writeToFile:finalPath atomically:YES];
}

+(void) saveArithmeticProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary{
    [self saveValuesFromDictionary:theDictionary ToFile:@"ArithmeticProblemValues.plist"];
}

+(void) saveEquationProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary{
    [self saveValuesFromDictionary:theDictionary ToFile:@"EquationProblemValues.plist"];
}

+(void) savePrimeProblemCustomDifficultyValues: (NSMutableDictionary*) theDictionary{
    [self saveValuesFromDictionary:theDictionary ToFile:@"PrimeProblemValues.plist"];
}

@end
