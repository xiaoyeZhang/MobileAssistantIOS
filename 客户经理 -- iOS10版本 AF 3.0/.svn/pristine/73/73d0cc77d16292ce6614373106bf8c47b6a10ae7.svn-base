//
//  ConditionEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-7.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ConditionEntity.h"

@implementation ConditionEntity

@synthesize ID, name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.ID= [attributes valueForKeyPath:@"id"];
    self.name= [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
