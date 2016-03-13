//
//  EquationProblemGenerator.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 23/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "EquationProblemGenerator.h"
#import "ProblemDefaults.h"

@implementation EquationProblemGenerator
#pragma mark - Initialization
- (id)init{
    return [self initWithDifficulty:DifficultyNormal];
}

- (id)initWithDifficulty: (Difficulties) difficulty{
    if (self = [super init]) {
        self.chosenDifficulty = difficulty;
        [self setUpWithDifficulty:difficulty];
    }
    return self;
}

- (id)initWithDictionary: (NSDictionary*) dictionary{
    if (self = [super init]) {
        [self setUpWithDictionary: dictionary];
    }
    return self;
}

/// Loads default values from ProblemDefaults and continues to setup
- (void) setUpWithDifficulty: (Difficulties) difficulty{
    [self setUpWithDictionary:[ProblemDefaults getEquationProblemDefaultsForDifficulty:difficulty]];
    [self computeProblem];
}

/// Extracts default values from dictionary and computes a equation problem with them
- (void) setUpWithDictionary: (NSDictionary*) dictionary{
    self.equationRanges = dictionary;
    self.problemIsLinear = [(NSNumber*)[self.equationRanges objectForKey:@"lin"] boolValue];
    self.problemIsQuadratic = [(NSNumber*)[self.equationRanges objectForKey:@"quad"] boolValue];
    
    // if the problem can be linear or quadratic, coinflip to decide which to choose
    if(self.problemIsLinear && self.problemIsQuadratic){
        int coinflip = arc4random_uniform(2);
        if(coinflip == 0){
            self.problemIsLinear = NO;
        }else{
            self.problemIsQuadratic = NO;
        }
    }
    
    [self computeProblem];
}

#pragma mark - Computation
/// Computes an equation problem and its result
-(void) computeProblem{
    if(self.problemIsLinear){
        // linear equation problem
        // random two proper values and check if the problem is valid
        int rangeAX = [(NSNumber*)[self.equationRanges objectForKey:@"linAX"] intValue];
        int rangeAY = [(NSNumber*)[self.equationRanges objectForKey:@"linAY"] intValue];
        int rangeBX = [(NSNumber*)[self.equationRanges objectForKey:@"linBX"] intValue];
        int rangeBY = [(NSNumber*)[self.equationRanges objectForKey:@"linBY"] intValue];
        int potentialA = 0;
        int potentialB = 0;
        do{
            potentialA = arc4random_uniform((rangeAY - rangeAX) + 1) + rangeAX;
            potentialB = arc4random_uniform((rangeBY - rangeBX) + 1) + rangeBX;
        }while ((potentialA == 0)|| (potentialB == 0) || (potentialB % potentialA != 0));
        self.a = [NSNumber numberWithInt:potentialA];
        self.b = [NSNumber numberWithInt:potentialB];
        
        // compute result
        self.x1 = [NSNumber numberWithInt: (-potentialB)/potentialA];
    }else if(self.problemIsQuadratic){
        // linear quadratic problem
        // random three proper values and check if the problem is valid
        int rangeAX = [(NSNumber*)[self.equationRanges objectForKey:@"quadAX"] intValue];
        int rangeAY = [(NSNumber*)[self.equationRanges objectForKey:@"quadAY"] intValue];
        int rangeBX = [(NSNumber*)[self.equationRanges objectForKey:@"quadBX"] intValue];
        int rangeBY = [(NSNumber*)[self.equationRanges objectForKey:@"quadBY"] intValue];
        int rangeCX = [(NSNumber*)[self.equationRanges objectForKey:@"quadCX"] intValue];
        int rangeCY = [(NSNumber*)[self.equationRanges objectForKey:@"quadCY"] intValue];
        int potentialA = 0;
        int potentialB = 0;
        int potentialC = 0;
        BOOL foundGoodValues = false;
        
        do{
            potentialA = arc4random_uniform((rangeAY - rangeAX) + 1) + rangeAX;
            potentialB = arc4random_uniform((rangeBY - rangeBX) + 1) + rangeBX;
            potentialC = arc4random_uniform((rangeCY - rangeCX) + 1) + rangeCX;
            
            // validation
            // a mustn't be zero
            BOOL aNonZero = (potentialA != 0);
            if(aNonZero){
                // constraints on a,b,c
                BOOL bToARatioOK = (potentialB % 2*potentialA == 0);
                BOOL cToARationOK = (potentialC % potentialA == 0);
                BOOL sqrtWhole = false;
                
                // squaroot evaluates to whole number?
                if(bToARatioOK && cToARationOK){
                    int numberToSquare = pow(potentialB/(2*potentialA),2) - (potentialC/potentialA);
                    int squareRoot = sqrt(numberToSquare);
                    if(pow(squareRoot,2) == numberToSquare){
                        sqrtWhole = true;
                    }
                }
                
                if(sqrtWhole){
                    foundGoodValues = true;
                }
            }
        }while (!foundGoodValues);
        
        self.a = [NSNumber numberWithInt:potentialA];
        self.b = [NSNumber numberWithInt:potentialB];
        self.c = [NSNumber numberWithInt:potentialC];
        
        // compute result
        self.x1 = [NSNumber numberWithInt: (-potentialB)/(2*potentialA) + sqrt(pow(potentialB/(2*potentialA),2) - (potentialC/potentialA))];
        self.x2 = [NSNumber numberWithInt: (-potentialB)/(2*potentialA) - sqrt(pow(potentialB/(2*potentialA),2) - (potentialC/potentialA))];
        
    }
}

#pragma mark - Output
/// returns string of the equation
- (NSString*) getResultString{
    NSString* output = @"";
    // concatenate the componentes
    // check for special cases so it looks nice
    if(self.problemIsLinear){
        if([self.a intValue] == 1){
            // omit 1
            output = @"x ";
        }else if([self.a intValue] == -1){
            // omit 1
            output = @"-x ";
        }else{
            output = [NSString stringWithFormat:@"%@x ", self.a];
        }
        
        if([self.b intValue] == 0){
            // omit zeroes
            output = [output stringByAppendingFormat:@"= 0"];
        }else if([self.b intValue] < 0){
            // looks nicer with space between - and number
            output = [output stringByAppendingFormat:@"- %d = 0", abs([self.b intValue]) ];
        }else{
            // looks nicer with space between + and number
            output = [output stringByAppendingFormat:@"+ %@ = 0", self.b];
        }
    }else if (self.problemIsQuadratic){
        if([self.a intValue] == 1){
            // omit 1
            output = @"x² ";
        }else if([self.a intValue] == -1){
            // omit 1
            output = @"-x² ";
        }else{
            output = [NSString stringWithFormat:@"%@x² ", self.a];
        }
        
        if([self.b intValue] < 0){
            // looks nicer with space between - and number
            output = [output stringByAppendingFormat:@"- %dx ", abs([self.b intValue]) ];
        }else if([self.b intValue] > 0){
            // looks nicer with space between + and number
            output = [output stringByAppendingFormat:@"+ %@x ", self.b];
        }
        
        if([self.c intValue] == 0){
            // omit zeroes
            output = [output stringByAppendingFormat:@"= 0"];
        }else if([self.c intValue] < 0){
            // looks nicer with space between - and number
            output = [output stringByAppendingFormat:@"- %d = 0", abs([self.c intValue]) ];
        }else{
            // looks nicer with space between + and number
            output = [output stringByAppendingFormat:@"+ %@ = 0", self.c];
        }
        
    }
    return output;
}


@end







