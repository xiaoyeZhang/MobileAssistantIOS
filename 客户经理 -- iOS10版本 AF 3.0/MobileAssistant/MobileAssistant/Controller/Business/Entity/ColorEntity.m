//
//  ColorEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "ColorEntity.h"

@implementation ColorEntity
@synthesize colorId;
@synthesize name;
@synthesize stock;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.colorId= [attributes valueForKeyPath:@"color_id"];
    self.name = [attributes valueForKeyPath:@"name"];
    self.stock = [attributes valueForKeyPath:@"stock"];
    
    return self;
}

@end
