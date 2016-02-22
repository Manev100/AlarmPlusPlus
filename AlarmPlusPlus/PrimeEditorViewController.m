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

-(void) makePreview{
    PrimesProblemGenerator * pPGen = [[PrimesProblemGenerator alloc] initWithDifficulty:DifficultyCustom];
    
    [self.previewSegmentControl removeAllSegments];
    for(int i = 0; i< [pPGen.numberOfOptions intValue]; i++){
        NSNumber *numberToAdd = (NSNumber*)[pPGen.selectableNumbers objectAtIndex:i];
        NSString *numberString = [numberToAdd stringValue];
        [self.previewSegmentControl insertSegmentWithTitle:numberString atIndex:i animated:false];
    }
    
    [self.previewSegmentControl selectAllSegments:false];
}

-(void) setUpUserInteraction{
    [self.numberOfOptionsField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    [self.numberOfPrimesField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    [self.maxPrimeField addTarget:self action:@selector(numFieldEditingEnds:) forControlEvents:UIControlEventEditingDidEnd];
    
}


// Validating input
-(void)numFieldEditingEnds :(UITextField *)theTextField{
    int value;
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

-(void) validateInput{
    int numOfOptions = [self.numberOfOptionsField.text intValue];
    int numOfPrimes = [self.numberOfPrimesField.text intValue];
    int maxPrime = [self.maxPrimeField.text intValue];
    
    if(numOfOptions < numOfPrimes){
        numOfOptions = numOfPrimes;
    }
    
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
