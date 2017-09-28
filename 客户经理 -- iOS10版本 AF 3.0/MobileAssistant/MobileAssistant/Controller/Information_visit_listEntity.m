//
//  Information_visit_listEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/12.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Information_visit_listEntity.h"

@implementation Information_visit_listEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    /*
     "create_time": "2017-06-09 11:01:35",
     "baidu_addr": "贵州省贵阳市云岩区北京路19号-1",
     "lont": "106.719503",
     "lat": "26.60175",
     "user_name": "青斌",
     "company_name": "贵州省国土资源厅"
     */

    self.create_time = [attributes valueForKey:@"create_time"];
    self.baidu_addr = [attributes valueForKey:@"baidu_addr"];
    self.lont = [attributes valueForKey:@"lont"];
    self.lat = [attributes valueForKey:@"lat"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.company_name = [attributes valueForKey:@"company_name"];
    self.title = [attributes valueForKey:@"title"];
    
    return self;
}

@end
