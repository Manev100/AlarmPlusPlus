//
//  StatisticsManager.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 01/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "StatisticsManager.h"

@implementation StatisticsManager


#pragma mark - Initialization
-(id) init{
    if(self = [super init]){
        self.sessions = [self loadSessionsFromPlist];
    }
    return self;
}


#pragma mark - Session Control
-(void) startNewSession{
    self.currentSession = [[StatisticsSession alloc] init];
}

-(void) startNewSessionWithType: (ProblemTypes) type AndDifficulty: (Difficulties)difficulty{
    self.currentSession = [[StatisticsSession alloc] initWithType:type AndDifficulty:difficulty];
}

-(void) problemAnsweredCorrectly{
    [self tryMade];
    [self endCurrentSession];
}

-(void) problemAnsweredWrongly{
    [self tryMade];
}

-(void) nextProblem{
    int oldProblems = [self.currentSession.numberOfProblems intValue];
    self.currentSession.numberOfProblems = @(oldProblems + 1);
}

-(void) tryMade{
    int oldTries = [self.currentSession.numberOfTries intValue];
    self.currentSession.numberOfTries = @(oldTries + 1);
}

-(void) endCurrentSession{
    [self.currentSession endSession];
    [self.sessions addObject:self.currentSession];
    NSLog(@"%@",[NSString stringWithFormat:@"Session ended: start: %@, end: %@, tries: %@, problems: %@", [self.currentSession.startingTime description], [self.currentSession.endingTime description], self.currentSession.numberOfTries, self.currentSession.numberOfProblems]);
    self.currentSession = nil;
    
}

#pragma mark - Statistics Output

-(NSDictionary*) evaluateGeneralStatistics{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    double totalTimeInSeconds = 0.0;
    int numberOfTries = 0;
    int numberOfSolves = (int)[self.sessions count];
    
    
    for(StatisticsSession* session in self.sessions){
        totalTimeInSeconds += [session.endingTime timeIntervalSinceDate:session.startingTime];
        numberOfTries += [session.numberOfTries intValue];
    }
    
    
    
    [dict setObject:@((int)totalTimeInSeconds) forKey:@"totalTime"];
    [dict setObject:@(numberOfTries-numberOfSolves) forKey:@"wrongTries"];
    [dict setObject:@(numberOfSolves) forKey:@"solves"];
    
    if(numberOfSolves == 0){
        numberOfSolves = 1;
    }
    [dict setObject:@((int)(totalTimeInSeconds/numberOfSolves)) forKey:@"averageTime"];
    
    [dict setObject:@(numberOfTries/numberOfSolves) forKey:@"averageTries"];
    
    return dict;
}

-(NSDictionary*) evaluateDifficultyStatistics{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int numberOfEasyProblemsSolved = 0;
    int numberOfEasyProblemsTried = 0;
    int numberOfNormalProblemsSolved = 0;
    int numberOfNormalProblemsTried = 0;
    int numberOfHardProblemsSolved = 0;
    int numberOfHardProblemsTried = 0;
    int numberOfCustomProblemsSolved = 0;
    int numberOfCustomProblemsTried = 0;
    
    for(StatisticsSession* session in self.sessions){
        switch(session.difficulty){
            case DifficultyEasy:
                numberOfEasyProblemsSolved++;
                numberOfEasyProblemsTried+= [session.numberOfProblems intValue];
                break;
            case DifficultyNormal:
                numberOfNormalProblemsSolved++;
                numberOfNormalProblemsTried+= [session.numberOfProblems intValue];
                break;
            case DifficultyHard:
                numberOfHardProblemsSolved++;
                numberOfHardProblemsTried+= [session.numberOfProblems intValue];
                break;
            case DifficultyCustom:
                numberOfCustomProblemsSolved++;
                numberOfCustomProblemsTried+= [session.numberOfProblems intValue];
                break;
            case DifficulyCount:
                break;
        }
    }
    
    [dict setObject:@(numberOfEasyProblemsTried) forKey:@"easyTries"];
    [dict setObject:@(numberOfEasyProblemsSolved) forKey:@"easySolves"];
    [dict setObject:@(numberOfNormalProblemsTried) forKey:@"normalTries"];
    [dict setObject:@(numberOfNormalProblemsSolved) forKey:@"normalSolves"];
    [dict setObject:@(numberOfHardProblemsTried) forKey:@"hardTries"];
    [dict setObject:@(numberOfHardProblemsSolved) forKey:@"hardSolves"];
    [dict setObject:@(numberOfCustomProblemsTried) forKey:@"customTries"];
    [dict setObject:@(numberOfCustomProblemsSolved) forKey:@"customSolves"];
    
    int totalTries = numberOfEasyProblemsTried+numberOfNormalProblemsTried+numberOfHardProblemsTried+numberOfCustomProblemsTried;
    if(totalTries == 0){
        totalTries = 1;
    }
    
    [dict setObject:@((numberOfEasyProblemsTried*100)/totalTries) forKey:@"percentageEasy"];
    [dict setObject:@((numberOfNormalProblemsTried*100)/totalTries) forKey:@"percentageNormal"];
    [dict setObject:@((numberOfHardProblemsTried*100)/totalTries) forKey:@"percentageHard"];
    [dict setObject:@((numberOfCustomProblemsTried*100)/totalTries) forKey:@"percentageCustom"];
    
    return dict;
}

