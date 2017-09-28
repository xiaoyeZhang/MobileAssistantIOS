//
//  BusinessEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-25.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessEntity.h"

@implementation BusinessEntity

@synthesize order_id;
@synthesize tel;
@synthesize state;
@synthesize num;
@synthesize create_time;
@synthesize user_name;
@synthesize type_name;
@synthesize business_name;
@synthesize company_name;
@synthesize client_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.order_id= [attributes valueForKeyPath:@"order_id"];
    self.tel = [attributes valueForKeyPath:@"tel"];
    self.state = [attributes valueForKeyPath:@"state"];
    self.num = [attributes valueForKeyPath:@"num"];
    self.user_name = [attributes valueForKeyPath:@"user_name"];
    
    self.create_time= [attributes valueForKeyPath:@"create_time"];
    self.type_name = [attributes valueForKeyPath:@"type_name"];
    self.business_name = [attributes valueForKeyPath:@"business_name"];
    self.company_name = [attributes valueForKeyPath:@"company_name"];
    self.client_name = [attributes valueForKeyPath:@"client_name"];
    
    return self;
}

@end
