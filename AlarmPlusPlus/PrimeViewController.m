//
//  PrimeViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PrimeViewController.h"

@interface PrimeViewController ()

@end

@implementation PrimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int primesArray[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,    47,     53,     59,     61,     67,     71,
        73,     79,     83,     89,     97,    101,    103,    107,    109,    113,
        127,    131,    137,    139,    149,    151,    157,    163,    167,    173,
        179,    181,   191,    193,    197,    199};
    
    self.primes = [NSMutableArray arrayWithCapacity:sizeof(primesArray)];
    for(int i = 0; i<sizeof(primesArray); i++){
        [self.primes addObject:[NSNumber numberWithInt:primesArray[i]]];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupViewForDifficulty: (Difficulties) difficulty{
    int numberOfOptions = 7;
    int numberOfprimes = 4;
    
    
    
}

-(BOOL) confirmResult{
    
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
