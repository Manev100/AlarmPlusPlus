//
//  APEditorViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 18/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "APEditorViewController.h"

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
    [self findTextFieldByTag:APRangeOfOperantsX].text = @"0";
    [self findTextFieldByTag:APRangeOfOperantsY].text = @"2";
    [self findTextFieldByTag:APRangeOfResultX].text = @"0";
    [self findTextFieldByTag:APRangeOfResultY].text = @"2";
    
    [self.operatorsSegmentControl setSelectedSegmentIndex:0];
    
    self.numberOfOperantsField.text = @"2";
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
    }else if(section == 0){
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
    
    if( x > y){
        NSLog(@"range wrong");
        [theTextField setBackgroundColor:[UIColor redColor]];
        [otherTextField setBackgroundColor:[UIColor redColor]];
        if(cellIsFaulty){
            self.countOfFaultyCells++;
        }
    }else{
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [otherTextField setBackgroundColor:[UIColor whiteColor]];
        
        // if cell was faulty when editing started
        if(cellIsFaulty){
            self.countOfFaultyCells--;
        }
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
    
}

-(void) displayMessageInPreview: (NSString*) message{
    self.previewLabel.text = message;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
