//
//  StatisticsManager.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 01/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsSession.h"
#import "Alarm.h"

@interface StatisticsManager : NSObject
-(id) init;

-(void) startNewSession;
-(void) startNewSessionWithType: (ProblemTypes) type AndDifficulty: (Difficulties)difficulty;

-(void) problemAnsweredCorrectly;
-(void) problemAnsweredWrongly;
-(void) nextProblem;
-(BOOL) saveSessionsToPlist;

-(NSDictionary*) evaluateGeneralStatistics;
-(NSDictionary*) evaluateProblemTypeStatistics;
-(NSDictionary*) evaluateDifficultyStatistics;


@property (strong, nonatomic) NSMutableArray *sessions;
@property (strong, nonatomic) StatisticsSession* currentSession;

@end
