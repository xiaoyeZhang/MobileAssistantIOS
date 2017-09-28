//
//  TerminalSalesEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "TerminalSalesEntity.h"

@implementation TerminalSalesEntity
@synthesize sale_id;
@synthesize tel;
@synthesize state;
@synthesize time;
@synthesize num;
@synthesize terminal_name;
@synthesize capacity_name;
@synthesize color_name;
@synthesize package_name;
@synthesize number;
@synthesize company_name;
@synthesize client_name;


- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sale_id= [attributes valueForKeyPath:@"sales_id"];
    self.tel = [attributes valueForKeyPath:@"tel"];
    self.state = [attributes valueForKeyPath:@"state"];
    self.time = [attributes valueForKeyPath:@"time"];
    self.num = [attributes valueForKeyPath:@"num"];
    self.terminal_name = [attributes valueForKeyPath:@"terminal_name"];
    self.capacity_name = [attributes valueForKeyPath:@"capacity_num"];
    self.package_name = [attributes valueForKeyPath:@"package_name"];
    self.color_name = [attributes valueForKeyPath:@"color_name"];
    self.number = [attributes valueForKeyPath:@"number"];
    self.company_name = [attributes valueForKeyPath:@"company_name"];
    self.client_name = [attributes valueForKeyPath:@"client_name"];
    
    return self;
}

- (instancetype)initWithAttributesStates:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sale_id= [attributes valueForKeyPath:@"state"];
    self.num = [attributes valueForKeyPath:@"content"];
    
    return self;
}

@end
