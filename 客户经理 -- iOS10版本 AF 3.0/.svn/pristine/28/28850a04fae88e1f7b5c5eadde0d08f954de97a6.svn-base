//
//  LevelEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-12-18.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "LevelEntity.h"

@implementation LevelEntity
@synthesize lid;
@synthesize name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.lid= [attributes valueForKeyPath:@"id"];
    self.name= [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
