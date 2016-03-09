//
//  DateUtils.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 04/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

/// returns a date thats set to a defined amount of days from a given date
+(NSDate*) dateByAddingDays: (int) days ToDate: (NSDate*) date{
     NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal dateByAddingUnit:NSCalendarUnitDay
                           value:days
                          toDate:date
                         options:0];
    
}

/// returns a date that is closest to a given date but including only days which weekdays are included in the weekdaysFlag.
/// lets say we have Wednesday, the 9th of March as the date and a weekdaysFlag including wednesday, friday and saturday. Then it would look for the closest friday since the next wednesday and saturday are later in the future.
+(NSDate*) dateOnNextWeekdayWithFlag: (int) weekdaysFlag FromDate: (NSDate*) date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    // get current weekday
    NSDateComponents *weekdayComp = [cal components:NSCalendarUnitWeekday fromDate:date];
    int currentWeekday = (int)[weekdayComp weekday];
    
    BOOL nextWeekdayFound = false;
    int daysToJump = 0;
    do{
        // we need to go to the next selected weekday
        // currentWeekday + daysToJump chooses next weekday, mask computation same as above
        daysToJump++;
        int weekdayMask = 1 << ((currentWeekday + daysToJump + 5) % 7);
        if((weekdaysFlag & weekdayMask) != 0){
            // next selected weekday is found
            nextWeekdayFound = true;
        }
    }while(!nextWeekdayFound);
    return [cal dateByAddingUnit:NSCalendarUnitDay
                                 value:daysToJump
                                toDate:date
                               options:0];

}

@end
