//
//  AlarmOverviewViewControllerTableViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 14/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsManager.h"

@interface AlarmOverviewViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *alarms;
@property (strong, nonatomic) NotificationsManager *notficationsManager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailsButton;


@end
