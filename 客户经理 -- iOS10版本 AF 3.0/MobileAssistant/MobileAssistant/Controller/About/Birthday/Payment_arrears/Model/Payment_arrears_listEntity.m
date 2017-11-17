//
//  Payment_arrears_listEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Payment_arrears_listEntity.h"

@implementation Payment_arrears_listEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.company_num = [attributes valueForKey:@"company_num"];
    self.company_name = [attributes valueForKey:@"company_name"];
    self.all_amount = [attributes valueForKey:@"all_amount"];
    self.time = [attributes valueForKey:@"time"];
    
    return self;
}

@end
