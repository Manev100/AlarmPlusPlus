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
    // allow superclass to initialize its state first
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
        
    }
    // note that you must explicitly return the newly created object
    return self;
}



@end
