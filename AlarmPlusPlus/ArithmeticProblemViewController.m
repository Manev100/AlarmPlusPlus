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

/// setup the viewcontroller.
/// compute a problem to display and save result
-(void) setupViewForDifficulty: (Difficulties) difficulty{
    ArithmeticProblemGenerator *APGen = [[ArithmeticProblemGenerator alloc] initWithDifficulty:difficulty];
    self.result = APGen.result;
    [self.problemField setText: [APGen getProblemString]];
}

/// returns wether answer was correct
-(BOOL) confirmResult{
    int input = [self.inputField.text intValue];
    if(self.result == input){
        return true;
    }else{
        return false;
    }
}

/// add - or remove - in the answer if signbutton was tapped
- (IBAction)signSwitchClicked:(id)sender {
    if ([self.inputField.text hasPrefix:@"-"]) {
        self.inputField.text = [self.inputField.text substringFromIndex:1];
    }else{
        self.inputField.text = [@"-" stringByAppendingString: self.inputField.text];
    }
}
@end
