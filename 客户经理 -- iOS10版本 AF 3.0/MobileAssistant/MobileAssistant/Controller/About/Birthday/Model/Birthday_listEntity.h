//
//  Birthday_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Birthday_listEntity : NSObject

@property (nonatomic, copy) NSString *birthday_id;
@property (nonatomic, copy) NSString *birthday_type;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *client_name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *state;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
