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

@interface AlarmOverviewViewController ()

@end

@implementation AlarmOverviewViewController

/* sif (sender.selectedSegmentIndex == 0) {
[UIView animateWithDuration:(0.5) animations:^{
    self.containerViewA.alpha = 1;
    self.containerViewB.alpha = 0;
}];
} else {
    [UIView animateWithDuration:(0.5) animations:^{
        self.containerViewA.alpha = 0;
        self.containerViewB.alpha = 1;
    }];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarms = [NSMutableArray arrayWithCapacity:20];
    
    //TEST ALARMS
    Alarm *alarm1  = [Alarm new];
    alarm1.name = @"Test1";
    alarm1.date = [NSDate date];
    alarm1.active = true;
    alarm1.repeat = false;
    
    Alarm *alarm2  = [Alarm new];
    alarm2.name = @"Test1";
    alarm2.date = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
    alarm2.active = true;
    alarm2.repeat = true;
    
    [self.alarms addObject:alarm1];
    [self.alarms addObject:alarm2];
    
    
    // Register notification types
    UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TABLE DRAWING
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
    
    if(alarm.active == true){
        [cell.stateImage setImage:[UIImage imageNamed:@"alarm_icon_on.png"]];
    }else{
        [cell.stateImage setImage:[UIImage imageNamed:@"alarm_icon.png"]];
    }
    
    return cell;
}

// INTERACTIONS
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    
    alarm.active = !alarm.active;
    [self.tableView reloadData];
    
    // TODO: deaktivate/activate Notifications
    
}

// SEGUE HANDLING
- (IBAction)unwindToPlayersViewControllerAdd:(UIStoryboardSegue *)unwindSegue{
    AlarmAddViewController *vc = [unwindSegue sourceViewController];
    
    Alarm *alarm  = [Alarm new];
    alarm.date = vc.datePicker.date;
    //TODO: configure date if weekday is not today
    
    alarm.ringtone = vc.ringtoneLabel.text;
    alarm.problem = vc.problemLabel.text;
    alarm.difficulty = vc.difficultyLabel.text;
    alarm.volume = vc.volumeSlider.value;
    alarm.repeat = vc.repeatLabel.isOn;
    
    alarm.name = vc.nameLabel.text;
    alarm.active = true;
    
    [self.alarms addObject:alarm];
    [self.tableView reloadData];
}
- (IBAction)unwindToPlayersViewControllerCancel:(UIStoryboardSegue *)unwindSegue{
    
}


// NOTIFICATION SCHEDULING
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

/*alternative:
- (void)presentLocalNotificationNow:(UILocalNotification *)notification
*/

- (IBAction)test:(id)sender {
    NSDate *testDate = [self getDateWithMinutesFromNow:1];
    [self scheduleLocalNotificationWithDate:testDate];
    
    NSTimeInterval interval = [testDate timeIntervalSinceNow];
    long seconds = lroundf(interval);
    
    [self confirmMessage: [NSString stringWithFormat:@"%ld", seconds]];
}

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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
