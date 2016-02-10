//
//  Alarm.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 09/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject
- (id)init;


typedef NS_OPTIONS(NSInteger, Weekdays) {
    WeekdayMonday = 1 << 0,
    WeekdayTuesday = 1 << 1,
    WeekdayWednesday = 1 << 2,
    WeekdayThursday = 1 << 3,
    WeekdayFriday = 1 << 4,
    WeekdaySaturday = 1 << 5,
    WeekdaySunday = 1 << 6
};

+(NSString*) weekdayToString:(Weekdays)weekday;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ringtone;
@property (strong, nonatomic) NSString *problem;
@property (strong, nonatomic) NSString *difficulty;
@property (strong, nonatomic) NSString *alarmId;
@property int weekdaysFlag;
@property float volume;
@property bool repeat;

@property bool active;
@end
