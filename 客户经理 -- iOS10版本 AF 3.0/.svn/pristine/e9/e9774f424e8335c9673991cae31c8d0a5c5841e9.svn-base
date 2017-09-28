//
//  ExecutorEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ExecutorEntity.h"

@implementation ExecutorEntity

@synthesize name, tel, user_id;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name= [attributes valueForKeyPath:@"name"];
    
    self.tel = [attributes valueForKeyPath:@"tel"];
    self.user_id = [attributes valueForKeyPath:@"user_id"];
//    self.user_id = [attributes valueForKeyPath:@"num"];
    return self;
}

@end