-(NSDictionary*) evaluateProblemTypeStatistics{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int numberOfArithmeticProblemsTried = 0;
    int numberOfArithmeticProblemsSolved = 0;
    int numberOfEquationProblemsTried = 0;
    int numberOfEquationProblemsSolved = 0;
    int numberOfPrimeProblemsTried = 0;
    int numberOfPrimeProblemsSolved = 0;
    
    
    for(StatisticsSession* session in self.sessions){
        switch(session.problemType){
            case ProblemTypeArithmetic:
                numberOfArithmeticProblemsSolved++;
                numberOfArithmeticProblemsTried+= [session.numberOfProblems intValue];
                break;
            case ProblemTypeEquation:
                numberOfEquationProblemsSolved++;
                numberOfEquationProblemsTried+= [session.numberOfProblems intValue];
                break;
            case ProblemTypePrime:
                numberOfPrimeProblemsSolved++;
                numberOfPrimeProblemsTried+= [session.numberOfProblems intValue];
                break;
            case ProblemTypeCount:
                break;
        }
    }
    
    [dict setObject:@(numberOfArithmeticProblemsTried) forKey:@"aPTried"];
    [dict setObject:@(numberOfArithmeticProblemsSolved) forKey:@"aPSolved"];
    [dict setObject:@(numberOfEquationProblemsTried) forKey:@"eqPTried"];
    [dict setObject:@(numberOfEquationProblemsSolved) forKey:@"eqPSolved"];
    [dict setObject:@(numberOfPrimeProblemsTried) forKey:@"pPTried"];
    [dict setObject:@(numberOfPrimeProblemsSolved) forKey:@"pPSolved"];
    
    int totalProblemTries = numberOfArithmeticProblemsTried + numberOfEquationProblemsTried + numberOfPrimeProblemsTried;
    if(totalProblemTries == 0){
        totalProblemTries = 1;
    }
    
    [dict setObject:@((numberOfArithmeticProblemsTried*100)/totalProblemTries) forKey:@"percentageAP"];
    [dict setObject:@((numberOfEquationProblemsTried*100)/totalProblemTries) forKey:@"percentageEP"];
    [dict setObject:@((numberOfPrimeProblemsTried*100)/totalProblemTries) forKey:@"percentagePP"];
    
    return dict;
}

#pragma mark - Persistence

- (NSMutableArray*) loadSessionsFromPlist{
    NSLog(@"Loading statistics sessions...");
    NSMutableArray* loadedSessions = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePath]];;
    if(loadedSessions == nil){
        loadedSessions = [NSMutableArray array];
    }
    NSLog(@"%@",[loadedSessions description]);
    return loadedSessions;
}

- (BOOL) saveSessionsToPlist{
    NSLog(@"Saving statistics sessions...");
    BOOL status = [NSKeyedArchiver archiveRootObject:self.sessions toFile:[self getFilePath]];
    if (!status) {
        NSLog(@"Error saving sessions");
        return false;
    }
    return true;
}

-(NSString*) getFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *finalPath = [documentsPath stringByAppendingString:@"Statistics.plist"];
    return finalPath;
}

- (void) resetData{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath: [self getFilePath] error:NULL];
    self.sessions = [self loadSessionsFromPlist];
}

@end
