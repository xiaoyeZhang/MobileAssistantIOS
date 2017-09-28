//
//  Product_informationEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/4.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product_informationEntity : NSObject

@property (copy, nonatomic) NSString *type_id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *scope_id;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *color;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
