//
//  EditorTabBarController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 26/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "EditorTabBarController.h"
#import "APEditorViewController.h"
#import "EqEditorViewController.h"
#import "PrimeEditorViewController.h"

@interface EditorTabBarController ()

@end

@implementation EditorTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) saveAllInputs{
    NSArray* subviews = self.viewControllers;
    [(APEditorViewController*)[[[subviews objectAtIndex:0] viewControllers] objectAtIndex:0] saveInputs];
    [(EqEditorViewController*)[[[subviews objectAtIndex:1] viewControllers] objectAtIndex:0] saveInputs];
    [(PrimeEditorViewController*)[[[subviews objectAtIndex:2] viewControllers] objectAtIndex:0] saveInputs];
     
}

@end
