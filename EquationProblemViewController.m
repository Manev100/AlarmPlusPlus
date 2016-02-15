//
//  EquationProblemViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "EquationProblemViewController.h"

@interface EquationProblemViewController ()

@end

@implementation EquationProblemViewController
int _x1;
int _x2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupViewForDifficulty: (Difficulties) difficulty{
    // TODO: Negative numbers
    _x1 = arc4random_uniform(10);
    _x2 = arc4random_uniform(10);
    int a = -(_x1 + _x2);
    int b = _x1*_x2;
    
    self.problemField.text = [self buildEquationStringWitha: a Andb: b];
}

-(BOOL) confirmResult{
    int input1 = [self.firstInputField.text intValue];
    int input2 = [self.secondInputField.text intValue];
    if((input1 == _x1 && input2 == _x2) || (input1 == _x2 && input2 == _x1)){
        return true;
    }
    return false;
}

-(NSString*) buildEquationStringWitha:(int) a Andb:(int)b{
    NSString *str = @"x² ";
    if(a > 0){
        str = [str stringByAppendingFormat:@"+ %dx ", a];
    }else if(a < 0){
        str = [str stringByAppendingFormat:@"- %dx ", -a];
    }
    
    if(b > 0){
        str = [str stringByAppendingFormat:@"+ %d ", b];
    }else if (b < 0){
        str = [str stringByAppendingFormat:@"- %d ", -b];
    }
    
    str = [str stringByAppendingFormat:@"= 0"];
    
    return str;
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
