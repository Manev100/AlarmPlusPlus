//
//  APEditorViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 18/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "APEditorViewController.h"
#import "ArithmeticProblemGenerator.h"
#import "ProblemDefaults.h"
#import "Alarm.h"

@interface APEditorViewController ()
// textfield to tag Enum
typedef NS_ENUM(NSInteger, APTextFields) {
    APRangeOfOperantsX = 100,
    APRangeOfOperantsY = 101,
    APRangeOfResultX = 200,
    APRangeOfResultY = 201
};
@end

int const MAX_NUMBER_OF_OPERANDS = 4;

@implementation APEditorViewController
#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init event handling
    for(UITextField* textField in self.rangeTextFields){
        [textField addTarget:self action:@selector(textFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    [self.numberOfOperantsField addTarget:self action:@selector(numberOfOperandsFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.operatorsSegmentControl.delegate = self;
    
    self.countOfFaultyCells = 0;
    
    [self loadDefaults];
    
    [self makePreview];
}

/// Load defaul values from ProblemDefaults
-(void) loadDefaults{
    NSDictionary* defaultValues = [ProblemDefaults getArithmeticProblemDefaultsForDifficulty:DifficultyCustom];
    
    [self findTextFieldByTag:APRangeOfOperantsX].text = [((NSNumber*)[defaultValues objectForKey:@"operandsRangeX"]) description];
    [self findTextFieldByTag:APRangeOfOperantsY].text = [((NSNumber*)[defaultValues objectForKey:@"operandsRangeY"]) description];
    [self findTextFieldByTag:APRangeOfResultX].text = [((NSNumber*)[defaultValues objectForKey:@"resultRangeX"]) description];
    [self findTextFieldByTag:APRangeOfResultY].text = [((NSNumber*)[defaultValues objectForKey:@"resultRangeY"]) description];
    
    self.numberOfOperantsField.text = [((NSNumber*)[defaultValues objectForKey:@"numberOfOperands"]) description];
    
    // compute the indices(of the operators) that are selected from the flag
    int flag = [((NSNumber*)[defaultValues objectForKey:@"operatorsFlag"]) intValue];
    NSMutableIndexSet *selectedIndices = [NSMutableIndexSet indexSet];
    for(int i = 0; i < 4; i++){
        // i = 0: is + selected, i = 1: is - selected, etc.
        int mask = 1 << i;
        if((flag & mask) != 0){
            [selectedIndices addIndex:i];
        }
    }
    [self.operatorsSegmentControl setSelectedSegmentIndexes:(NSIndexSet*)selectedIndices];
    
    self.loadedDefaults = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 4;
    }else if(section == 1){
        return 1;
    }else{
        return 0;
    }
}

#pragma mark - User Interaction
/// invert the currently edited textfield input
- (IBAction)signButtonPressed:(id)sender{
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


/// Validate the input of the number of operands field
/// number of operands needs to be between 2 and MAX_NUMBER_OF_OPERANDS
-(void)numberOfOperandsFieldEditingEnds :(UITextField *)theTextField{
    int numberOfOperands = [theTextField.text intValue];
    // if the input is out of bounds change it to fit the bound
    if(numberOfOperands < 2){
        theTextField.text = @"2";
    }else if(numberOfOperands> MAX_NUMBER_OF_OPERANDS){
        theTextField.text = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_OPERANDS];
    }
    // make preview if input is good
    if(self.countOfFaultyCells <= 0){
        [self makePreview];
    }
}

/// Validate input of a range textfield that has been edited
-(void)textFieldEditingEnds :(UITextField *)theTextField{
    // remember if we edited a good textfield or a bad one
    BOOL cellIsFaulty = false;
    if([theTextField.backgroundColor isEqual:[UIColor redColor]]){
        cellIsFaulty = true;
    }
    
    // find rangetextfield and its corresponding neighbor
    UITextField* otherTextField;
    int x,y;
    switch (theTextField.tag) {
        case APRangeOfOperantsX:
            otherTextField = [self findTextFieldByTag: APRangeOfOperantsY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case APRangeOfOperantsY:
            otherTextField = [self findTextFieldByTag: APRangeOfOperantsX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        case APRangeOfResultX:
            otherTextField = [self findTextFieldByTag: APRangeOfResultY];
            x = [theTextField.text intValue];
            y = [otherTextField.text intValue];
            break;
        case APRangeOfResultY:
            otherTextField = [self findTextFieldByTag: APRangeOfResultX];
            x = [otherTextField.text intValue];
            y = [theTextField.text intValue];
            break;
        default:
            break;
    }
    
    // validate their inputs
    if( x > y && !cellIsFaulty){
        [theTextField setBackgroundColor:[UIColor redColor]];
        [otherTextField setBackgroundColor:[UIColor redColor]];
        self.countOfFaultyCells++;
    }else if(x <= y && cellIsFaulty){
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [otherTextField setBackgroundColor:[UIColor whiteColor]];
        self.countOfFaultyCells--;
    }
    
    // make preview if all inputs are good
    if(self.countOfFaultyCells <= 0){
        [self makePreview];
    }else{
        [self displayMessageInPreview:@"Chosen Ranges not proper"];
    }
}

/// one operator needs to be selected
-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmentedControl didChangeValue:(BOOL)selected atIndex:(NSUInteger)index {
    if([self.operatorsSegmentControl.selectedSegmentTitles count] <= 0){
        [self.operatorsSegmentControl setSelectedSegmentIndex:index];
    }
}

#pragma mark - Control
/// Compute  a preview problem and display it
-(void) makePreview{
    NSDictionary* inputValues = [self saveInputsInDictionary];
    ArithmeticProblemGenerator *APGen = [[ArithmeticProblemGenerator alloc] initWithDictionary:inputValues];
    NSString *problemWithResult = [APGen getResultString];
    [self.previewLabel setText:problemWithResult];
}

-(void) displayMessageInPreview: (NSString*) message{
    self.previewLabel.text = message;
}


#pragma mark - Persistence
/// Get Inputs from the textfields and save them in a dictionary
-(NSMutableDictionary*) saveInputsInDictionary{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:6];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfOperantsX].text intValue]) forKey:@"operandsRangeX"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfOperantsY].text intValue]) forKey:@"operandsRangeY"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfResultX].text intValue]) forKey:@"resultRangeX"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfResultY].text intValue]) forKey:@"resultRangeY"];
    [dictionary setObject:@([self.numberOfOperantsField.text intValue]) forKey:@"numberOfOperands"];
    
    // the selected indices need to be translated to a flag
    NSIndexSet* indexes =  self.operatorsSegmentControl.selectedSegmentIndexes;
    int flag = 0;
    for(int i = 0; i < 4; i++){
        if([indexes containsIndex:i]){
            flag += (1 << i);
        }
    }
    [dictionary setObject:@(flag) forKey:@"operatorsFlag"];
    
    return dictionary;
}

/// Gets Inputs in a dictionary and delegate ProblemDefaults to save them in a plist
-(void) saveInputs{
    if(self.loadedDefaults){
        NSLog(@"Saving values to plist...");
        NSMutableDictionary* valuesToSave = [self saveInputsInDictionary];
        NSLog(@"%@",[valuesToSave description]);
        [ProblemDefaults saveArithmeticProblemCustomDifficultyValues:valuesToSave];
    }else{
        NSLog(@"No need to save values");
    }
}

@end
