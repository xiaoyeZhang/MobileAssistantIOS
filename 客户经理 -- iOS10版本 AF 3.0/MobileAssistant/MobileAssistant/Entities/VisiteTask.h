//
//  VisiteTask.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisiteTask : NSObject

/*
 visit_id;拜访任务id
 title;拜访标题
 time;拜访时间
 state;拜访状态
 reason;拜访原因
 lat;经度
 lont;纬度
 summary;拜访纪要
 baidu_addr;现场地址
 add1;任务编号
 add2;礼品编号
 maker_name;指定人
 actor_name;执行人
 job;客户职务
 tel;联系电话
 name;客户名称
 company_name;公司名
 address;客户地址
 is_chief:是否首席客户代表
 up_date:截止日期
 business_info:商机
 */
@property (nonatomic, strong) NSString *visit_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lont;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *baidu_addr;
@property (nonatomic, strong) NSString *add2;
@property (nonatomic, strong) NSString *maker_name;
@property (nonatomic, strong) NSString *actor_name;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *company_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *add1;
@property (nonatomic, strong) NSString *maker_id;
@property (nonatomic, strong) NSString *actor_id;
@property (nonatomic, strong) NSString *up_date;
@property (nonatomic, strong) NSString *is_chief;
@property(nonatomic, copy) NSString *cacsi;

@property (nonatomic, strong) NSString *assist_id;
@property(nonatomic, copy) NSString *assist_name;

@property(nonatomic, strong) NSArray *business_info;

@property(nonatomic, copy) NSString *color;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
