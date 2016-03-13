//
//  AlarmViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 06/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AlarmViewController.h"
#import "AppDelegate.h"
#import "NotificationsManager.h"


@interface AlarmViewController (){
    Alarm* myAlarm;
    int numberOfTries;
    AVAudioPlayer *audioPlayer;
}

@end

@implementation AlarmViewController

#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    if(myAlarm == nil){
        myAlarm = [Alarm new];
    }
    [self.alarmName setText:myAlarm.name];
    
    // Setup Timelabel
    [self updateTimeLabelToNow];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateEverySecond)
                                   userInfo:nil
                                    repeats:YES];
    
    
    // display selected Problem
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
    numberOfTries = 3;
    
    // get statistics manager and start a new session
    self.statisticsManager = [(AppDelegate*)[[UIApplication sharedApplication] delegate] getStatisticsManager];
    [self.statisticsManager startNewSessionWithType: myAlarm.problem AndDifficulty: myAlarm.difficulty];
    
    // play alarm sound
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], myAlarm.ringtone];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayer setVolume:myAlarm.volume];
    [audioPlayer setNumberOfLoops:200];
    [audioPlayer play];
}

- (void)SetupWithAlarm: (Alarm *) alarm{
    myAlarm = alarm;
}

/// Access child viewcontrollers and save reference in a dictionary
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/// Submit button pressed, checks if answer is correct and acts accordingly.
- (IBAction)submitPressed:(id)sender {
    if([self.activeProblemViewController confirmResult]){
        /// answer is correct: needs to record statistics, schedule next alarm, stop sounds, and dismiss itself
        [self.statisticsManager problemAnsweredCorrectly];
        // schedule next alarm if there is one
        [myAlarm setToNextDate];
        if(myAlarm.active){
            NotificationsManager* nm = [(AppDelegate*)[[UIApplication sharedApplication] delegate] getNotificationsManager];
            [nm scheduleLocalNotificationWithAlarm:myAlarm];
        }
        [audioPlayer stop];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // answer is wrong: record statistics, flash screen, maybe display a new problem
        [self.statisticsManager problemAnsweredWrongly];
        [self flashScreen];
        numberOfTries--;
        if(numberOfTries <= 0){
            // failed to answer problem correctly, display new problem
            numberOfTries = 3;
            [self.statisticsManager nextProblem];
            [self.activeProblemViewController setupViewForDifficulty:myAlarm.difficulty];
        }
        [self.triesLabel setText:[NSString stringWithFormat:@"Tries: %d", numberOfTries]];
        
    }
}

/// Dismiss numpad on touch Event
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

#pragma mark - Time
- (void)updateEverySecond {
    [self updateTimeLabelToNow];
}

- (void) updateTimeLabelToNow{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate: now];
}

#pragma mark - Screen Flash
/// Flash screen red
- (void)flashScreen{
    
    UIView *flashView;
    //make the view if we haven't already and add it as a subview
    if(flashView == nil)
    {
        flashView = [[UIView alloc]
                     initWithFrame:CGRectMake(0,
                                              0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height)];
        flashView.backgroundColor = [UIColor redColor];
        [self.view addSubview:flashView];
    }
    
    [flashView setAlpha:1.0f];
    
    
    //flash animation code
    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [flashView setAlpha:0.0f];
    
    [UIView commitAnimations];

}

@end
