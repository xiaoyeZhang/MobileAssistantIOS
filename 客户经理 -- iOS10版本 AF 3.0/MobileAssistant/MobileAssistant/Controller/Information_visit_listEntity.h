//
//  Information_visit_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/12.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information_visit_listEntity : NSObject

/*
"create_time": "2017-06-09 11:01:35",
"baidu_addr": "贵州省贵阳市云岩区北京路19号-1",
"lont": "106.719503",
"lat": "26.60175",
"user_name": "青斌",
"company_name": "贵州省国土资源厅"
*/

@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *baidu_addr;
@property (copy, nonatomic) NSString *lont;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *user_name;
@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
