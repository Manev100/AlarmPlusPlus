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
typedef NS_ENUM(NSInteger, APTextFields) {
    APRangeOfOperantsX = 100,
    APRangeOfOperantsY = 101,
    APRangeOfResultX = 200,
    APRangeOfResultY = 201
};
@end

int const MAX_NUMBER_OF_OPERANDS = 4;

@implementation APEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    for(UITextField* textField in self.rangeTextFields){
        [textField addTarget:self action:@selector(textFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    [self.numberOfOperantsField addTarget:self action:@selector(numberOfOperandsFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.operatorsSegmentControl.delegate = self;
    
    self.countOfFaultyCells = 0;
    
    [self loadDefaults];
    
    [self makePreview];
}
-(void) loadDefaults{
    NSDictionary* defaultValues = [ProblemDefaults getArithmeticProblemDefaultsForDifficulty:DifficultyCustom];
    
    [self findTextFieldByTag:APRangeOfOperantsX].text = [((NSNumber*)[defaultValues objectForKey:@"operandsRangeX"]) description];
    [self findTextFieldByTag:APRangeOfOperantsY].text = [((NSNumber*)[defaultValues objectForKey:@"operandsRangeY"]) description];
    [self findTextFieldByTag:APRangeOfResultX].text = [((NSNumber*)[defaultValues objectForKey:@"resultRangeX"]) description];
    [self findTextFieldByTag:APRangeOfResultY].text = [((NSNumber*)[defaultValues objectForKey:@"resultRangeY"]) description];
    
    self.numberOfOperantsField.text = [((NSNumber*)[defaultValues objectForKey:@"numberOfOperands"]) description];
    
    int flag = [((NSNumber*)[defaultValues objectForKey:@"operatorsFlag"]) intValue];
    NSMutableIndexSet *selectedIndices = [NSMutableIndexSet indexSet];
    for(int i = 0; i < 4; i++){
        int mask = 1 << i;
        if((flag & mask) != 0){
            [selectedIndices addIndex:i];
        }
    }
    [self.operatorsSegmentControl setSelectedSegmentIndexes:(NSIndexSet*)selectedIndices];
    
    self.loadedDefaults = true;
}

-(UITextField*) findTextFieldByTag: (int) tag{
    for(UITextField* textField in self.rangeTextFields){
        if(textField.tag == tag){
            return textField;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)signButtonPressed:(id)sender{
    for(UITextField* textField in self.rangeTextFields){
        if(textField.isEditing){
            [self changeSign:textField];
        }
    }
}

-(void) changeSign:(UITextField*) textField{
    if ([textField.text hasPrefix:@"-"]) {
        textField.text = [textField.text substringFromIndex:1];
    }else{
        textField.text = [@"-" stringByAppendingString: textField.text ];
    }
}



// number of operands needs to be between 2 and MAX_NUMBER_OF_OPERANDS
-(void)numberOfOperandsFieldEditingEnds :(UITextField *)theTextField{
    int numberOfOperands = [theTextField.text intValue];
    if(numberOfOperands < 2){
        theTextField.text = @"2";
    }else if(numberOfOperands> MAX_NUMBER_OF_OPERANDS){
        theTextField.text = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_OPERANDS];
    }
    
    if(self.countOfFaultyCells <= 0){
        [self makePreview];
    }
}

-(void)textFieldEditingEnds :(UITextField *)theTextField{
    
    
    BOOL cellIsFaulty = false;
    if([theTextField.backgroundColor isEqual:[UIColor redColor]]){
        cellIsFaulty = true;
    }
    
    
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
    
    if( x > y && !cellIsFaulty){
        [theTextField setBackgroundColor:[UIColor redColor]];
        [otherTextField setBackgroundColor:[UIColor redColor]];
        self.countOfFaultyCells++;
    }else if(x <= y && cellIsFaulty){
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [otherTextField setBackgroundColor:[UIColor whiteColor]];
        self.countOfFaultyCells--;
    }
    
    if(self.countOfFaultyCells <= 0){
        [self makePreview];
    }else{
        [self displayMessageInPreview:@"Chosen Ranges not proper"];
    }
}

// one operator needs to be selected
-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmentedControl didChangeValue:(BOOL)selected atIndex:(NSUInteger)index {
    if([self.operatorsSegmentControl.selectedSegmentTitles count] <= 0){
        [self.operatorsSegmentControl setSelectedSegmentIndex:index];
    }
}


-(void) makePreview{
    NSDictionary* inputValues = [self saveInputsInDictionary];
    ArithmeticProblemGenerator *APGen = [[ArithmeticProblemGenerator alloc] initWithDictionary:inputValues];
    NSString *problemWithResult = [APGen getResultString];
    [self.previewLabel setText:problemWithResult];
}

-(void) displayMessageInPreview: (NSString*) message{
    self.previewLabel.text = message;
}



-(NSMutableDictionary*) saveInputsInDictionary{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:6];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfOperantsX].text intValue]) forKey:@"operandsRangeX"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfOperantsY].text intValue]) forKey:@"operandsRangeY"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfResultX].text intValue]) forKey:@"resultRangeX"];
    [dictionary setObject:@([[self findTextFieldByTag:APRangeOfResultY].text intValue]) forKey:@"resultRangeY"];
    [dictionary setObject:@([self.numberOfOperantsField.text intValue]) forKey:@"numberOfOperands"];
    
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
