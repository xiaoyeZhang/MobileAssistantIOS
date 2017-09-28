//
//  No_visit_baselistEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/3.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "No_visit_baselistEntity.h"

@implementation No_visit_baselistEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.num = [attributes valueForKey:@"num"];
    self.name = [attributes valueForKey:@"name"];
    self.company_level = [attributes valueForKey:@"level"];
    self.address = [attributes valueForKey:@"address"];
    self.visit_state = [[attributes valueForKey:@"visit_state"] intValue];
    
    self.visit_time = [[attributes valueForKey:@"visit_time"] intValue];
    
    self.user_name = [attributes valueForKey:@"user_name"];
    self.user_num = [attributes valueForKey:@"user_num"];
    self.dep_name = [attributes valueForKey:@"dep_name"];
    
    return self;
}

@end
