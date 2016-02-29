//
//  ArithmeticProblemViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "ArithmeticProblemViewController.h"
#import "ArithmeticProblemGenerator.h"

@interface ArithmeticProblemViewController ()

@end

@implementation ArithmeticProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupViewForDifficulty: (Difficulties) difficulty{
    ArithmeticProblemGenerator *APGen = [[ArithmeticProblemGenerator alloc] initWithDifficulty:difficulty];
    self.result = APGen.result;
    [self.problemField setText: [APGen getResultString]];
}

-(BOOL) confirmResult{
    int input = [self.inputField.text intValue];
    if(self.result == input){
        return true;
    }else{
        return false;
    }
}

- (IBAction)signSwitchClicked:(id)sender {
    if ([self.inputField.text hasPrefix:@"-"]) {
        self.inputField.text = [self.inputField.text substringFromIndex:1];
    }else{
        self.inputField.text = [@"-" stringByAppendingString: self.inputField.text];
    }
}
@end
