//
//  Handling_tasksEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/3.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Handling_tasksEntity.h"

@implementation Handling_tasksEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.company_level = [attributes valueForKey:@"company_level"];
    self.unvisit_id = [attributes valueForKey:@"unvisit_id"];
    self.create_id = [attributes valueForKey:@"create_id"];
    self.content = [attributes valueForKey:@"content"];
    self.create_time = [attributes valueForKey:@"create_time"];
    
    self.user_num = [attributes valueForKey:@"user_num"];
    self.company_num = [attributes valueForKey:@"company_num"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.to_day = [attributes valueForKey:@"to_day"];
    self.company_name = [attributes valueForKey:@"company_name"];
    self.address = [attributes valueForKey:@"address"];
    self.visit_id = [attributes valueForKey:@"visit_id"];

    
    return self;
}

@end
