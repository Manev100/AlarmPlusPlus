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
NSString *helloMessage = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.alarms = [appDelegate getAlarmArray];
    self.notficationsManager = [appDelegate getNotificationsManager];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    if(helloMessage != nil){
        [self confirmMessage:helloMessage];
        helloMessage = nil;
    }
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
            [self.notficationsManager deactivateAlarm:deletedAlarm];
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
    
    if(!alarm.active){
        [alarm activate];
        [self.notficationsManager scheduleLocalNotificationWithAlarm:alarm];
        [self confirmMessage:[self confirmAlarmMessageForAlarm:alarm]];
    }else{
        alarm.active = false;
        [self.notficationsManager deactivateAlarm:alarm];
    }

    [self.tableView reloadData];
}

#pragma mark - Segue Handling

- (IBAction)unwindToPlayersViewControllerAdd:(UIStoryboardSegue *)unwindSegue{
    AlarmAddViewController *vc = [unwindSegue sourceViewController];
    
    Alarm *alarm  = [Alarm new];
    
    alarm.ringtone = vc.ringtoneLabel.text;
    
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
    
    alarm.volume = vc.volumeSlider.value;
    alarm.repeat = vc.repeatLabel.isOn;
    
    alarm.name = vc.nameLabel.text;
    alarm.active = true;
    
    NSDate *pickedTime = vc.datePicker.date;
    NSIndexSet *selectedWeekdaysIndexSet = vc.weekdaysControl.selectedSegmentIndexes;
    
    // let the alarm initialise the remaining variables himself
    [alarm finishAlarmSetupWithTime:pickedTime AndWeekdays:selectedWeekdaysIndexSet];
    
    [self.alarms addObject:alarm];
    [self.tableView reloadData];
    [self.notficationsManager scheduleLocalNotificationWithAlarm:alarm];
    helloMessage = [self confirmAlarmMessageForAlarm:alarm];
}

- (IBAction)unwindToPlayersViewControllerCancel:(UIStoryboardSegue *)unwindSegue{
    
}

- (IBAction)unwindToEditorDone:(UIStoryboardSegue *)unwindSegue{
    [(EditorTabBarController*)unwindSegue.sourceViewController.tabBarController saveAllInputs];
}

- (IBAction)unwindToStatisticsBack:(UIStoryboardSegue *)unwindSegue{
    
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


-(NSString*) confirmAlarmMessageForAlarm: (Alarm*) alarm{
    NSTimeInterval timeTillAlarm = [alarm.date timeIntervalSinceNow];
    NSDateComponentsFormatter* formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    formatter.allowedUnits = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitYear;
    
    // Use the configured formatter to generate the string.
    NSString* outputString = [formatter stringFromTimeInterval:timeTillAlarm];
    
    return [NSString stringWithFormat:@"Alarm rings in %@.", outputString];
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
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
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
