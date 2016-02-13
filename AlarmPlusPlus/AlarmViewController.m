//
//  AlarmViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 06/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "AlarmViewController.h"
#import "EquationViewController.h"

@interface AlarmViewController (){
    Alarm* myAlarm;
    int result;
    int x,y;
    int tries;
}

@end

@implementation AlarmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if(myAlarm == nil){
        myAlarm = [Alarm new];
    }
    [self.alarmName setText:myAlarm.name];
    
    [self setupProblem];
    self.equationContainer.alpha = 1;
    self.primeContainer.alpha = 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPressed:(id)sender {
    int input =  [self.numberInputField.text intValue];
    if(input == result){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{

        tries--;
        if(tries == 0){
            // problem failed
            [self setupProblem];
        }else{
            // flash screen red or something, music louder
            [self.triesLabel setText:[NSString stringWithFormat:@"Tries: %d", tries]];
        }
        
    }
    
    
}

- (void) setupProblem {
    x = arc4random_uniform(100);
    y = arc4random_uniform(100);
    
    result = x+y;
    [self.problemField setText: [NSString stringWithFormat:@"%d  +  %d  =", x, y]];
    
    tries = 3;
    [self.triesLabel setText:[NSString stringWithFormat:@"Tries: %d", tries]];
    
}



- (void)SetupWithAlarm: (Alarm *) alarm{
    myAlarm = alarm;
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
