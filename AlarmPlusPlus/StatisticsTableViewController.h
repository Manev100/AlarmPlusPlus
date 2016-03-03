//
//  StatisticsTableViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 16/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticsManager.h"

@interface StatisticsTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *statistics;

@property (strong, nonatomic) StatisticsManager* statisticsManager;
@property (strong, nonatomic) NSMutableArray *generalLabelNames;
@property (strong, nonatomic) NSMutableArray *typesLabelNames;
@property (strong, nonatomic) NSMutableArray *difficultyLabelNames;

@property (strong, nonatomic) NSDictionary *generalStatistics;
@property (strong, nonatomic) NSDictionary *problemTypesStatistics;
@property (strong, nonatomic) NSDictionary *difficultyStatistics;

@end
