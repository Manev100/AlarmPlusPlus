//
//  StatisticsSession.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 01/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "StatisticsSession.h"

@implementation StatisticsSession

-(id) init{
    if(self = [super init]){
        self.startingTime = [NSDate date];
        self.numberOfTries = @(0);
        self.numberOfProblems = @(1);
    }
    return self;
}

-(id) initWithType:(ProblemTypes) problemType AndDifficulty: (Difficulties) difficulty{
    if(self = [self init]){
        self.problemType = problemType;
        self.difficulty = difficulty;
    }
    return self;
}

-(void) endSession{
    self.endingTime = [NSDate date];
}

- (id) initWithCoder:(NSCoder *) decoder{
    if(self = [super init]){
        self.startingTime = [decoder decodeObjectForKey:@"startdate"];
        self.endingTime = [decoder decodeObjectForKey:@"enddate"];
        self.numberOfTries = @([decoder decodeIntForKey:@"tries"]);
        self.numberOfProblems = @([decoder decodeIntForKey:@"problems"]);
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *) coder{
    [coder encodeObject:self.startingTime forKey:@"startdate"];
    [coder encodeObject:self.endingTime forKey:@"enddate"];
    [coder encodeInt:[self.numberOfTries intValue] forKey:@"tries"];
    [coder encodeInt:[self.numberOfProblems intValue] forKey:@"problems"];
}



@end
