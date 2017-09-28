//
//  sms_ListEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "sms_ListEntity.h"

@implementation sms_ListEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sms_id = [attributes valueForKey:@"sms_id"];
    self.type_id = [attributes valueForKey:@"type_id"];
    self.content = [attributes valueForKey:@"content"];
    self.create_time = [attributes valueForKey:@"create_time"];
    self.count = [attributes valueForKey:@"count"];

    
    return self;
}

@end
