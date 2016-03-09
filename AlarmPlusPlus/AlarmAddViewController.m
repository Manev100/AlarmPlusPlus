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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickAlarmtone"])
    {
        PickAlarmsoundViewController *vc;
        
        vc = segue.destinationViewController;
        vc.selectedAlarmsound = self.ringtoneLabel.text;
    }
}

///returning from choosing ringtone
- (IBAction)unwindToAlarmAddViewControllerSound:(UIStoryboardSegue *)unwindSegue{
    PickAlarmsoundViewController *vc = [unwindSegue sourceViewController];
    self.ringtoneLabel.text = vc.selectedAlarmsound;
}

/// returning from choosen problem type
- (IBAction)unwindToAlarmAddViewControllerProblem:(UIStoryboardSegue *)unwindSegue{
    
}

/// returning from choosen problem difficulty
- (IBAction)unwindToAlarmAddViewControllerDifficulty:(UIStoryboardSegue *)unwindSegue{
    
}

#pragma mark - Interactions
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

@end
