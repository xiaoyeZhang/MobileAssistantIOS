//
//  Product_classificationEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/9.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Product_classificationEntity.h"

@implementation Product_classificationEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type_id = [attributes valueForKey:@"type_id"];
    self.name = [attributes valueForKey:@"name"];
    self.product_id = [attributes valueForKey:@"product_id"];
    self.icon = [attributes valueForKey:@"icon"];
    self.title = [attributes valueForKey:@"title"];
    self.video_url = [attributes valueForKey:@"video_url"];
    
    return self;
}

@end
