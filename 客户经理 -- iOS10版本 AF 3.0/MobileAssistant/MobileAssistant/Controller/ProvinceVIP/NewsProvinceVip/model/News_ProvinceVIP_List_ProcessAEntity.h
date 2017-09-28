//
//  News_ProvinceVIP_List_ProcessAEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News_ProvinceVIP_List_ProcessAEntity : NSObject

@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *marks;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
