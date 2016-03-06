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
#import "ProblemDefaults.h"

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
    
    [self checkForResetRequsts];
    
    self.statisticsManager = [[StatisticsManager alloc] init];
    self.alarms = [self loadAlarmsFromPlist];
    self.notificationsManager = [[NotificationsManager alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // SAVE ALL THE THINGS
    
    [self.statisticsManager saveSessionsToPlist];
    [self saveAlarmsToPlist];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkForResetRequsts];
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
        
    }
    
    // Stop repeating this notification
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
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
    //UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    UIViewController *vc = [self topViewController];
    AlarmViewController *alarmVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"alarmVC"];
    
    if(alarm != nil){
        [alarmVC SetupWithAlarm:alarm];
    }else{
        NSLog(@"Alarm could not be found. Loading Default Settings...");
    }
    [vc presentViewController:alarmVC animated:YES completion:nil];
  
    
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

-(NotificationsManager*) getNotificationsManager{
    if(self.notificationsManager == nil){
        self.notificationsManager = [[NotificationsManager alloc] init];
    }
    return self.notificationsManager;
    
}

#pragma mark - Alarms Persistence

-(BOOL) saveAlarmsToPlist{
    NSLog(@"Saving alarms...");
    BOOL status = [NSKeyedArchiver archiveRootObject:self.alarms toFile:[self getAlarmsPlistFileName]];
    if (!status) {
        NSLog(@"Error saving alarms");
        return false;
    }
    return true;
}

-(NSMutableArray*) loadAlarmsFromPlist{
    NSLog(@"Loading alarms...");
    NSMutableArray* loadedAlarms = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getAlarmsPlistFileName]];;
    if(loadedAlarms == nil){
        loadedAlarms = [NSMutableArray array];
    }
    NSLog(@"%@",[loadedAlarms description]);
    return loadedAlarms;
}

-(NSString*) getAlarmsPlistFileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *finalPath = [documentsPath stringByAppendingString:@"Alarms.plist"];
    return finalPath;
}

-(void) resetData{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    if(![fileManager removeItemAtPath: [self getAlarmsPlistFileName] error:&error]){
        NSLog(@"%@", error);
    }
    [self.alarms removeAllObjects];
    [self.notificationsManager cancelAllNotifications];
}

-(void) checkForResetRequsts{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"reset_all"]){
        [self resetData];
        [self.statisticsManager resetData];
        [ProblemDefaults resetValues];
    }else {
        if([defaults boolForKey:@"reset_alarms"]){
            [self resetData];
        }
        if([defaults boolForKey:@"reset_statistics"]){
            [self.statisticsManager resetData];
        }
        if([defaults boolForKey:@"reset_editor"]){
            [ProblemDefaults resetValues];
        }
    }
    
    // set all to NO so it's not resetting again
    [defaults setBool:NO forKey:@"reset_all"];
    [defaults setBool:NO forKey:@"reset_alarms"];
    [defaults setBool:NO forKey:@"reset_statistics"];
    [defaults setBool:NO forKey:@"reset_editor"];
    
}


// find the topViewController so alarms are pushed from everywhere
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


@end
