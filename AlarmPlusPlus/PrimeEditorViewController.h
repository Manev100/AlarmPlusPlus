//
//  PrimeEditorViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 20/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"

@interface PrimeEditorViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *numberOfOptionsField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPrimesField;
@property (weak, nonatomic) IBOutlet UITextField *maxPrimeField;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *previewSegmentControl;
@property BOOL loadedDefaults;

-(void) saveInputs;
@end
