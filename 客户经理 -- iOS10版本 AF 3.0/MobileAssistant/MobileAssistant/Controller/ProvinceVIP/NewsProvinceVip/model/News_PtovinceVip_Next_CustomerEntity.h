//
//  News_PtovinceVip_Next_CustomerEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News_PtovinceVip_Next_CustomerEntity : NSObject


@property (copy, nonatomic) NSString *user_id;

@property (copy, nonatomic) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
