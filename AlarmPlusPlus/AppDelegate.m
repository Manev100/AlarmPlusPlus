//
//  AppDelegate.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 13/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import "AppDelegate.h"
#import "AlarmViewController.h"
#import "Alarm.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notification != NULL){
        /*
        AlarmViewController *alarmVC = [[AlarmViewController alloc] init];
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:overviewVC animated:YES];
         */
        NSLog(@"%@", notification.alertTitle);
    }
    
    self.statisticsManager = [[StatisticsManager alloc] init];
    //LOAD ALL THE THINGS
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // SAVE ALL THE THINGS
    
    [self.statisticsManager saveSessionsToPlist];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        NSLog(@"Hello from background");
    }
    NSLog(@"Hello from foreground");
    
    // Look for alarm that fired notification
    NSString* firedAlarmId;
    Alarm *firedAlarm;
    if((firedAlarmId = [notification.userInfo objectForKey:@"alarm_id"]) != nil){
        for (Alarm* obj in self.alarms) {
            if([obj.alarmId isEqualToString:firedAlarmId]){
                firedAlarm = obj;
            }
        }
    }
    
    [self presentAlarmViewforAlarm:firedAlarm];
}

-(void) presentAlarmViewforAlarm: (Alarm*) alarm{
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;

    AlarmViewController *alarmVC = [nav.storyboard instantiateViewControllerWithIdentifier:@"alarmVC"];
    
    if(alarm != nil){
        [alarmVC SetupWithAlarm:alarm];
    }else{
        NSLog(@"Alarm could not be found. Loading Default Settings...");
    }
    [nav presentViewController:alarmVC animated:YES completion:nil];
  
    
}

-(NSMutableArray *) getAlarmArray{
    if(self.alarms == NULL){
        self.alarms = [NSMutableArray arrayWithCapacity:20];
    }
    return self.alarms;
}

-(StatisticsManager*) getStatisticsManager{
    if(self.statisticsManager == nil){
        self.statisticsManager = [[StatisticsManager alloc] init];
    }
    return self.statisticsManager;
}

@end
