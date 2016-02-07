//
//  AlarmViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 06/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController (){
    Alarm* myAlarm;
}

@end

@implementation AlarmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if(myAlarm == nil){
        myAlarm = [Alarm new];
    }
    [self.alarmName setText:myAlarm.name];
    NSLog(@"didload");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)SetupWithAlarm: (Alarm *) alarm{
    myAlarm = alarm;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
