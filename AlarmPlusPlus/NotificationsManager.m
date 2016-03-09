//
//  NotificationsManager.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 05/03/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "NotificationsManager.h"

@implementation NotificationsManager
#pragma mark - Initialization
-(id)init{
    if(self = [super init]){
        // Register notification types
        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
    }
    return self;
}

#pragma mark - Notification Scheduling
/// Schedule a notifications for an alarm.
/// The alarm ID is saved in the user Info so alarm and notification can be found.
- (void)scheduleLocalNotificationWithAlarm:(Alarm *)alarm {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSCalendarUnitMinute;
    notification.fireDate = alarm.date;
    notification.alertBody = @"Wake up!!";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = [NSDictionary dictionaryWithObject:alarm.alarmId forKey:@"alarm_id"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"Alarm with ID %@ scheduled on %@.", alarm.alarmId, [alarm.date description]);
}

- (void) deactivateAlarm: (Alarm*) alarm{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    // loop all scheduled notifications, find the notification corresponding to the alarm and cancel it
    for(UILocalNotification *notification in notifications){
        NSString* alarmId = [notification.userInfo objectForKey:@"alarm_id"];
        if([alarmId isEqualToString:alarm.alarmId]){
            
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"Alarm with ID %@ deactivated,", alarmId);
        }
    }
}

-(void) activateAlarm: (Alarm*) alarm{
    [alarm setToNextDate];
    [self scheduleLocalNotificationWithAlarm:alarm];
    
}

- (void) rescheduleLocalNotificationWithAlarm:(Alarm *)alarm{
    [self deactivateAlarm: alarm];
    [self scheduleLocalNotificationWithAlarm:alarm];
}


-(void) displayNotificationsStatus{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in notifications){
        NSString* alarmId = [notification.userInfo objectForKey:@"alarm_id"];
        NSLog(@"Alarm: %@ on date: %@", alarmId, [notification.fireDate description]);
    }
}

-(void) cancelAllNotifications{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSLog(@"All notifications canceled");
}

@end
