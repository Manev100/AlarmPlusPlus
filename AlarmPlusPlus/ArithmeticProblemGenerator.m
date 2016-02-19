//
//  ArithmeticProblemGenerator.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 19/02/16.
//  Copyright © 2016 Marc Neveling. All rights reserved.
//

#import "ArithmeticProblemGenerator.h"
#import "ProblemDefaults.h"

@implementation ArithmeticProblemGenerator

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

- (void) setUpWithDifficulty: (Difficulties) difficulty{
    NSDictionary* defaultValues = [ProblemDefaults getArithmeticProblemDefaultsForDifficulty:difficulty];
    self.operandsRangeX = (NSNumber*)[defaultValues objectForKey:@"operandsRangeX"];
    self.operandsRangeY = (NSNumber*)[defaultValues objectForKey:@"operandsRangeY"];
    self.resultRangeX = (NSNumber*)[defaultValues objectForKey:@"resultRangeX"];
    self.resultRangeY = (NSNumber*)[defaultValues objectForKey:@"resultRangeY"];
    self.operatorsFlag = (NSNumber*)[defaultValues objectForKey:@"operatorsFlag"];
    self.numberOfOperands = (NSNumber*)[defaultValues objectForKey:@"numberOfOperands"];
    
    [self computeResult];
}

- (BOOL) computeResult{
    self.operands = [NSMutableArray arrayWithCapacity:[self.numberOfOperands intValue]];
    self.operators = [NSMutableArray arrayWithCapacity:[self.numberOfOperands intValue]-1];
    
    // that is not the way i think
    int operandsArray[[self.numberOfOperands intValue]];
    int operatorsArray[[self.numberOfOperands intValue]-1];
    
    // we iterate over the operators(because of division) so we need one more operand
    [self.operands addObject:[NSNumber numberWithInt:[self randomNumberInRangeX:[self.operandsRangeX intValue] andY:[self.operandsRangeY intValue]]]];
    for (int i = 0; i < [self.numberOfOperands intValue]-1; i++) {
        //  there is one more operand thant operator
        // random operator
        int operator = [self randomOperatorForFlag:[self.operatorsFlag intValue]];
        [self.operators addObject:[NSNumber numberWithInt:operator]];
        
        // random operant
        [self.operands addObject:[NSNumber numberWithInt:[self randomNumberInRangeX:[self.operandsRangeX intValue] andY:[self.operandsRangeY intValue]]]];
    }

    return true;
}

- (NSString*) getResultString{
    
    return @"";
}

-(int) randomNumberInRangeX:(int) x andY: (int)y{
    return arc4random_uniform(y-x+1)+x;
}

// + 1, - 10, * 100, / 1000
// flag mustn't be 0 or something like ...0000
-(int) randomOperatorForFlag: (int) flag{
    BOOL opFound = false;
    while(!opFound){
        int mask = 1<<arc4random_uniform(4);
        if((flag & mask) != 0){
            return mask;
        }
    }
    return 1;
}

@end

