//
//  DateUtils.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 04/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+(NSDate*) dateByAddingDays: (int) days ToDate: (NSDate*) date;
+(NSDate*) dateOnNextWeekdayWithFlag: (int) weekdaysFlag FromDate: (NSDate*) date;
@end
