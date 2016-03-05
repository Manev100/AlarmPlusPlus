//
//  Alarm.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 09/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject <NSCoding>
- (id)init;
-(void) finishAlarmSetupWithTime: (NSDate*) pickedDate AndWeekdays: (NSIndexSet*) selectedWeekdays;
-(void) setToNextDate;
-(void) activate;

typedef NS_ENUM(NSInteger, Difficulties) {
    DifficultyEasy = 0,
    DifficultyNormal,
    DifficultyHard,
    DifficultyCustom,
    
    DifficulyCount
};

typedef NS_ENUM(NSInteger, ProblemTypes) {
    ProblemTypeArithmetic = 0,
    ProblemTypePrime,
    ProblemTypeEquation,
    
    ProblemTypeCount
};

typedef NS_OPTIONS(NSInteger, Weekdays) {
    WeekdayMonday = 1 << 0,
    WeekdayTuesday = 1 << 1,
    WeekdayWednesday = 1 << 2,
    WeekdayThursday = 1 << 3,
    WeekdayFriday = 1 << 4,
    WeekdaySaturday = 1 << 5,
    WeekdaySunday = 1 << 6
};

+(NSString*) difficultyToString:(Difficulties)difficulty;
+(NSString*) problemTypeToString:(ProblemTypes) problemType;
+(NSString*) weekdayToString:(Weekdays)weekday;
+(NSMutableArray*) weekdaysToArray;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ringtone;
@property ProblemTypes problem;
@property (strong, nonatomic) NSString *alarmId;
@property Difficulties difficulty;
@property int weekdaysFlag;
@property float volume;
@property bool repeat;
@property bool active;
@property int repeatsLeft;

@end
