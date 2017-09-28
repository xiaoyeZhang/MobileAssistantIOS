//
//  News_ProvinceVIP_List_OperEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News_ProvinceVIP_List_OperEntity : NSObject

@property (copy, nonatomic) NSString *select_next_method;

@property (copy, nonatomic) NSString *select_next_point_id;

@property (copy, nonatomic) NSString *button_infos;

@property (copy, nonatomic) NSString *marks_flag;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
