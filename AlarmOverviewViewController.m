//
//  AlarmOverviewViewControllerTableViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 14/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import "AlarmOverviewViewController.h"
#import "AlarmCellTableViewCell.h"
#import "Alarm.h"
#import "AlarmAddViewController.h"
#import "AppDelegate.h"
#import "EditorTabBarController.h"
#import "DateUtils.h"

@interface AlarmOverviewViewController ()

@end

@implementation AlarmOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.alarms = [appDelegate getAlarmArray];
    
    // Register notification types
    UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.alarms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmCellTableViewCell *cell;
    cell = (AlarmCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    //TODO: fill alarms array correctely
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    cell.name.text = alarm.name;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:alarm.date
                                                                    dateStyle:NSDateFormatterNoStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
    
    cell.time.text = dateString;
    
    if(alarm.repeat == true){
        [cell.repeat setImage:[UIImage imageNamed:@"repeat_icon.png"]];
    }
    [cell.stateButton setImage:[UIImage imageNamed:@"alarm_icon.png"] forState:UIControlStateNormal];
    
    NSArray *weekdayViews = cell.weekdays.arrangedSubviews;
    
    //iterate over weekdays and check whether flag for that weekday is checked and set tint for active state
    for(int i = 0; i < 7; i++){
        int mask = 1 << i;
        UILabel *label = (UILabel*)[weekdayViews objectAtIndex:i];
        if((alarm.weekdaysFlag & mask) != 0){
            [label setFont:[UIFont boldSystemFontOfSize:14]];
            [label setTextColor:[UIColor greenColor]];
        }else{
            [label setTextColor:[UIColor blackColor]];
        }
    }
    
    // Set tints for activated/deactivated Alarms
    if(alarm.active == true){
        [cell.time setTextColor:[UIColor blackColor]];
        [cell.name setTextColor:[UIColor blackColor]];
        [cell.stateButton setTintColor:[UIColor greenColor]];
        [cell.repeat setTintColor:[UIColor blackColor]];
    }else{
        for (UIView *view in weekdayViews){
            UILabel *label = (UILabel*) view;
            [label setTextColor:[UIColor grayColor]];
        }
        [cell.time setTextColor:[UIColor grayColor]];
        [cell.name setTextColor:[UIColor grayColor]];
        [cell.stateButton setTintColor:[UIColor grayColor]];
        [cell.repeat setTintColor:[UIColor grayColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Alarm *deletedAlarm = (Alarm*) [self.alarms objectAtIndex:indexPath.row];
        [self.alarms removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        if(deletedAlarm.active){
            //TODO: dequeue alarm
        }
        
    }
}

#pragma mark - User Interaction

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (IBAction)activeButtonPressed:(id)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    alarm.active = !alarm.active;
    
    
    //TODO: deaktivate/activate Notifications
    [self.tableView reloadData];
}

- (IBAction)test:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate presentAlarmViewforAlarm:nil];
    /*
     NSDate *testDate = [self getDateWithMinutesFromNow:1];
     [self scheduleLocalNotificationWithDate:testDate];
     
     NSTimeInterval interval = [testDate timeIntervalSinceNow];
     long seconds = lroundf(interval);
     
     [self confirmMessage: [NSString stringWithFormat:@"%ld", seconds]];
     */
}

#pragma mark - Segue Handling

