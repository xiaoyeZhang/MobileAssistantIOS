//
//  Ad.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "AdEntity.h"

@implementation AdEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.state= [attributes valueForKeyPath:@"state"];
    self.ad_id = [attributes valueForKeyPath:@"ad_id"];
    self.filename = [NSString stringWithFormat:@"%@%@", IMAGE_URL, [attributes valueForKeyPath:@"filename"]];
    
    return self;
}

@end
