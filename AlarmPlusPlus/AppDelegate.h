//
//  AppDelegate.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 13/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *alarms;

-(NSMutableArray *) getAlarmArray;
-(void) presentAlarmViewforAlarm: (Alarm*) alarm;
@end

