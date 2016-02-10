//
//  AlarmCellTableViewCell.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 14/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *repeat;
@property (weak, nonatomic) IBOutlet UIStackView *weekdays;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@end
