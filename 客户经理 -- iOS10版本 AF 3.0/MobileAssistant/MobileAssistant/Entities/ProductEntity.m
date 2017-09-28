//
//  ProductEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-12-17.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity
@synthesize product_id;
@synthesize user_id;
@synthesize area_id;
@synthesize title;
@synthesize disable;
@synthesize time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.product_id= [attributes valueForKeyPath:@"product_id"];
    self.user_id= [attributes valueForKeyPath:@"user_id"];
    self.area_id= [attributes valueForKeyPath:@"area_id"];
    self.title= [attributes valueForKeyPath:@"title"];
    self.disable= [attributes valueForKeyPath:@"disable"];
    self.time= [attributes valueForKeyPath:@"time"];
    
    return self;
}

@end
