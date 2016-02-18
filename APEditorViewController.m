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

@implementation APEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    for(UITextField* textField in self.rangeTextFields){
        [textField addTarget:self action:@selector(textFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    [self loadDefaults];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 4;
    }else if(section == 0){
        return 1;
    }else{
        return 0;
    }
}

-(void)textFieldEditingEnds :(UITextField *)theTextField{
    //validate
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
