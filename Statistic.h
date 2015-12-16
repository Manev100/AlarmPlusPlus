//
//  Statistic.h
//  AlarmPlusPlus
//
//  Created by Justin Sane on 16/12/15.
//  Copyright © 2015 Marc Neveling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistic : NSObject
- (id)init;
- (id) initWithName: (NSString *) name AndValue: (int) val;

@property (strong, nonatomic) NSString *name;
@property int value;
@end
