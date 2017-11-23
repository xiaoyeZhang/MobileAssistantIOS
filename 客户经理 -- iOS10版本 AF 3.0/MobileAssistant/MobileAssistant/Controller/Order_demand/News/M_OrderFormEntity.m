//
//  M_OrderFormEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/23.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_OrderFormEntity.h"

@implementation M_OrderFormEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.Id = [attributes valueForKey:@"id"];
    self.name = [attributes valueForKey:@"name"];
    self.type = [attributes valueForKey:@"type"];

    return self;
    
}


@end
