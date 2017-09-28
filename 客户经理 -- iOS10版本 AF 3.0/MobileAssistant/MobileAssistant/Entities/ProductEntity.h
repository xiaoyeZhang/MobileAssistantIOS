//
//  ProductEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-12-17.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "product_id":"10",
 "user_id":"1",
 "area_id":"10",
 "title":"\u6d4b\u8bd51",
 "disable":"0",
 "time":null
 */
@interface ProductEntity : NSObject

@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *disable;
@property (nonatomic, strong) NSString *time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
