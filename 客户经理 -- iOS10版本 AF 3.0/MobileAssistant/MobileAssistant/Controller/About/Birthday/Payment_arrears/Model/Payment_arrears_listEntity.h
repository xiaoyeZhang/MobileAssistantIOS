//
//  Payment_arrears_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment_arrears_listEntity : NSObject

@property (nonatomic, copy) NSString *company_num; //集团编号
@property (nonatomic, copy) NSString *company_name; //集团名称
@property (nonatomic, copy) NSString *all_amount; //总欠费数
@property (nonatomic, copy) NSString *time; //截止日期

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
