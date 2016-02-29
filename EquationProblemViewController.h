//
//  EquationProblemViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "MathProblemViewController.h"

@interface EquationProblemViewController : MathProblemViewController
@property (weak, nonatomic) IBOutlet UILabel *problemField;
@property (weak, nonatomic) IBOutlet UITextField *firstInputField;
@property (weak, nonatomic) IBOutlet UITextField *secondInputField;


@property BOOL problemIsLinear;
@property BOOL problemIsQuadratic;
@property int resultX1;
@property int resultX2;


@end
