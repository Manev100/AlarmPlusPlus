//
//  StatisticsTableViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 16/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import "StatisticsTableViewController.h"
#import "AppDelegate.h"

@interface StatisticsTableViewController ()

@end

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.statisticsManager = [(AppDelegate*)[[UIApplication sharedApplication] delegate] getStatisticsManager];
    
    self.generalLabelNames = [NSMutableArray arrayWithObjects:@"Total time alarms rang",
                                                @"Number of solved problems",
                                                @"Number of wrong answers",
                                                @"Average tries before solving a problem",
                                                @"Average time needed to solve a problem",
                                                @"Average time per try",
                                                nil];
    
    self.typesLabelNames = [NSMutableArray arrayWithObjects:@"Number of arithmetic problems tried",
                            @"Number of arithmetic problems solved",
                            @"Number of equation problems tried",
                            @"Number of equation problems solved",
                            @"Number of prime problems tried",
                            @"Number of prime problems solved",
                            @"Percentage arithmetic/equation/prime",
                            nil];
    
    self.difficultyLabelNames = [NSMutableArray arrayWithObjects:@"Number of easy problems tried",
                                  @"Number of easy problems solved",
                                  @"Number of normal problems tried",
                                  @"Number of normal problems solved",
                                  @"Number of hard problems tried",
                                  @"Number of hard problems solved",
                                  @"Number of custom problems tried",
                                  @"Number of custom problems solved",
                                  @"Percentage easy/normal/hard/custom",
                                  nil];
    
    self.generalStatistics = [self.statisticsManager evaluateGeneralStatistics];
    self.problemTypesStatistics = [self.statisticsManager evaluateProblemTypeStatistics];
    self.difficultyStatistics = [self.statisticsManager evaluateDifficultyStatistics];
    
    
}



-(UILabel*) getLabelForRow:(int)row InSection: (int) section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.detailTextLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 9;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statCell" forIndexPath:indexPath];
    
    int row = (int)[indexPath row];
    int section = (int)[indexPath section];
    NSLog(@"%d %d", section, row);
    // go to section, go to row, and assign correct values
    switch (section) {
        case 0:
            cell.textLabel.text = (NSString*)[self.generalLabelNames objectAtIndex:row];
            switch (row) {
                case 0:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@s",[self.generalStatistics objectForKey:@"totalTime"]];
                    break;
                case 1:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.generalStatistics objectForKey:@"solves"]];
                    break;
                case 2:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.generalStatistics objectForKey:@"wrongTries"]];
                    break;
                case 3:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.generalStatistics objectForKey:@"averageTries"]];
                    break;
                case 4:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@s",[self.generalStatistics objectForKey:@"averageTime"]];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = (NSString*)[self.typesLabelNames objectAtIndex:row];
            switch (row) {
                case 0:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"aPTried"]];
                    break;
                case 1:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"aPSolved"]];
                    break;
                case 2:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"eqPTried"]];
                    break;
                case 3:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"eqPSolved"]];
                    break;
                case 4:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"pPTried"]];
                    break;
                case 5:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.problemTypesStatistics objectForKey:@"pPSolved"]];
                    break;
                case 6:
                    //string the 3 statistics together
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@/%@", [self.problemTypesStatistics objectForKey:@"percentageAP"],[self.problemTypesStatistics objectForKey:@"percentageEP"],[self.problemTypesStatistics objectForKey:@"percentagePP"]];;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            cell.textLabel.text = (NSString*)[self.difficultyLabelNames objectAtIndex:row];
            switch (row) {
                case 0:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"easyTries"]];
                    break;
                case 1:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"easySolves"]];
                    break;
                case 2:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"normalTries"]];
                    break;
                case 3:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"normalSolves"]];
                    break;
                case 4:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"hardTries"]];
                    break;
                case 5:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"hardSolves"]];
                    break;
                case 6:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"customTries"]];
                    break;
                case 7:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.difficultyStatistics objectForKey:@"customSolves"]];
                    break;
                case 8:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@", [self.difficultyStatistics objectForKey:@"percentageEasy"],[self.difficultyStatistics objectForKey:@"percentageNormal"],[self.difficultyStatistics objectForKey:@"percentageHard"], [self.difficultyStatistics objectForKey:@"percentageCustom"]];;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     switch (section) {
         case 0:
             return @"General";
             break;
         case 1:
             return @"Problem Types";
             break;
         case 2:
             return @"Difficulty";
             break;
         default:
             return @"";
             break;
     }
    
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
