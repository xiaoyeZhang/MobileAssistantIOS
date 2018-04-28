//
//  Postpaid_ListEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/25.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Postpaid_ListEntity : NSObject

@property (nonatomic, copy) NSString *postpaid_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *dep_name;

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *company_num;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *next_processor;
@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *cycle;
@property (nonatomic, copy) NSString *infos;
@property (nonatomic, copy) NSString *suggestion;

@end
