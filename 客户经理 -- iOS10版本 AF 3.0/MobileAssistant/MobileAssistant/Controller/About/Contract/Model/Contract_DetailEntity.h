//
//  Contract_DetailEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contract_DetailEntity : NSObject

@property (nonatomic, copy) NSString *contract_id;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *company_num;
@property (nonatomic, copy) NSString *user_num;
@property (nonatomic, copy) NSString *contract_name;
@property (nonatomic, copy) NSString *contract_sn;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
