//
//  Vertical_ListEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Vertical_ListEntity.h"

@implementation Vertical_ListEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.teamwork_id = [attributes valueForKey:@"teamwork_id"];
    self.create_id = [attributes valueForKey:@"create_id"];
    self.create_time = [attributes valueForKey:@"create_time"];
    self.state = [attributes valueForKey:@"state"];
    self.state_name = [attributes valueForKey:@"state_name"];
    self.parent_id = [attributes valueForKey:@"parent_id"];
    self.target_num = [attributes valueForKey:@"target_num"];
    self.next_process_id = [attributes valueForKey:@"next_process_id"];
    self.next_process_name = [attributes valueForKey:@"next_process_name"];
    self.info_id = [attributes valueForKey:@"info_id"];
    self.title = [attributes valueForKey:@"title"];
    self.submit_name = [attributes valueForKey:@"submit_name"];
    
    self.tel = [attributes valueForKey:@"tel"];
    self.dep_name = [attributes valueForKey:@"dep_name"];
    self.to_day = [attributes valueForKey:@"to_day"];
    self.product = [attributes valueForKey:@"product"];
    self.level = [attributes valueForKey:@"level"];
    
    self.type = [attributes valueForKey:@"type"];
    self.content = [attributes valueForKey:@"content"];
    self.marks = [attributes valueForKey:@"marks"];
    self.op_time = [attributes valueForKey:@"op_time"];
    self.target_name = [attributes valueForKey:@"target_name"];
    
    self.is_new = [attributes valueForKey:@"is_new"];
    
    self.images = [attributes valueForKey:@"images"];
    
    self.reply = [attributes valueForKey:@"reply"];
    
    return self;
    
}

@end
