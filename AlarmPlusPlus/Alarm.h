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


@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ringtone;
@property (strong, nonatomic) NSString *problem;
@property (strong, nonatomic) NSString *difficulty;
@property (strong, nonatomic) NSString *alarmId;
@property float volume;
@property bool repeat;
@property bool active;
@end
