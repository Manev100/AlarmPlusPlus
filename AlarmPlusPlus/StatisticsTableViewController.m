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
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [self fillInStatistics];
}

-(void) fillInStatistics{
    NSDictionary *generalStatistics = [self.statisticsManager evaluateGeneralStatistics];
    [self getLabelForRow:0 InSection:0].text = [NSString stringWithFormat:@"%@s",[generalStatistics objectForKey:@"totalTime"]];
    [self getLabelForRow:1 InSection:0].text = [NSString stringWithFormat:@"%@",[generalStatistics objectForKey:@"solves"]];
    [self getLabelForRow:2 InSection:0].text = [NSString stringWithFormat:@"%@",[generalStatistics objectForKey:@"wrongTries"]];
    [self getLabelForRow:3 InSection:0].text = [NSString stringWithFormat:@"%@",[generalStatistics objectForKey:@"averageTries"]];
    [self getLabelForRow:4 InSection:0].text = [NSString stringWithFormat:@"%@s",[generalStatistics objectForKey:@"averageTime"]];
    
    NSDictionary *problemTypesStatistics = [self.statisticsManager evaluateProblemTypeStatistics];
    [self getLabelForRow:0 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"aPTried"]];
    [self getLabelForRow:1 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"aPSolved"]];
    [self getLabelForRow:2 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"eqPTried"]];
    [self getLabelForRow:3 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"eqPSolved"]];
    [self getLabelForRow:4 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"pPTried"]];
    [self getLabelForRow:5 InSection:1].text = [NSString stringWithFormat:@"%@",[problemTypesStatistics objectForKey:@"pPSolved"]];
    NSString *typePercentages = [NSString stringWithFormat:@"%@/%@/%@", [problemTypesStatistics objectForKey:@"percentageAP"],[problemTypesStatistics objectForKey:@"percentageEP"],[problemTypesStatistics objectForKey:@"percentagePP"]];
    [self getLabelForRow:6 InSection:1].text = typePercentages;
    
    NSDictionary *difficultyStatistics = [self.statisticsManager evaluateDifficultyStatistics];
    [self getLabelForRow:0 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"easyTries"]];
    [self getLabelForRow:1 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"easySolves"]];
    [self getLabelForRow:2 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"normalTries"]];
    [self getLabelForRow:3 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"normalSolves"]];
    [self getLabelForRow:4 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"hardTries"]];
    [self getLabelForRow:5 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"hardSolves"]];
    [self getLabelForRow:6 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"customTries"]];
    [self getLabelForRow:7 InSection:2].text = [NSString stringWithFormat:@"%@",[difficultyStatistics objectForKey:@"customSolves"]];
    NSString* diffPercentages = [NSString stringWithFormat:@"%@/%@/%@/%@", [difficultyStatistics objectForKey:@"percentageEasy"],[difficultyStatistics objectForKey:@"percentageNormal"],[difficultyStatistics objectForKey:@"percentageHard"], [difficultyStatistics objectForKey:@"percentageCustom"]];
    [self getLabelForRow:8 InSection:2].text = diffPercentages;
    
    NSLog(@"%@ %@ %@", [generalStatistics description], [problemTypesStatistics description], [difficultyStatistics description]);
    
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
