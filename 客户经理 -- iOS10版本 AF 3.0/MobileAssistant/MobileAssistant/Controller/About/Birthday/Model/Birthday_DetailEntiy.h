//
//  Birthday_DetailEntiy.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Birthday_DetailEntiy : NSObject


@property (nonatomic, copy) NSString *birthday_id;
@property (nonatomic, copy) NSString *company_num;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *client_name;
@property (nonatomic, copy) NSString *client_job;
@property (nonatomic, copy) NSString *client_tel;

@property (nonatomic, copy) NSString *user_num;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *ch_zodiac;
@property (nonatomic, copy) NSString *zodiac;
@property (nonatomic, copy) NSString *lunar;
@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *sms_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *birthday_date;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *birthday_date_all;
@property (nonatomic, copy) NSString *send_time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;



@end
