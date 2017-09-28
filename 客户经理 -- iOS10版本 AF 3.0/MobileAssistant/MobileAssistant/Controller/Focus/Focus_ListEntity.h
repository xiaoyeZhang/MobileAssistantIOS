//
//  Focus_ListEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Focus_ListEntity : NSObject

@property (copy, nonatomic) NSString *focus_id;
@property (copy, nonatomic) NSString *type_id;
@property (copy, nonatomic) NSString *user_num;
@property (copy, nonatomic) NSString *target_id;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *user_name;

@property (copy, nonatomic) NSString *company_num;
@property (copy, nonatomic) NSString *company_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
