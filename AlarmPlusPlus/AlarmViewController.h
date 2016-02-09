//
//  AlarmViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 06/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AlarmViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *alarmName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *tries;
@property (weak, nonatomic) IBOutlet UILabel *alarmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *triesLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberInputField;
@property (weak, nonatomic) IBOutlet UILabel *problemField;


- (IBAction)submitPressed:(id)sender;
- (void) SetupWithAlarm: (Alarm *) alarm;
@end
