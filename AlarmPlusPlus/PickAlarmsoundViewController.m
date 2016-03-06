//
//  PickAlarmsoundViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 10/01/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PickAlarmsoundViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PickAlarmsoundViewController (){
    AVAudioPlayer *audioPlayer;
}

@end

@implementation PickAlarmsoundViewController

NSArray *alarmsounds;
NSUInteger selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Need to be filled with default system sounds
    alarmsounds = [NSArray arrayWithObjects:@"Beeps.mp3", @"Electronica.mp3", @"Hazard.mp3", @"Multi.mp3", @"Nice.mp3", @"Sun.mp3", @"Rio.mp3", @"School_Bell.mp3", @"Ship.mp3", @"Annoy.mp3", nil];
    
    selectedIndex = [alarmsounds indexOfObject:self.selectedAlarmsound];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self performSegueWithIdentifier:@"unwindToAAVC" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [alarmsounds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickAlarmsoundCell" forIndexPath:indexPath];
    cell.textLabel.text = [alarmsounds objectAtIndex:indexPath.row];
    
    if(indexPath.row == selectedIndex){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedIndex != NSNotFound)
    {
        UITableViewCell *cell;
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedAlarmsound = [alarmsounds objectAtIndex:indexPath.row];
    [self playSound];
}

-(void) playSound{
    if(audioPlayer != nil){
        [audioPlayer stop];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], self.selectedAlarmsound];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayer play];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(audioPlayer != nil){
        [audioPlayer stop];
    }
}


@end
