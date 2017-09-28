//
//  PhoneNumberEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "PhoneNumberEntity.h"

@implementation PhoneNumberEntity
@synthesize pId;
@synthesize name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.pId= [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"name"];
    
    return self;
}

@end
