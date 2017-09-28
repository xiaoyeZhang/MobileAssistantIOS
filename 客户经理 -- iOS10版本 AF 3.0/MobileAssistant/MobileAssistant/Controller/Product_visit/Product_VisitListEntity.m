//
//  Product_VisitListEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_VisitListEntity.h"

@implementation Product_VisitListEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }

    
    
    self.visit_id = [attributes valueForKey:@"visit_id"];
    self.user_id = [attributes valueForKey:@"user_id"];
    self.company_name = [attributes valueForKey:@"company_name"];
    self.assis_user_id = [attributes valueForKey:@"assis_user_id"];
    self.job = [attributes valueForKey:@"job"];
    self.client_name = [attributes valueForKey:@"client_name"];
    self.time = [attributes valueForKey:@"time"];
    self.content = [attributes valueForKey:@"content"];
    self.expect = [attributes valueForKey:@"expect"];
    self.state = [attributes valueForKey:@"state"];
    self.summary = [attributes valueForKey:@"summary"];
    self.create_time = [attributes valueForKey:@"create_time"];
    self.exec_time = [attributes valueForKey:@"exec_time"];
    self.lont = [attributes valueForKey:@"lont"];
    self.lat = [attributes valueForKey:@"lat"];
    self.address = [attributes valueForKey:@"address"];
    self.image = [attributes valueForKey:@"image"];
    self.user_name = [attributes valueForKey:@"user_name"];
    self.assis_user_name = [attributes valueForKey:@"assis_user_name"];

    
    return self;
}


@end
