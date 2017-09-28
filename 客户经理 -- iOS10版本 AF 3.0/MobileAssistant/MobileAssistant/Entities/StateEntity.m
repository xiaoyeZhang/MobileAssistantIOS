//
//  StateEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-16.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "StateEntity.h"

@implementation StateEntity

@synthesize tid, name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSNumber *numberId = [attributes valueForKeyPath:@"id"];
    self.tid= [NSString stringWithFormat:@"%d", numberId.intValue];
    self.name= [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
