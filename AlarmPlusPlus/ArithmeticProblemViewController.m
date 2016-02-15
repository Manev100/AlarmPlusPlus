//
//  ArithmeticProblemViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "ArithmeticProblemViewController.h"

@interface ArithmeticProblemViewController ()

@end

@implementation ArithmeticProblemViewController
int _result;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupViewForDifficulty: (Difficulties) difficulty{
    int x = arc4random_uniform(100);
    int y = arc4random_uniform(100);
    
    _result = x+y;
    [self.problemField setText: [NSString stringWithFormat:@"%d  +  %d  =", x, y]];
    
}

-(BOOL) confirmResult{
    int input = [self.inputField.text intValue];
    if(_result == input){
        return true;
    }else{
        return false;
    }
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
