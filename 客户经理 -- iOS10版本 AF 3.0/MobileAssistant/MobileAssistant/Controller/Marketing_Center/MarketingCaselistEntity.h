//
//  MarketingCaselistEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/13.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketingCaselistEntity : NSObject


@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *case_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *is_support;
@property (copy, nonatomic) NSString *is_read;
@property (strong, nonatomic) NSArray *re;

@property (strong, nonatomic) NSString *share_num;
@property (strong, nonatomic) NSString *url;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
 
@end
