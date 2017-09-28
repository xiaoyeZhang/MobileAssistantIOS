//
//  Vertical_ListEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vertical_ListEntity : NSObject


@property (copy, nonatomic) NSString *teamwork_id;

@property (copy, nonatomic) NSString *create_id;

@property (copy, nonatomic) NSString *create_time;

@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *state_name;

@property (copy, nonatomic) NSString *parent_id;

@property (copy, nonatomic) NSString *target_num;

@property (copy, nonatomic) NSString *target_name;

@property (copy, nonatomic) NSString *next_process_id;

@property (copy, nonatomic) NSString *next_process_name;

@property (copy, nonatomic) NSString *info_id;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *submit_name;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *dep_name;

@property (copy, nonatomic) NSString *to_day;

@property (copy, nonatomic) NSString *product;

@property (copy, nonatomic) NSString *level;

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *marks;

@property (copy, nonatomic) NSString *op_time;

@property (copy, nonatomic) NSString *is_new;

@property (copy, nonatomic) NSString *images;

@property (copy, nonatomic) NSString *reply;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
