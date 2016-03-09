//
//  PrimeEditorViewController.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 20/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "PrimeEditorViewController.h"
#import "PrimesProblemGenerator.h"
#import "ProblemDefaults.h"

@interface PrimeEditorViewController ()
// textfield to tag Enum
typedef NS_ENUM(NSInteger, PrimesTextFields) {
    PrimesNumberOfOptions = 100,
    PrimesNumberOfPrimes = 101,
    PrimesMaxPrimes = 102,
};

@end

int const MAX_NUMBER_OF_OPTIONS = 12;
int const MAX_NUMBER_OF_PRIMES = 12;
int const MAX_PRIME = 200;

@implementation PrimeEditorViewController
#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUserInteraction];
    [self loadDefaults];
    [self makePreview];
}

-(void) loadDefaults{
    NSDictionary* defaultValues = [ProblemDefaults getPrimeProblemDefaultsForDifficulty:DifficultyCustom];
    NSNumber* numberOfOptions = (NSNumber*)[defaultValues objectForKey:@"numberOfOptions"];
    NSNumber* numberOfPrimes = (NSNumber*)[defaultValues objectForKey:@"numberOfPrimes"];
    NSNumber* maxPrime = (NSNumber*)[defaultValues objectForKey:@"maxPrime"];
    
    self.numberOfOptionsField.text = [numberOfOptions description];
    self.numberOfPrimesField.text = [numberOfPrimes description];
    self.maxPrimeField.text = [maxPrime description];
}

#pragma mark - Control
/// Compute  a preview problem and display it
-(void) makePreview{
    PrimesProblemGenerator * pPGen = [[PrimesProblemGenerator alloc] initWithDictionary:[self saveInputsInDictionary]];
    
    // fill multiselectsegmentedcontrol
    [self.previewSegmentControl removeAllSegments];
    for(int i = 0; i< [pPGen.numberOfOptions intValue]; i++){
        NSNumber *numberToAdd = (NSNumber*)[pPGen.selectableNumbers objectAtIndex:i];
        NSString *numberString = [numberToAdd stringValue];
        [self.previewSegmentControl insertSegmentWithTitle:numberString atIndex:i animated:false];
    }
    // deselect all
    [self.previewSegmentControl selectAllSegments:false];
    self.loadedDefaults = true;
}

#pragma mark - User Interaction
/// Listen for editing ends control event on the textfields
-(void) setUpUserInteraction{
    [self.numberOfOptionsField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    [self.numberOfPrimesField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    [self.maxPrimeField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    
}


// Validating input
-(void)numFieldEditingEnds :(UITextField *)theTextField{
    int value;
    // which textfield was edited.
    // check if input is in bounds, else set it to be in bounds
    switch (theTextField.tag) {
        case PrimesNumberOfOptions:
            value  = [theTextField.text intValue];
            if(value < 1){
                theTextField.text = [NSString stringWithFormat:@"%d", 1];
            }else if(value > MAX_NUMBER_OF_OPTIONS){
                theTextField.text = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_OPTIONS];
            }
            break;
        case PrimesNumberOfPrimes:
            value  = [theTextField.text intValue];
            if(value < 1){
                theTextField.text = [NSString stringWithFormat:@"%d", 1];
            }else if(value > MAX_NUMBER_OF_PRIMES){
                theTextField.text = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_PRIMES];
            }
            break;
        case PrimesMaxPrimes:
            value  = [theTextField.text intValue];
            if(value < 1){
                theTextField.text = [NSString stringWithFormat:@"%d", 1];
            }else if(value > MAX_PRIME){
                theTextField.text = [NSString stringWithFormat:@"%d", MAX_PRIME];
            }
            
            break;
        default:
            break;
    }
    // only checked edge cases before
    [self validateInput];
    
    [self makePreview];
}

/// Validate the input of the 3 textfields
-(void) validateInput{
    int numOfOptions = [self.numberOfOptionsField.text intValue];
    int numOfPrimes = [self.numberOfPrimesField.text intValue];
    int maxPrime = [self.maxPrimeField.text intValue];
    
    // there cant be more primes than options
    if(numOfOptions < numOfPrimes){
        numOfOptions = numOfPrimes;
    }
    
    // maxPrime needs to be high enough so that there are enough primes
    // not good, need to retrieve primes list and count primes up to maxPrime
    if(maxPrime/2 + 1  < numOfPrimes){
        numOfPrimes = maxPrime/2 + 1;
    }
    
    self.numberOfOptionsField.text = [NSString stringWithFormat:@"%d", numOfOptions];
    self.numberOfPrimesField.text = [NSString stringWithFormat:@"%d", numOfPrimes];
    self.maxPrimeField.text = [NSString stringWithFormat:@"%d", maxPrime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 1;
    }
    return 0;
}

#pragma mark - Persistence
/// Get Inputs from the textfields and save them in a dictionary
-(NSMutableDictionary*) saveInputsInDictionary{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:@([self.numberOfOptionsField.text intValue]) forKey:@"numberOfOptions"];
    [dictionary setObject:@([self.numberOfPrimesField.text intValue]) forKey:@"numberOfPrimes"];
    [dictionary setObject:@([self.maxPrimeField.text intValue]) forKey:@"maxPrime"];
    
    return dictionary;
}

/// Gets Inputs in a dictionary and delegate ProblemDefaults to save them in a plist
-(void) saveInputs{
    if(self.loadedDefaults){
        NSLog(@"Saving values to plist...");
        NSMutableDictionary* valuesToSave = [self saveInputsInDictionary];
        NSLog(@"%@",[valuesToSave description]);
        [ProblemDefaults savePrimeProblemCustomDifficultyValues:valuesToSave];
    }else{
        NSLog(@"No need to save values");
    }
}



@end
