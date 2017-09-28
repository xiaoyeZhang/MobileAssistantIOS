//
//  PaymentEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/17.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentEntity : NSObject

@property (copy, nonatomic) NSString *receive_id;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *create_time;

@property (copy, nonatomic) NSString *user_id;

@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *num;
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *user_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
