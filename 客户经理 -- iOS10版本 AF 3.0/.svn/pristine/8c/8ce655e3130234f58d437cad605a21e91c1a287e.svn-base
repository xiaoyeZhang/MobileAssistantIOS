//
//  BusinessDetailEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-25.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessDetailEntity.h"

@implementation BusinessDetailEntity
@synthesize detail_id;
@synthesize business_id;
@synthesize title;
@synthesize type;
@synthesize content;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.detail_id= [attributes valueForKeyPath:@"detail_id"];
    self.business_id = [attributes valueForKeyPath:@"business_id"];
    self.title = [attributes valueForKeyPath:@"title"];
    self.type = [attributes valueForKeyPath:@"type"];
    self.content = [attributes valueForKeyPath:@"content"];
    
    return self;
}

@end
