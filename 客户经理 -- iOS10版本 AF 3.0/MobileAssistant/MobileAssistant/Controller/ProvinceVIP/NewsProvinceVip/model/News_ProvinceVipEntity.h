//
//  News_ProvinceVipEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/22.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News_ProvinceVipEntity : NSObject

@property (strong, nonatomic) NSString *icon;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *module_id;

@property (strong, nonatomic) NSString *count;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
