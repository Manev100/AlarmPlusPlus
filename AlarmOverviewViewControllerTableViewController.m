//
//  AlarmOverviewViewControllerTableViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 14/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import "AlarmOverviewViewControllerTableViewController.h"
#import "AlarmCellTableViewCell.h"

@interface AlarmOverviewViewControllerTableViewController ()

@end

@implementation AlarmOverviewViewControllerTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmCellTableViewCell *cell;
    cell = (AlarmCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    cell.time.text = @"08:00";
    cell.name.text = @"My alarm";
    [cell.repeat setImage:[UIImage imageNamed:@"repeat_icon.png"]];
    [cell.stateImage setImage:[UIImage imageNamed:@"alarm_icon.png"]];
    return cell;
}


// NOTIFICATION HANDLING
- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate {
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = fireDate;
    notification.alertBody = @"Wake up!!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

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

// DETAILS NAV BAR ITEM ACTION SHEET HANDLING
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
            //editor
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
