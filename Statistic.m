//
//  Statistic.m
//  AlarmPlusPlus
//
//  Created by Justin Sane on 16/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import "Statistic.h"

@implementation Statistic
- (id)init{
    // allow superclass to initialize its state first
    if (self = [super init]) {
             // do our initialization...
            self.name = @"default name";
            self.value = 0;
    }
    // note that you must explicitly return the newly created object 
    return self;
}

- (id) initWithName: (NSString *) name AndValue: (int) val{
    if (self = [super init]) {
        // do our initialization...
        self.name = name;
        self.value = val;
    }
    return self;
}

@end
