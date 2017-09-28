//
//  small_piece_paperEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/13.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "small_piece_paperEntity.h"

@implementation small_piece_paperEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.tape_id = [attributes valueForKey:@"tape_id"];
    self.isnew = [attributes valueForKey:@"isnew"];
    self.create_time = [attributes valueForKey:@"create_time"];
    self.title = [attributes valueForKey:@"title"];
    self.content = [attributes valueForKey:@"content"];
    self.img_name = [attributes valueForKey:@"img_name"];
    self.end_time = [attributes valueForKey:@"end_time"];
    self.create_name = [attributes valueForKey:@"create_name"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.reply_content = [attributes valueForKey:@"reply_content"];
    
    return self;
}

@end
