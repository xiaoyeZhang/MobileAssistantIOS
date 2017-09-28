

//
//  News_PtovinceVip_Next_CustomerEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_PtovinceVip_Next_CustomerEntity.h"

@implementation News_PtovinceVip_Next_CustomerEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.user_id = [attributes valueForKey:@"user_id"];
    
    self.name = [attributes valueForKey:@"name"];
    
    return self;
}

@end
