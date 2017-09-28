//
//  M_process_infoEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_process_infoEntity.h"

@implementation M_process_infoEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.time = [attributes valueForKey:@"time"];
    self.remarks = [attributes valueForKey:@"remarks"];
    self.state_name = [attributes valueForKey:@"state_name"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.cur_state_name = [attributes valueForKey:@"cur_state_name"];
    return self;
    
}

@end
