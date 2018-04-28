//
//  Arrears_taskEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Arrears_taskEntity : NSObject

@property (nonatomic, copy) NSString *time; // 数据日期
@property (nonatomic, copy) NSString *area_name; // 集团归属县市名称
@property (nonatomic, copy) NSString *company_name; // 集团名称
@property (nonatomic, copy) NSString *company_num; // 集团编号

@property (nonatomic, copy) NSString *type; // 行业类别
@property (nonatomic, copy) NSString *user_name; // 集团客户经理
@property (nonatomic, copy) NSString *user_num; // 集团客户经理编号
@property (nonatomic, copy) NSString *city_name; // 集团归属地市名称

@property (nonatomic, copy) NSString *cycle; // 账号付费周期
@property (nonatomic, copy) NSString *acc_num; // 账号编号
@property (nonatomic, copy) NSString *amount; // 当月欠费额
@property (nonatomic, copy) NSString *month; // 欠费月份

@property (nonatomic, copy) NSString *flag; // 欠费催缴标识
@property (nonatomic, copy) NSString *acc_name; // 账号名称
@property (nonatomic, copy) NSString *guest_num; // 账号编码
@property (nonatomic, copy) NSString *tel; // 电话号码

@property (nonatomic, copy) NSString *do_flag; //
@property (nonatomic, copy) NSString *state; //
@property (nonatomic, copy) NSString *arrearage_id; //

@property (nonatomic, copy) NSString *infos; //
@property (nonatomic, copy) NSString *suggestion; //
@property (nonatomic, copy) NSString *reason; //
@property (nonatomic, copy) NSString *next_processor; //

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
