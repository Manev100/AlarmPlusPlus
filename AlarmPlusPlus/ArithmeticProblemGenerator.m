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
        [self setUpWithDictionary:dictionary];
    }
    return self;
}
/// Loads default values from ProblemDefaults and continues to setup
- (void) setUpWithDifficulty: (Difficulties) difficulty{
    NSDictionary* defaultValues = [ProblemDefaults getArithmeticProblemDefaultsForDifficulty:difficulty];
    [self setUpWithDictionary:defaultValues];
}

/// Extracts default values from dictionary and computes a arithmetic problem with them
- (void)setUpWithDictionary: (NSDictionary*) dictionary{
    // first check if dictionary has all required values
    NSArray* requiredKeys = [NSArray arrayWithObjects:@"operandsRangeX",@"operandsRangeY", @"resultRangeX",@"resultRangeY", @"operatorsFlag",@"numberOfOperands", nil];
    NSArray* objectsFound = [dictionary objectsForKeys:requiredKeys notFoundMarker:[NSNull null]];
    if([objectsFound containsObject:[NSNull null]]){
        NSLog(@"Invalid dictionary. Does not contain all necessary values.");
    }
    
    self.operandsRangeX = (NSNumber*)[dictionary objectForKey:@"operandsRangeX"];
    self.operandsRangeY = (NSNumber*)[dictionary objectForKey:@"operandsRangeY"];
    self.resultRangeX = (NSNumber*)[dictionary objectForKey:@"resultRangeX"];
    self.resultRangeY = (NSNumber*)[dictionary objectForKey:@"resultRangeY"];
    self.operatorsFlag = (NSNumber*)[dictionary objectForKey:@"operatorsFlag"];
    self.numberOfOperands = (NSNumber*)[dictionary objectForKey:@"numberOfOperands"];
    
    [self computeResult];
}

#pragma mark - Computation
/// Computes an arithmetic problem and its result, and returns if one could be found
- (BOOL) computeResult{
    // the operands and operators of the problem
    self.operands = [NSMutableArray arrayWithCapacity:[self.numberOfOperands intValue]];
    self.operators = [NSMutableArray arrayWithCapacity:[self.numberOfOperands intValue]-1];
    
    // avoid many type conversions
    int opRangeX = [self.operandsRangeX intValue];
    int opRangeY = [self.operandsRangeY intValue];
    int resRangeX = [self.resultRangeX intValue];
    int resRangeY = [self.resultRangeY intValue];
    
    int tries = 100;
    do{
        
        [self.operands removeAllObjects];
        [self.operators removeAllObjects];
        // we iterate over the operators(because of division) so we need one more operand
        // iterating in reverse because of devision
        int lastOperand = [self randomNumberInRangeX:opRangeX andY:opRangeY];
        [self.operands insertObject:[NSNumber numberWithInt:lastOperand] atIndex:0];
        for (int i = [self.numberOfOperands intValue]-2; i >= 0 ; i--) {
            //  there is one more operand thant operator
            // random operator
            int operator = [self randomOperatorForFlag:[self.operatorsFlag intValue]];
            
            //we dont't want two division operators after another because 2 / 2 / 2 = 1/2 and we want round numbers
            if([self.operators count] != 0){
                int lastOperator = [[self.operators objectAtIndex:0] intValue];
                if(lastOperator == OperatorDivide && operator == OperatorDivide){
                    operator = OperatorPlus;
                }
            }
            
            //check for division by zero then just choose different operator
            if(lastOperand == 0 && operator == OperatorDivide){
                operator = OperatorPlus;
            }
            [self.operators insertObject:[NSNumber numberWithInt:operator] atIndex:0];
            
            // next random operant
            // need to be careful when we divide
            if(operator == OperatorDivide){
                // randomize a number so that it is a multiple of the divisor and in the operands range
                // x and y changes then last operand is negative
                if(lastOperand > 0){
                    lastOperand = [self randomNumberInRangeX:opRangeX/lastOperand   andY:opRangeY/lastOperand]*lastOperand;
                }else if(lastOperand < 0){
                    lastOperand = [self randomNumberInRangeX:opRangeY/lastOperand   andY:opRangeX/lastOperand]*lastOperand;
                }
                
            }else{
                lastOperand = [self randomNumberInRangeX:opRangeX andY:opRangeY];
            }
            [self.operands insertObject:[NSNumber numberWithInt:lastOperand] atIndex:0];
        }
        
        // if nothing can be found, use default
        if(tries-- < 0){
            NSLog(@"Couldn't find good arithmetic problem");
            return false;
        }
        self.result = [self evaluateProblem];
    }while(self.result < resRangeX || self.result > resRangeY);
    
    return true;
}

