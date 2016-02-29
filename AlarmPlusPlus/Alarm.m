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
        self.date = [NSDate date];
        self.name = @"Test1";
        self.ringtone = @"ring.mp3";
        self.problem = ProblemTypeEquation;
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

- (void) encodeWithCoder:(NSCoder *) coder{
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.ringtone forKey:@"ringtone"];
    [coder encodeInt:self.problem forKey:@"problemType"];
    [coder encodeObject:self.alarmId forKey:@"ID"];
    [coder encodeInt:self.difficulty forKey:@"difficulty"];
    [coder encodeInt:self.weekdaysFlag forKey:@"weekdaysFlag"];
    [coder encodeFloat:self.volume forKey:@"volume"];
    [coder encodeBool:self.repeat forKey:@"repeat"];
    [coder encodeBool:self.active forKey:@"active"];
}

- (id) initWithCoder:(NSCoder *) decoder{
    if(self = [super init]){
        self.date = [decoder decodeObjectForKey:@"date"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.ringtone = [decoder decodeObjectForKey:@"ringtone"];
        self.problem = [decoder decodeIntForKey:@"problem"];
        self.alarmId = [decoder decodeObjectForKey:@"ID"];
        self.difficulty = [decoder decodeIntForKey:@"difficulty"];
        self.weekdaysFlag = [decoder decodeIntForKey:@"weekdaysFlag"];
        self.volume = [decoder decodeFloatForKey:@"volume"];
        self.repeat = [decoder decodeBoolForKey:@"repeat"];
        self.active = [decoder decodeBoolForKey:@"active"];
        
    }
    return self;
}


@end

