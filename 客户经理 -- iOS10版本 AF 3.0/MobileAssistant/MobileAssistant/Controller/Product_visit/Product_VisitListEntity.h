//
//  Product_VisitListEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product_VisitListEntity : NSObject

@property (copy, nonatomic) NSString *visit_id;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *assis_user_id;
@property (copy, nonatomic) NSString *job;
@property (copy, nonatomic) NSString *client_name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *expect;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *exec_time;
@property (copy, nonatomic) NSString *lont;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *user_name;
@property (copy, nonatomic) NSString *assis_user_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
