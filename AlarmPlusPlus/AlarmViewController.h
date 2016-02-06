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
- (void) SetupWithAlarm: (Alarm *) alarm;
@end
