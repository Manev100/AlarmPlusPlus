//
//  AlarmAddViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 09/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "AlarmAddViewController.h"
#import "PickAlarmsoundViewController.h"
#import "Alarm.h"

@interface AlarmAddViewController ()

@end

@implementation AlarmAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToAlarmAddViewControllerSound:(UIStoryboardSegue *)unwindSegue{
    PickAlarmsoundViewController *vc = [unwindSegue sourceViewController];
    self.ringtoneLabel.text = vc.selectedAlarmsound;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickAlarmtone"])
    {
        PickAlarmsoundViewController *vc;
        
        vc = segue.destinationViewController;
        vc.selectedAlarmsound = self.ringtoneLabel.text;
    }
}

- (IBAction)unwindToAlarmAddViewControllerProblem:(UIStoryboardSegue *)unwindSegue{
    
}


- (IBAction)unwindToAlarmAddViewControllerDifficulty:(UIStoryboardSegue *)unwindSegue{
    
}
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
        case 3:{
            //alarmsound

            break;
        }
        case 5:{
            //problem
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Problem to solve:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    [Alarm problemTypeToString:ProblemTypeArithmetic],
                                    [Alarm problemTypeToString:ProblemTypePrime],
                                    [Alarm problemTypeToString:ProblemTypeEquation],
                                    nil];
            popup.tag = 1;
            [popup showInView:self.view];
            break;
        }
        case 6:{
            //difficulty
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select difficulty:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    [Alarm difficultyToString:DifficultyEasy],
                                    [Alarm difficultyToString:DifficultyNormal],
                                    [Alarm difficultyToString:DifficultyHard],
                                    [Alarm difficultyToString:DifficultyCustom],
                                    nil];
            popup.tag = 2;
            [popup showInView:self.view];
            break;
        }
    }
    
}






- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1){
        switch (buttonIndex) {
            case 0:
                //arithmetic
                self.problemLabel.text = @"Arithmetic Problem";
                break;
            case 1:
                // prime-numbers
                self.problemLabel.text = @"Prime-Numbers";
                break;
            case 2:
                //equation
                self.problemLabel.text = @"Equation";
                break;
            case 3:
                //cancel
                break;
        }
    }else if(actionSheet.tag == 2){
        switch (buttonIndex) {
            case 0:
                //easy
                self.difficultyLabel.text = @"Easy";
                break;
            case 1:
                // normal
                self.difficultyLabel.text = @"Normal";
                break;
            case 2:
                //hard
                self.difficultyLabel.text = @"Hard";
                break;
            case 3:
                //custom
                self.difficultyLabel.text = @"Custom";
                break;
            case 4:
                //cancel
                break;
        }
    }
}
#pragma GCC diagnostic pop

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}


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
