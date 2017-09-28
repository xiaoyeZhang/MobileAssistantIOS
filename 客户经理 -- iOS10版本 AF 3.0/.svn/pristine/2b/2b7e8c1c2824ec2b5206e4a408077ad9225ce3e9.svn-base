//
//  BusinessTypeEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-25.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessTypeEntity.h"

@implementation BusinessTypeEntity
@synthesize tid, name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.tid= [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
