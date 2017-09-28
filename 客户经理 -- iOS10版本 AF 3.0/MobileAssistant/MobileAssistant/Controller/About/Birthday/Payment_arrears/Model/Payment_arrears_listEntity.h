//
//  Payment_arrears_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment_arrears_listEntity : NSObject

@property (nonatomic, copy) NSString *company_num;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *sum;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
