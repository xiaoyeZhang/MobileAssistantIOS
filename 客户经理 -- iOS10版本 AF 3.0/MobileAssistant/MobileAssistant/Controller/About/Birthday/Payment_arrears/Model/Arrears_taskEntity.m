
//
//  Arrears_taskEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Arrears_taskEntity.h"

@implementation Arrears_taskEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.time = [attributes valueForKey:@"time"];
    self.area_name = [attributes valueForKey:@"area_name"];
    self.company_name = [attributes valueForKey:@"company_name"];
    self.company_num = [attributes valueForKey:@"company_num"];

    self.type = [attributes valueForKey:@"type"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.user_num = [attributes valueForKey:@"user_num"];
    self.city_name = [attributes valueForKey:@"city_name"];

    self.cycle = [attributes valueForKey:@"cycle"];
    self.acc_num = [attributes valueForKey:@"acc_num"];
    self.amount = [attributes valueForKey:@"amount"];
    self.month = [attributes valueForKey:@"month"];
    
    self.flag = [attributes valueForKey:@"flag"];
    self.acc_name = [attributes valueForKey:@"acc_name"];
    self.guest_num = [attributes valueForKey:@"guest_num"];
    self.tel = [attributes valueForKey:@"tel"];
    
    self.do_flag = [attributes valueForKey:@"do_flag"];
    self.state = [attributes valueForKey:@"state"];
    self.arrearage_id = [attributes valueForKey:@"arrearage_id"];
    
    if ([[attributes allKeys] containsObject:@"infos"]){
        self.infos = [attributes valueForKey:@"infos"];
        self.suggestion = [attributes valueForKey:@"suggestion"];
        self.next_processor = [attributes valueForKey:@"next_processor"];
    }
    if ([[attributes allKeys] containsObject:@"reason"]){
        self.reason = [attributes valueForKey:@"reason"];
    }
    return self;
}

@end
