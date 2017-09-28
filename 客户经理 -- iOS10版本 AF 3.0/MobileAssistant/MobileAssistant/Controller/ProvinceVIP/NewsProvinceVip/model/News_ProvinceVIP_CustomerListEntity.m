


//
//  News_ProvinceVIP_CustomerListEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/24.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_ProvinceVIP_CustomerListEntity.h"

@implementation News_ProvinceVIP_CustomerListEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    self.customer_id = [attributes valueForKey:@"id"];
    
    self.title = [attributes valueForKey:@"title"];
    
    self.content = [attributes valueForKey:@"content"];

    return self;
    
}
@end
