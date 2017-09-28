//
//  BrandPhoneEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BrandPhoneEntity.h"

@implementation BrandPhoneEntity

@synthesize brandId;
@synthesize name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.brandId= [attributes valueForKeyPath:@"brand_id"];
    self.name = [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
