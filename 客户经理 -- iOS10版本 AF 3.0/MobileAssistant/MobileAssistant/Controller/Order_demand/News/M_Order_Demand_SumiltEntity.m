//
//  M_Order_Demand_SumiltEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_Order_Demand_SumiltEntity.h"

@implementation M_Order_Demand_SumiltEntity

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
    self.Init_data = [attributes valueForKey:@"init_data"];
    
    return self;
    
}
@end
