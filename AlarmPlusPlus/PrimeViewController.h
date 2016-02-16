//
//  PrimeViewController.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "MathProblemViewController.h"
#import "MultiSelectSegmentedControl.h"

@interface PrimeViewController : MathProblemViewController
    @property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *primeSelectSegmentControl;
    @property (strong, nonatomic) NSArray *primes;
    @property (strong, nonatomic) NSMutableIndexSet *correctSelections;
@end
