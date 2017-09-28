//
//  MatchingEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/17.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "MatchingEntity.h"

@implementation MatchingEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.company_name = [attributes valueForKey:@"company_name"];
    
    self.date_time = [attributes valueForKey:@"date_time"];
    
    self.receive_num = [attributes valueForKey:@"receive_num"];
    
    self.target_num = [attributes valueForKey:@"target_num"];
    
    self.matching_num = [attributes valueForKey:@"matching_num"];
        
    
    return self;
    
}

@end
