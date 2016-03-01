//
//  AppDelegate.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 13/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"
#import "StatisticsManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *alarms;
@property (strong, nonatomic) StatisticsManager* statisticsManager;

-(NSMutableArray *) getAlarmArray;
-(StatisticsManager*) getStatisticsManager;
-(void) presentAlarmViewforAlarm: (Alarm*) alarm;
@end