- (IBAction)unwindToPlayersViewControllerAdd:(UIStoryboardSegue *)unwindSegue{
    AlarmAddViewController *vc = [unwindSegue sourceViewController];
    
    Alarm *alarm  = [Alarm new];
    
    //alarm.ringtone = vc.ringtoneLabel.text;
    alarm.ringtone = @"alarm.caf";
    
    //Parse difficulty
    for (int i = 0; i < DifficulyCount; ++i){
        NSString *difficultyStr = [Alarm difficultyToString:(Difficulties) i];
        if([difficultyStr isEqualToString:vc.difficultyLabel.text]){
            alarm.difficulty = (Difficulties) i;
        }
    }
    
    //parse selected Problem Type
    for (int i = 0; i < ProblemTypeCount; ++i){
        NSString *problemStr = [Alarm problemTypeToString:(ProblemTypes) i];
        if([problemStr isEqualToString:vc.problemLabel.text]){
            alarm.problem = (ProblemTypes) i;
        }
    }
    
    
    // Parse Selected weekdays from segmented control
    NSMutableArray *weekdaysArray = [Alarm weekdaysToArray];
    NSIndexSet *selectedWeekdaysIndexSet = vc.weekdaysControl.selectedSegmentIndexes;
    int weekdaysFlag = 0;
    for (NSNumber *weekday in [weekdaysArray objectsAtIndexes:selectedWeekdaysIndexSet]){
        weekdaysFlag += [weekday intValue];
    }
    alarm.weekdaysFlag = weekdaysFlag;
    // no weekday set(weekdaysFlag == 0) is handled later
    
    alarm.volume = vc.volumeSlider.value;
    alarm.repeat = vc.repeatLabel.isOn;
    
    alarm.name = vc.nameLabel.text;
    alarm.active = true;
    
    // id should be unique. name + time of creating
    double timeInterval = [[NSDate date] timeIntervalSince1970];
    alarm.alarmId = [NSString stringWithFormat:@"%@%f", alarm.name, timeInterval];
    
    
    // we now have to choose the correct next date the alarm is fired.
    // if we pick a time that is earlier (or equal) than the current time, we
    //  - pick tommorrow if no weekday is selected
    //  - pick next day that is a selected weekday
    // if we pick a time that is later than the current time, we
    // - pick now if the weekday is the same or no weekday has been selected
    // - pick next day that is a selected weekday
    NSDate *pickedTime = vc.datePicker.date;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // extract year, month, day, hour, minute, we dont need seconds nad milliseconds
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [cal components:unitFlags fromDate:pickedTime];
    
    NSDate *pickedDate = [cal dateFromComponents:comps];
    
    // get current weekday
    NSDateComponents *weekdayComp = [cal components:NSCalendarUnitWeekday fromDate:pickedDate];
    int currentWeekday = (int)[weekdayComp weekday];
    // we want to us NSDateCompoennt convenience methods to get weekdays,
    // NSDateComponents weekday method assigns 1 - sunday, 2 - monday,..., 7 - saturday
    // Alarm.h Weekdays assigns 1<<0 - monday, 1<<1 - tuesday,...
    // we need to map x=1 to y=6, x=2 to y=0 , x=3 to y=1, ... => y = x+5 mod 7
    int weekdayMask = 1 << ((currentWeekday + 5) % 7);
    
    if([pickedTime timeIntervalSinceNow] <= 0){
        if(alarm.weekdaysFlag == 0){
            // pick tomorrow
            pickedDate = [DateUtils dateByAddingDays:1 ToDate:pickedDate];
            // set weekdaysFlag bc it wasn't set before
            alarm.weekdaysFlag = 1 << ((currentWeekday + 1 + 5) % 7);
        }else{
            // pick day with next selected weekday
            pickedDate = [DateUtils dateOnNextWeekdayWithFlag:alarm.weekdaysFlag FromDate:pickedDate];
        }
        
    }else{
        if(alarm.weekdaysFlag == 0){
            // picked Date is correct, need to set weekdaysFlag
            alarm.weekdaysFlag = 1 << ((currentWeekday + 5) % 7);
        }else if ((alarm.weekdaysFlag & weekdayMask) == 0){
            pickedDate = [DateUtils dateOnNextWeekdayWithFlag:alarm.weekdaysFlag FromDate:pickedDate];
        }
        // picked date is correct if alarm.weekdaysFlag & weekdayMask) != 0
        
    }
    
    alarm.date = pickedDate;
    
    [self.alarms addObject:alarm];
    [self.tableView reloadData];
    [self scheduleLocalNotificationWithAlarm:alarm];
}

- (IBAction)unwindToPlayersViewControllerCancel:(UIStoryboardSegue *)unwindSegue{
    
}

- (IBAction)unwindToEditorDone:(UIStoryboardSegue *)unwindSegue{
    [(EditorTabBarController*)unwindSegue.sourceViewController.tabBarController saveAllInputs];
}

- (IBAction)unwindToStatisticsBack:(UIStoryboardSegue *)unwindSegue{
    
}

#pragma mark - Notification Scheduling

- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate {
    /*
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"ACCEPT_CATEGORY";
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextMinimal];
    
    */
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //notification.repeatInterval = NSCalendarUnitMinute;
    notification.fireDate = fireDate;
    notification.alertBody = @"Wake up!!";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = [NSDictionary dictionaryWithObject:@"123456" forKey:@"alarm_id"];
    //notification.category = @"ACCEPT_CATEGORY";

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)scheduleLocalNotificationWithAlarm:(Alarm *)alarm {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //notification.repeatInterval = NSCalendarUnitMinute;
    notification.fireDate = alarm.date;
    notification.alertBody = @"Wake up!!";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = [NSDictionary dictionaryWithObject:alarm.alarmId forKey:@"alarm_id"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/*alternative:
- (void)presentLocalNotificationNow:(UILocalNotification *)notification
*/



- (NSDate *)getDateWithMinutesFromNow: (int) num {
    NSDate *now = [NSDate date];
    NSCalendar *currentCal = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:num];
    [offsetComponents setSecond:0];
    return [currentCal dateByAddingComponents:offsetComponents
                            toDate:now
                            options:0];
    
}

- (void)confirmMessage: (NSString*) message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alarm set!"
                                                                    message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/*
//handle action
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler{
    
    completionHandler();
}
*/

// DETAILS NAV BAR ITEM ACTION SHEET HANDLING
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (IBAction)detailsButtonClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:@"Settings",@"Editor",@"Statistics",nil];
    
    [actionSheet showFromBarButtonItem:self.detailsButton animated:YES];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
        case 0:
            //settings
            break;
        case 1:
            [self performSegueWithIdentifier:@"EditorSegue" sender:self];
            break;
        case 2:
            //statistics
            [self performSegueWithIdentifier:@"StatisticsSegue" sender:self];
            break;
        case 3:
            //cancel
            break;
    }
}

#pragma GCC diagnostic pop


@end
