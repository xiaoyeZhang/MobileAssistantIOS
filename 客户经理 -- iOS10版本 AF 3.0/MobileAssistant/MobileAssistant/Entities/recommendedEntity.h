//
//  recommendedEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recommendedEntity : NSObject

@property (copy, nonatomic) NSString *icon;

@property (copy, nonatomic) NSString *app_id;

@property (copy, nonatomic) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
