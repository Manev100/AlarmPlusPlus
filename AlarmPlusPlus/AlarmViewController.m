//
//  AlarmViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 06/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "AlarmViewController.h"

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
    
    
    
    self.arithmeticContainer.alpha = 0;
    self.equationContainer.alpha = 0;
    self.primeContainer.alpha = 0;
    

    if(myAlarm.problem == ProblemTypeArithmetic){
        self.activeProblemViewController = [self.childProblemViewControllers objectForKey:@"arithmeticVC"];
        self.arithmeticContainer.alpha = 1;
    }else if (myAlarm.problem == ProblemTypeEquation){
        self.activeProblemViewController = [self.childProblemViewControllers objectForKey:@"equationVC"];
        self.equationContainer.alpha = 1;
    }else if(myAlarm.problem == ProblemTypePrime){
        self.activeProblemViewController = [self.childProblemViewControllers objectForKey:@"primeVC"];
        self.primeContainer.alpha = 1;
    }
    
    [self.activeProblemViewController setupViewForDifficulty:myAlarm.difficulty];
    tries = 3;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPressed:(id)sender {
    if([self.activeProblemViewController confirmResult]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"aaa");
        tries--;
        if(tries <= 0){
            // problem failed
            tries = 3;
            
            [self.activeProblemViewController setupViewForDifficulty:myAlarm.difficulty];
        }else{
            // flash screen red or something, music louder
        }
        [self.triesLabel setText:[NSString stringWithFormat:@"Tries: %d", tries]];
        
    }
}


- (void)SetupWithAlarm: (Alarm *) alarm{
    myAlarm = alarm;
}

//Access child viewcontrollers
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(self.childProblemViewControllers == nil){
        self.childProblemViewControllers = [NSMutableDictionary dictionaryWithCapacity:ProblemTypeCount];
    }

    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"container_embed_prime"]) {
        UIViewController * childViewController = (UIViewController *) [segue destinationViewController];
        [self.childProblemViewControllers setValue:childViewController forKey:@"primeVC"];
    }else if([segueName isEqualToString: @"container_embed_equation"]){
        UIViewController * childViewController = (UIViewController *) [segue destinationViewController];
        [self.childProblemViewControllers setValue:childViewController forKey:@"equationVC"];
    }else if([segueName isEqualToString: @"container_embed_arithmetic"]){
        UIViewController * childViewController = (UIViewController *) [segue destinationViewController];
        [self.childProblemViewControllers setValue:childViewController forKey:@"arithmeticVC"];
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
