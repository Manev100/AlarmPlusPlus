//
//  StatisticsSession.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 01/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsSession : NSObject <NSCoding>
@property NSDate *startingTime;
@property NSDate *endingTime;
@property NSNumber *numberOfTries;
@property NSNumber *numberOfProblems;

-(id) init;
-(void) endSession;

@end
