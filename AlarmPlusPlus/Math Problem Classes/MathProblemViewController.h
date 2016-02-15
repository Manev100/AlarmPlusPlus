//
//  MathProblemViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//
//  ABSTRACT CLASS: should not be instantiated

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface MathProblemViewController : UIViewController
-(void) setupViewForDifficulty: (Difficulties) difficulty;
-(BOOL) confirmResult;
@end
