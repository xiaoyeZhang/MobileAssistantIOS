//
//  BusinessOrderDetail.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-26.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessOrderDetail.h"

@implementation BusinessOrderDetail
@synthesize order_detail_id;
@synthesize order_id;
@synthesize detail_id;
@synthesize content;
@synthesize title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.order_detail_id= [attributes valueForKeyPath:@"order_detail_id"];
    self.order_id = [attributes valueForKeyPath:@"order_id"];
    self.detail_id = [attributes valueForKeyPath:@"detail_id"];
    self.content = [attributes valueForKeyPath:@"content"];
    self.title = [attributes valueForKeyPath:@"title"];
    
    return self;
}

@end
