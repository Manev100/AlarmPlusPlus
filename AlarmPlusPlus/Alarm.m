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
        self.problem = @"a";
        self.difficulty = @"Normal";
        self.alarmId = @"0";
        self.volume = 1.0;
        self.active = true;
        self.repeat = false;
        self.weekdaysFlag = WeekdayMonday;
        
    }
    return self;
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
