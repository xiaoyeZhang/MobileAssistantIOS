//
//  BusinessEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-25.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "order_id":"22",
 "tel":"13895687854",
 "state":"0",
 "num":"201501241009042492",
 "create_time":"2015-01-24 10:09:04",
 "user_name":"\u5ba2\u6237\u7ecf\u7406A",
 "type_name":"\u5e74\u5ea6\u91cd\u70b9",
 "business_name":"\u96c6\u56e2V\u7f51",
 "company_name":"\u56fd\u9645\u79d1\u6280\u56ed\u4e1c",
 "client_name":"\u674e\u7ecf\u7406"
 */
@interface BusinessEntity : NSObject

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *type_name;
@property (nonatomic, strong) NSString *business_name;
@property (nonatomic, strong) NSString *company_name;
@property (nonatomic, strong) NSString *client_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
