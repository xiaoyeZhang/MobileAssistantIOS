//
//  CompEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 company_id:公司id
 name:公司名称
 num:公司编号
 type:公司类型
 scope:公司经营的范围
 contact:联系人
 tel:电话
 key_name:关键人
 key_tel:关键人电话
 address:地址
 update_time:更新时间
 company_level:
 company_status：集团状态
 is_fist_UserNum :
 */

@interface CompEntity : NSObject

@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *company_level;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *key_name;
@property (nonatomic, strong) NSString *key_tel;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *company_status;

@property (nonatomic, strong) NSString *is_fist_UserNum;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
