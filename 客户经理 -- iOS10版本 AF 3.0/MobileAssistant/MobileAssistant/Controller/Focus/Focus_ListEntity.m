//
//  Focus_ListEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Focus_ListEntity.h"

@implementation Focus_ListEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.focus_id = [attributes valueForKey:@"focus_id"];
    self.type_id = [attributes valueForKey:@"type_id"];
    self.user_num = [attributes valueForKey:@"user_num"];
    self.target_id = [attributes valueForKey:@"target_id"];
    self.create_time = [attributes valueForKey:@"create_time"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.company_num = [attributes valueForKey:@"company_num"];
    self.company_name = [attributes valueForKey:@"company_name"];
    return self;
}


@end
