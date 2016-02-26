//
//  APEditorViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 18/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"

@interface APEditorViewController : UITableViewController <MultiSelectSegmentedControlDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberOfOperantsField;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *operatorsSegmentControl;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *rangeTextFields;
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property int countOfFaultyCells;
@property BOOL loadedDefaults;


- (IBAction)signButtonPressed:(id)sender;
-(void) saveInputs;

@end
