//
//  M_Order_Demand_DetailEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_Order_Demand_DetailEntity.h"

@implementation M_Order_Demand_DetailEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }

    self.form_id = [attributes valueForKey:@"form_id"];
    self.name = [attributes valueForKey:@"name"];
    self.data_info = [attributes valueForKey:@"data_info"];
    self.Init_type = [attributes valueForKey:@"init_type"];
    self.type_id = [attributes valueForKey:@"type_id"];
    self.show_list = [attributes valueForKey:@"show_list"];
    self.title = [attributes valueForKey:@"title"];
    self.cur_data_info = [attributes valueForKey:@"cur_data_info"];
    self.cur_data_state = [attributes valueForKey:@"cur_data_state"];
    
    return self;
    
}

@end
