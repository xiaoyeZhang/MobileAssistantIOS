//
//  News_ProvinceVIP_DetailEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News_ProvinceVIP_DetailEntity : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *state_name;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *todo_flag;
@property (copy, nonatomic) NSString *business_id;
@property (copy, nonatomic) NSString *create_time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
