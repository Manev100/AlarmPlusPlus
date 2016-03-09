//
//  EquationProblemViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 15/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "EquationProblemViewController.h"
#import "EquationProblemGenerator.h"

@interface EquationProblemViewController ()

@end

@implementation EquationProblemViewController
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
    EquationProblemGenerator* EqPGen = [[EquationProblemGenerator alloc] initWithDifficulty:difficulty];
    self.resultX1 = [EqPGen.x1 intValue];
    self.resultX2 = [EqPGen.x2 intValue];
    self.problemIsLinear = EqPGen.problemIsLinear;
    self.problemIsQuadratic = EqPGen.problemIsQuadratic;
    
    self.problemField.text = [EqPGen getResultString];
}

/// returns wether answer was correct
-(BOOL) confirmResult{
    int input1 = [self.firstInputField.text intValue];
    int input2 = [self.secondInputField.text intValue];
    
    if(self.problemIsLinear){
        if(input1 == self.resultX1 || input2 == self.resultX1){
            return true;
        }
    }else if(self.problemIsQuadratic){
        if((input1 == self.resultX1 && input2 == self.resultX2) || (input1 == self.resultX2 && input2 == self.resultX1)){
            return true;
        }
    }
    return false;
}

/// add - or remove - in the answer if signbutton was tapped
- (IBAction)signSwitch1Clicked:(id)sender {
    if ([self.firstInputField.text hasPrefix:@"-"]) {
        self.firstInputField.text = [self.firstInputField.text substringFromIndex:1];
    }else{
        self.firstInputField.text = [@"-" stringByAppendingString: self.firstInputField.text];
    }
}

/// add - or remove - in the answer if signbutton was tapped
- (IBAction)signSwitch2Clicked:(id)sender {
    if ([self.secondInputField.text hasPrefix:@"-"]) {
        self.secondInputField.text = [self.secondInputField.text substringFromIndex:1];
    }else{
        self.secondInputField.text = [@"-" stringByAppendingString: self.secondInputField.text];
    }
}
@end
