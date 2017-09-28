//
//  Contract_listEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Contract_listEntity.h"

@implementation Contract_listEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.end_time = [attributes valueForKey:@"end_time"];
    self.title = [attributes valueForKey:@"title"];
    self.list_type = [attributes valueForKey:@"list_type"];
    self.contract_id = [attributes valueForKey:@"contract_id"];
    self.company_name = [attributes valueForKey:@"company_name"];
    
    return self;
}

@end
