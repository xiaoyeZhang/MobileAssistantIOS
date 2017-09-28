//
//  Recommended_DetailEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/30.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Recommended_DetailEntity.h"

@implementation Recommended_DetailEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.icon = [attributes valueForKey:@"icon"];
    
    self.name = [attributes valueForKey:@"name"];
    
    self.count = [attributes valueForKey:@"count"];
    
    self.app_id = [attributes valueForKey:@"app_id"];
    
    self.level = [attributes valueForKey:@"level"];
    
    self.content = [attributes valueForKey:@"content"];
    
    
    return self;
    
}
@end
