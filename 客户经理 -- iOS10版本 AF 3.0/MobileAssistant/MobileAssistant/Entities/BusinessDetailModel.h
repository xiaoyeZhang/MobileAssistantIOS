//
//  BusinessDetailModel.h
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//  预约详情

#import <Foundation/Foundation.h>

@interface BusinessDetailModel : NSObject

@property(nonatomic, copy) NSString *company_name;
@property(nonatomic, copy) NSString *client_name;
@property(nonatomic, copy) NSString *leader_name;
@property(nonatomic, copy) NSString *job;
@property(nonatomic, copy) NSString *visit_info;
@property(nonatomic, copy) NSString *visit_time;
@property(nonatomic, copy) NSString *visit_remarks;
@property(nonatomic, copy) NSString *leader_tel;
@property(nonatomic, copy) NSString *msger_tel;
@property(nonatomic, copy) NSString *company_num;

@end
