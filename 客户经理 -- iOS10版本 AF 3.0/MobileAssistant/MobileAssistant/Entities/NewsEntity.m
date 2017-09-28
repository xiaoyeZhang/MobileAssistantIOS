//
//  NewsEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-22.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "NewsEntity.h"

@implementation NewsEntity
@synthesize state, time, title, content;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.time = [attributes valueForKeyPath:@"time"];
    self.title = [attributes valueForKeyPath:@"title"];
    self.content = [attributes valueForKeyPath:@"content"];
    
    self.notice_id = [attributes valueForKey:@"notice_id"];
    
    self.state = [attributes valueForKeyPath:@"state"];
    self.create_id = [attributes valueForKeyPath:@"create_id"];
    self.type = [attributes valueForKeyPath:@"type"];
    
    self.start_time = [attributes valueForKey:@"start_time"];
    self.count = [attributes valueForKey:@"count"];
    return self;
}

@end
