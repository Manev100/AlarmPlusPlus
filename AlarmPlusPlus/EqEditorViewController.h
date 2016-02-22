//
//  EqEditorViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 20/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqEditorViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *linQuadSegmentControl;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *rangeTextFields;
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property BOOL linearEquationsEnabled;
@property BOOL quadraticEquationsEnabled;

- (IBAction)signButtonPressed:(id)sender;

@end
