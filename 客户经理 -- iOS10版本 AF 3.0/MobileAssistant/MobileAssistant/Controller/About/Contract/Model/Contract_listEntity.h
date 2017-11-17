//
//  Contract_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contract_listEntity : NSObject

@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *list_type;
@property (nonatomic, copy) NSString *contract_id;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *show_type;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