/// Solves an arithmetic problem with operands stored in self.operands and self.operators.
/// Returns the result
- (int) evaluateProblem{
    NSMutableArray *operandsCpy = [NSMutableArray arrayWithArray:self.operands];
    NSMutableArray *operatorsCpy = [NSMutableArray arrayWithArray:self.operators];
    // For every step we have a subproblem a $ b , with $ being +,-,* or /
    // we solve this subproblem and save its result in a's spot in the operands array
    // we then delete $ and b from the arrays and continue
    
    // first loop to look for division/multiplication first
    for(int j=0; j< [operatorsCpy count]; j++){
        int operation = [[operatorsCpy objectAtIndex:j] intValue];
        if(operation == OperatorMultiply || operation == OperatorDivide){
            
            int a = [[operandsCpy objectAtIndex:j] intValue];
            int b = [[operandsCpy objectAtIndex:j+1] intValue];
            // Solve multiplication/division subproblem
            if(operation == OperatorMultiply ){
                [operandsCpy replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:a*b]];
            }else{
                [operandsCpy replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:a/b]];
            }
            [operatorsCpy removeObjectAtIndex:j];
            [operandsCpy removeObjectAtIndex:j+1];
            j--;
        }
    }
    
    // solve + and - in second loop
    while([operatorsCpy count] > 0){
        int operation = [[operatorsCpy objectAtIndex:0] intValue];
        int a = [[operandsCpy objectAtIndex:0] intValue];
        int b = [[operandsCpy objectAtIndex:1] intValue];
        
        // solve plus and minus subproblems
        if(operation == OperatorPlus){
            [operandsCpy replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:a+b]];
        }else if(operation == OperatorMinus){
            [operandsCpy replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:a-b]];
        }else{
            NSLog(@"Error");
        }
        
        [operandsCpy removeObjectAtIndex:1];
        [operatorsCpy removeObjectAtIndex:0];
    }
    return [[operandsCpy objectAtIndex:0] intValue];
}

#pragma mark - Output
/// Output string of problem + result
- (NSString*) getResultString{
    
    NSString* output = [self getProblemString];
    output = [NSString stringWithFormat:@"%@%d", output, self.result];
    return output;
}

/// Outputs string of problem
- (NSString*) getProblemString{
    NSString* output = [NSString stringWithFormat:@"%@ ",[self.operands objectAtIndex:0]];
    for(int i = 0; i< [self.numberOfOperands intValue] -1 ; i++){
        int operator = [[self.operators objectAtIndex:i] intValue];
        int operand = [[self.operands objectAtIndex:i+1] intValue];
        if(operand < 0){
            output = [NSString stringWithFormat:@"%@%@ (%@) ", output, [self getSignForOperator:operator] ,@(operand)];
        }else {
            output = [NSString stringWithFormat:@"%@%@ %@ ", output, [self getSignForOperator:operator] ,@(operand)];
        }
        
        
    }
    
    output = [NSString stringWithFormat:@"%@= ", output];
    
    return output;
}

#pragma mark - Utils
-(int) randomNumberInRangeX:(int) x andY: (int)y{
    return arc4random_uniform(y-x+1)+x;
}

/// Outputs a random operator that is selected in an operators flag.
/// + 0001, - 0010, * 0100, / 1000
/// flag mustn't be 0 or something like ...0000
-(int) randomOperatorForFlag: (int) flag{
    // try random operator and check if it's bit is set
    BOOL opFound = false;
    while(!opFound){
        int mask = 1<<arc4random_uniform(4);
        if((flag & mask) != 0){
            return mask;
        }
    }
    return 1;
}

/// Outputs a String sign for an operator enum
-(NSString*) getSignForOperator: (Operators) op{
    NSString *output = @"";
    switch (op) {
        case OperatorPlus:
            output = @"+";
            break;
        case OperatorMinus:
            output = @"-";
            break;
        case OperatorMultiply:
            output = @"x";
            break;
        case OperatorDivide:
            output = @"÷";
            break;
        default:
            break;
    }
    return output;
}

@end

