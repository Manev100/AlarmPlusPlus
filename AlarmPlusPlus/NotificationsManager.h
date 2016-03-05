//
//  NotificationsManager.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 05/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface NotificationsManager : NSObject
-(id)init;
//-(id)initWithAlarms: (NSMutableArray*) alarmsArray;
-(void)scheduleLocalNotificationWithAlarm:(Alarm *)alarm;
- (void) deactivateAlarm: (Alarm*) alarm;
-(void) activateAlarm: (Alarm*) alarm;

@property (strong, nonatomic) NSMutableArray* alarms;
@end
