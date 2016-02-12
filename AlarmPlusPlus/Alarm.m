//
//  Alarm.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 09/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm
- (id)init{
    if (self = [super init]) {
        // do our initialization...
        self.date = [NSDate date];
        self.name = @"Test1";
        self.ringtone = @"ring.mp3";
        self.problem = ProblemTypeArithmetic;
        self.difficulty = DifficultyNormal;
        self.alarmId = @"0";
        self.volume = 1.0;
        self.active = true;
        self.repeat = false;
        self.weekdaysFlag = WeekdayMonday;
        
    }
    return self;
}

+(NSString*) difficultyToString:(Difficulties)difficulty{
    switch (difficulty) {
        case DifficultyEasy:
            return @"Easy";
            break;
        case DifficultyNormal:
            return @"Normal";
            break;
        case DifficultyHard:
            return @"Hard";
            break;
        case DifficultyCustom:
            return @"Custom";
            break;
        case DifficulyCount:
            return @"INVALID";
            break;
        default:
            break;
    }
    
}

+(NSString*) problemTypeToString:(ProblemTypes) problemType{
    switch (problemType) {
        case ProblemTypeArithmetic:
            return @"Arithmetic Problem";
            break;
        case ProblemTypePrime:
            return @"Prime-Numbers";
            break;
        case ProblemTypeEquation:
            return @"Equation";
            break;
        case ProblemTypeCount:
            return @"INVALID";
            break;
        default:
            break;
    }
    
}

+(NSMutableArray*) weekdaysToArray{
    NSMutableArray *weekdaysArray = [NSMutableArray arrayWithCapacity:7];
    for (int i = 1; i<= 1 << 6 ; i = i << 1) {
        [weekdaysArray addObject:[NSNumber numberWithInt:i]];
    }
    return weekdaysArray;
}

+(NSString*) weekdayToString:(Weekdays)weekday{
    switch (weekday) {
        case WeekdayMonday:
            return @"Monday";
            break;
        case WeekdayTuesday:
            return @"Tuesday";
            break;
        case WeekdayWednesday:
            return @"Wednesday";
            break;
        case WeekdayThursday:
            return @"Thursday";
            break;
        case WeekdayFriday:
            return @"Friday";
            break;
        case WeekdaySaturday:
            return @"Saturday";
            break;
        case WeekdaySunday:
            return @"Sunday";
            break;
        default:
            break;
    }
}

@end
