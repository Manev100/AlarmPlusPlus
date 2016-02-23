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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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



-(void)textFieldEditingEnds :(UITextField *)theTextField{
    NSLog(@"%ld", (long)theTextField.tag);
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
    
    if(y < x){
        theTextField.text = [NSString stringWithFormat:@"%d", y];
        otherTextField.text = [NSString stringWithFormat:@"%d", y];
    }
    
    [self makePreview];
}

-(void) makePreview{
    EquationProblemGenerator *EPGen = [[EquationProblemGenerator alloc] initWithDifficulty:DifficultyHard];
    NSString *problemWithResult = [EPGen getResultString];
    [self.previewLabel setText:problemWithResult];
}

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
    
    
}

-(UITextField*) findTextFieldByTag: (int) tag{
    for(UITextField* textField in self.rangeTextFields){
        if(textField.tag == tag){
            return textField;
        }
    }
    return nil;
}

- (IBAction)signButtonPressed:(id)sender {
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
