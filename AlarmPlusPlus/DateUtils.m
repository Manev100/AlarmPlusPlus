//
//  DateUtils.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 04/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+(NSDate*) dateByAddingDays: (int) days ToDate: (NSDate*) date{
     NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal dateByAddingUnit:NSCalendarUnitDay
                           value:days
                          toDate:date
                         options:0];
    
}
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
