//
//  M_OrderFormEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/23.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M_OrderFormEntity : NSObject

@property (copy, nonatomic) NSString *Id;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *type;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
