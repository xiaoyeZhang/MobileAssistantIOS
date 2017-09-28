//
//  Recommended_DetailEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/30.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recommended_DetailEntity : NSObject

@property (copy, nonatomic) NSString *icon;

@property (copy, nonatomic) NSString *app_id;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *level;

@property (copy, nonatomic) NSString *count;

@property (copy, nonatomic) NSString *content;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
