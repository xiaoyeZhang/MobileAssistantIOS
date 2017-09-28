//
//  M_Order_Demand_SumiltEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M_Order_Demand_SumiltEntity : NSObject


@property (copy, nonatomic) NSString *form_id;

@property (copy, nonatomic) NSString *data_info;

@property (copy, nonatomic) NSString *Init_type;  //1:默认不显示，0:默认显示

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *type_id;

@property (copy, nonatomic) NSString *show_list;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *Init_data;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
