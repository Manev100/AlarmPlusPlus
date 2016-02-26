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

- (void) setUpWithDifficulty: (Difficulties) difficulty{
    [self setUpWithDictionary:[ProblemDefaults getEquationProblemDefaultsForDifficulty:difficulty]];
    [self computeProblem];
}

- (void) setUpWithDictionary: (NSDictionary*) dictionary{
    /*NSArray* requiredKeys = [NSArray arrayWithObjects:@"linAX",@"linAY", @"linBX", @"linBY",@"quadAX", @"quadAY", @"quadBX",@"quadBY", @"quadCX", @"quadCY", "lin", @"quad" , nil];
    NSArray* objectsFound = [dictionary objectsForKeys:requiredKeys notFoundMarker:[NSNull null]];
    if([objectsFound containsObject:[NSNull null]]){
        NSLog(@"Invalid dictionary. Does not contain all necessary values.");
    }
    */
    self.equationRanges = dictionary;
    self.problemIsLinear = [(NSNumber*)[self.equationRanges objectForKey:@"lin"] boolValue];
    self.problemIsQuadratic = [(NSNumber*)[self.equationRanges objectForKey:@"quad"] boolValue];
    
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

-(void) computeProblem{
    if(self.problemIsLinear){
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
        
        self.x1 = [NSNumber numberWithInt: (-potentialB)/potentialA];
    }else if(self.problemIsQuadratic){
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
        
        self.x1 = [NSNumber numberWithInt: (-potentialB)/(2*potentialA) + sqrt(pow(potentialB/(2*potentialA),2) - (potentialC/potentialA))];
        self.x2 = [NSNumber numberWithInt: (-potentialB)/(2*potentialA) - sqrt(pow(potentialB/(2*potentialA),2) - (potentialC/potentialA))];
        
    }
    NSLog(@"x1 = %@, x2 = %@", self.x1, self.x2);
}

- (NSString*) getResultString{
    NSString* output = @"";
    if(self.problemIsLinear){
        if([self.a intValue] == 1){
            output = @"x ";
        }else if([self.a intValue] == -1){
            output = @"-x ";
        }else{
            output = [NSString stringWithFormat:@"%@x ", self.a];
        }
        
        if([self.b intValue] == 0){
            output = [output stringByAppendingFormat:@"= 0"];
        }else if([self.b intValue] < 0){
            output = [output stringByAppendingFormat:@"- %d = 0", abs([self.b intValue]) ];
        }else{
            output = [output stringByAppendingFormat:@"+ %@ = 0", self.b];
        }
    }else if (self.problemIsQuadratic){
        if([self.a intValue] == 1){
            output = @"x² ";
        }else if([self.a intValue] == -1){
            output = @"-x² ";
        }else{
            output = [NSString stringWithFormat:@"%@x² ", self.a];
        }
        
        if([self.b intValue] < 0){
            output = [output stringByAppendingFormat:@"- %dx ", abs([self.b intValue]) ];
        }else if([self.b intValue] > 0){
            output = [output stringByAppendingFormat:@"+ %@x ", self.b];
        }
        
        if([self.c intValue] == 0){
            output = [output stringByAppendingFormat:@"= 0"];
        }else if([self.c intValue] < 0){
            output = [output stringByAppendingFormat:@"- %d = 0", abs([self.c intValue]) ];
        }else{
            output = [output stringByAppendingFormat:@"+ %@ = 0", self.b];
        }
        
    }
    return output;
}


@end







