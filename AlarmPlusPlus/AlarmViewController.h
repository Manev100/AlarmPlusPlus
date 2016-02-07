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


- (IBAction)submitPressed:(id)sender;
- (void) SetupWithAlarm: (Alarm *) alarm;
@end
