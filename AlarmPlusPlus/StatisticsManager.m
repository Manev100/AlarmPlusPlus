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


#pragma mark Session Control
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
    NSLog([NSString stringWithFormat:@"Session ended: start: %@, end: %@, tries: %@, problems: %@", [self.currentSession.startingTime description], [self.currentSession.endingTime description], self.currentSession.numberOfTries, self.currentSession.numberOfProblems]);
    self.currentSession = nil;
    
}


#pragma mark Persistence

- (NSMutableArray*) loadSessionsFromPlist{
    NSMutableArray* loadedSessions = [NSMutableArray array];
    return loadedSessions;
}

- (BOOL) saveSessionsToPlist{
    
    return true;
}

@end
