//
//  EqEditorViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 20/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "EqEditorViewController.h"
#import "ProblemDefaults.h"
#import "EquationProblemGenerator.h"

@interface EqEditorViewController ()
// textfield to tag Enum
typedef NS_ENUM(NSInteger, EquationEditorFields) {
    EqLinAX = 10,
    EqLinAY = 11,
    EqLinBX = 20,
    EqLinBY = 21,
    EqQuadAX = 30,
    EqQuadAY = 31,
    EqQuadBX = 40,
    EqQuadBY = 41,
    EqQuadCX = 50,
    EqQuadCY = 51
};
@end

@implementation EqEditorViewController
#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init event handling
    for(UITextField* textField in self.rangeTextFields){
        [textField addTarget:self action:@selector(textFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    [self loadDefaults];
    [self makePreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// Load defaul values from ProblemDefaults
-(void) loadDefaults{
    NSDictionary* defaultValues = [ProblemDefaults getEquationProblemDefaultsForDifficulty:DifficultyCustom];
    self.linearEquationsEnabled = [((NSNumber*)[defaultValues objectForKey:@"lin"]) boolValue];
    self.quadraticEquationsEnabled = [((NSNumber*)[defaultValues objectForKey:@"quad"]) boolValue];
    if(self.linearEquationsEnabled){
        [self.linQuadSegmentControl setSelectedSegmentIndex:0];
    }else{
        [self.linQuadSegmentControl setSelectedSegmentIndex:1];
    }
    
    [self findTextFieldByTag:EqLinAX].text = [((NSNumber*)[defaultValues objectForKey:@"linAX"]) description];
    [self findTextFieldByTag:EqLinAY].text = [((NSNumber*)[defaultValues objectForKey:@"linAY"]) description];
    [self findTextFieldByTag:EqLinBX].text = [((NSNumber*)[defaultValues objectForKey:@"linBX"]) description];
    [self findTextFieldByTag:EqLinBY].text = [((NSNumber*)[defaultValues objectForKey:@"linBY"]) description];
    [self findTextFieldByTag:EqQuadAX].text = [((NSNumber*)[defaultValues objectForKey:@"quadAX"]) description];
    [self findTextFieldByTag:EqQuadAY].text = [((NSNumber*)[defaultValues objectForKey:@"quadAY"]) description];
    [self findTextFieldByTag:EqQuadBX].text = [((NSNumber*)[defaultValues objectForKey:@"quadBX"]) description];
    [self findTextFieldByTag:EqQuadBY].text = [((NSNumber*)[defaultValues objectForKey:@"quadBY"]) description];
    [self findTextFieldByTag:EqQuadCX].text = [((NSNumber*)[defaultValues objectForKey:@"quadCX"]) description];
    [self findTextFieldByTag:EqQuadCY].text = [((NSNumber*)[defaultValues objectForKey:@"quadCY"]) description];
    
    self.loadedDefaults = true;
    
}
#pragma mark - Utils
/// returns Textfield assoziated with a tag
-(UITextField*) findTextFieldByTag: (int) tag{
    for(UITextField* textField in self.rangeTextFields){
        if(textField.tag == tag){
            return textField;
        }
    }
    return nil;
}
#pragma mark - Control
/// Compute  a preview problem and display it
-(void) makePreview{
    EquationProblemGenerator *EPGen = [[EquationProblemGenerator alloc] initWithDictionary:[self saveInputsInDictionary]];
    NSString *problemWithResult = [EPGen getResultString];
    [self.previewLabel setText:problemWithResult];
}

#pragma mark - User Interaction

/// Validate input of a range textfield that has been edited
-(void)textFieldEditingEnds :(UITextField *)theTextField{
    
    // find rangetextfield and its corresponding neighbor
    UITextField* otherTextField;
    BOOL linearEqEdited = true;
    int x,y;
    switch (theTextField.tag) {
        case EqLinAX:
            otherTextField = [self findTextFieldByTag: EqLinAY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case EqLinAY:
            otherTextField = [self findTextFieldByTag: EqLinAX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        case EqLinBX:
            otherTextField = [self findTextFieldByTag: EqLinBY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case EqLinBY:
            otherTextField = [self findTextFieldByTag: EqLinBX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        case EqQuadAX:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadAY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case EqQuadAY:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadAX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        case EqQuadBX:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadBY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case EqQuadBY:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadBX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        case EqQuadCX:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadCY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case EqQuadCY:
            linearEqEdited = false;
            otherTextField = [self findTextFieldByTag: EqQuadCX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        default:
            break;
    }
    
    // validate their inputs
    if(y < x){
        theTextField.text = [NSString stringWithFormat:@"%d", y];
        otherTextField.text = [NSString stringWithFormat:@"%d", y];
    }
    
    // make preview
    [self makePreview];
}

/// invert the currently edited textfield input
- (IBAction)signButtonPressed:(id)sender {
    for(UITextField* textField in self.rangeTextFields){
        // find textfield that is being edited currently
        if(textField.isEditing){
            // change the sign of its content
            [self changeSign:textField];
        }
    }
}

/// invert a textfields input
-(void) changeSign:(UITextField*) textField{
    if ([textField.text hasPrefix:@"-"]) {
        // input is negative, make it positive
        textField.text = [textField.text substringFromIndex:1];
    }else{
        // input is positive, make it negative
        textField.text = [@"-" stringByAppendingString: textField.text ];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        return 4;
    }else if(section == 3){
        return 1;
    }
    
    return 0;
}

#pragma mark - persistence
/// Get Inputs from the textfields and save them in a dictionary
-(NSMutableDictionary*) saveInputsInDictionary{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:6];
    [dictionary setObject:@([[self findTextFieldByTag:EqLinAX].text intValue]) forKey:@"linAX"];
    [dictionary setObject:@([[self findTextFieldByTag:EqLinAY].text intValue]) forKey:@"linAY"];
    [dictionary setObject:@([[self findTextFieldByTag:EqLinBX].text intValue]) forKey:@"linBX"];
    [dictionary setObject:@([[self findTextFieldByTag:EqLinBY].text intValue]) forKey:@"linBY"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadAX].text intValue]) forKey:@"quadAX"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadAY].text intValue]) forKey:@"quadAY"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadBX].text intValue]) forKey:@"quadBX"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadBY].text intValue]) forKey:@"quadBY"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadCX].text intValue]) forKey:@"quadCX"];
    [dictionary setObject:@([[self findTextFieldByTag:EqQuadCY].text intValue]) forKey:@"quadCY"];
    
    if(self.linQuadSegmentControl.selectedSegmentIndex == 0){
        [dictionary setObject:@(YES) forKey:@"lin"];
        [dictionary setObject:@(NO) forKey:@"quad"];
    }else{
        [dictionary setObject:@(NO) forKey:@"lin"];
        [dictionary setObject:@(YES) forKey:@"quad"];
    }
    
    return dictionary;
}

/// Gets Inputs in a dictionary and delegate ProblemDefaults to save them in a plist
-(void) saveInputs{
    if(self.loadedDefaults){
        NSLog(@"Saving values to plist...");
        NSMutableDictionary* valuesToSave = [self saveInputsInDictionary];
        NSLog(@"%@",[valuesToSave description]);
        [ProblemDefaults saveEquationProblemCustomDifficultyValues:valuesToSave];
    }else{
        NSLog(@"No need to save values");
    }
}

@end
