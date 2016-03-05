//
//  Alarm.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 09/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "Alarm.h"
#import "DateUtils.h"

@implementation Alarm

#pragma mark - Initialization
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

// sets weekdaysflag, id, date and repeatsLeft
-(void) finishAlarmSetupWithTime: (NSDate*) pickedDate AndWeekdays: (NSIndexSet*) selectedWeekdays{
    [self computeWeekdaysFlagFromIndexSet: selectedWeekdays];
    [self makeId];
    [self pickDateWithTime:pickedDate];
    
    // how many repeats are planned
    if(self.repeat){
        self.repeatsLeft = INT_MAX;
    }else{
        int numberOfSelectedWeekday = (int)[selectedWeekdays count];
        if(numberOfSelectedWeekday == 0){
            self.repeatsLeft = 1;
        }else {
            self.repeatsLeft = numberOfSelectedWeekday;
            
        }
    }
    
}



-(void) computeWeekdaysFlagFromIndexSet: (NSIndexSet*) selectedWeekdaysIndexSet{
    NSMutableArray *weekdaysArray = [Alarm weekdaysToArray];
    int weekdaysFlag = 0;
    for (NSNumber *weekday in [weekdaysArray objectsAtIndexes:selectedWeekdaysIndexSet]){
        weekdaysFlag += [weekday intValue];
    }
    self.weekdaysFlag = weekdaysFlag;
}



-(void) makeId{
    double timeInterval = [[NSDate date] timeIntervalSince1970];
    self.alarmId = [NSString stringWithFormat:@"%@%f", self.name, timeInterval];
}

-(void) pickDateWithTime: (NSDate*) pickedTime{
    // we now have to choose the correct next date the alarm is fired.
    // if we pick a time that is earlier (or equal) than the current time, we
    //  - pick tommorrow if no weekday is selected
    //  - pick next day that is a selected weekday
    // if we pick a time that is later than the current time, we
    // - pick now if the weekday is the same or no weekday has been selected
    // - pick next day that is a selected weekday
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // extract year, month, day, hour, minute, we dont need seconds nad milliseconds
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [cal components:unitFlags fromDate:pickedTime];
    
    NSDate *pickedDate = [cal dateFromComponents:comps];
    
    // get current weekday
    NSDateComponents *weekdayComp = [cal components:NSCalendarUnitWeekday fromDate:pickedDate];
    int currentWeekday = (int)[weekdayComp weekday];
    // we want to us NSDateCompoennt convenience methods to get weekdays,
    // NSDateComponents weekday method assigns 1 - sunday, 2 - monday,..., 7 - saturday
    // Alarm.h Weekdays assigns 1<<0 - monday, 1<<1 - tuesday,...
    // we need to map x=1 to y=6, x=2 to y=0 , x=3 to y=1, ... => y = x+5 mod 7
    int weekdayMask = 1 << ((currentWeekday + 5) % 7);
    
    if([pickedTime timeIntervalSinceNow] <= 0){
        if(self.weekdaysFlag == 0){
            // pick tomorrow
            pickedDate = [DateUtils dateByAddingDays:1 ToDate:pickedDate];
            // set weekdaysFlag bc it wasn't set before
            self.weekdaysFlag = 1 << ((currentWeekday + 1 + 5) % 7);
        }else{
            // pick day with next selected weekday
            pickedDate = [DateUtils dateOnNextWeekdayWithFlag:self.weekdaysFlag FromDate:pickedDate];
        }
        
    }else{
        if(self.weekdaysFlag == 0){
            // picked Date is correct, need to set weekdaysFlag
            self.weekdaysFlag = 1 << ((currentWeekday + 5) % 7);
        }else if ((self.weekdaysFlag & weekdayMask) == 0){
            pickedDate = [DateUtils dateOnNextWeekdayWithFlag:self.weekdaysFlag FromDate:pickedDate];
        }
        // picked date is correct if alarm.weekdaysFlag & weekdayMask) != 0
        
    }
    
    self.date = pickedDate;
    
}

#pragma mark - Controlling Dates

// sets the date to the next time the alarm rings, deactivates if no repeats left
-(void) setToNextDate{
    self.repeatsLeft--;
    if(self.repeat == NO && self.repeatsLeft <= 0){
        self.active = false;
    }else{
        [self setToNextDateFromNow];
    }
}

// set the active boolean, set next date to nearest weekday, set repeatsLeft to number of weekdays
-(void) activate{
    if(!self.active){
        self.active = true;
        [self setToNextDateFromNow];
        int numberOfWeekdays = 0;
        for(int i = 0; i<7; i++){
            if((self.weekdaysFlag & (1 << i)) != 0){
                numberOfWeekdays++;
            }
        }
        self.repeatsLeft = numberOfWeekdays;
    }
}

-(void) setToNextDateFromNow{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *compsNow = [cal components:unitFlags fromDate:now];
    NSDateComponents *compsDate = [cal components:unitFlags fromDate:self.date];
    compsNow.hour = compsDate.hour;
    compsNow.minute = compsDate.minute;
    self.date = [cal dateFromComponents:compsNow];
    
    // self.date is now today but set to the alarm time
    // but the weekday isn't correct propably
    
    NSMutableArray *possibleDates = [NSMutableArray arrayWithCapacity:7];
    for(int i = 0; i< 8; i++){
        // bruteforce: add up to 7 days to date and check if the weekday is set in the weekdaysflag
        NSDate *date = [DateUtils dateByAddingDays:i ToDate:self.date];
        
        NSDateComponents *weekdayComp = [cal components:NSCalendarUnitWeekday fromDate:date];
        int weekday = (int)[weekdayComp weekday];
        
        int weekdayMask = 1 << ((weekday + 5) % 7);
        if((self.weekdaysFlag & weekdayMask) != 0){
            [possibleDates addObject:date];
        }
    }
    // choose first date that is in the future
    for(NSDate *date in possibleDates){
        if([date timeIntervalSinceNow] > 0){
            self.date = date;
            break;
        }
    }
}

#pragma mark - Utils

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

#pragma mark - NSCoding
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
    [coder encodeInt:self.repeatsLeft forKey:@"repeatsLeft"];
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
        self.repeatsLeft = [decoder decodeIntForKey:@"repeatsLeft"];
        
    }
    return self;
}


@end

