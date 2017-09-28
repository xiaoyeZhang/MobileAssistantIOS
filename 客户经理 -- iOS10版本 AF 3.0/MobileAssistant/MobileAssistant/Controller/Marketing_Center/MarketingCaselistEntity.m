//
//  MarketingCaselistEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/13.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "MarketingCaselistEntity.h"

@implementation MarketingCaselistEntity
- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.time = [attributes valueForKey:@"time"];
    self.case_id = [attributes valueForKey:@"case_id"];
    self.title = [attributes valueForKey:@"title"];
    self.icon = [attributes valueForKey:@"icon"];
    self.summary = [attributes valueForKey:@"summary"];
    self.content = [attributes valueForKey:@"content"];
    self.is_support = [attributes valueForKey:@"is_support"];
    self.is_read = [attributes valueForKey:@"is_read"];
    self.re = [attributes valueForKey:@"re"];
    self.share_num = [attributes valueForKey:@"share_num"];
    self.url = [attributes valueForKey:@"url"];
    return self;
}

@end
