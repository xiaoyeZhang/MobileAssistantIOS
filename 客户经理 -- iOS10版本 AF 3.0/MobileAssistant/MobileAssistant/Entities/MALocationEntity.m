//
//  MALocationEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15/5/6.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "MALocationEntity.h"

@implementation MALocationEntity

@synthesize area_id;
@synthesize name;
@synthesize lont;
@synthesize lat;
@synthesize times;

static MALocationEntity * _sharedInstance = nil;

+ (MALocationEntity *)sharedInstance
{
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        _sharedInstance = [[MALocationEntity alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.area_id= [attributes valueForKeyPath:@"area_id"];
    self.name= [attributes valueForKeyPath:@"name"];
    self.lont= [attributes valueForKeyPath:@"lont"];
    self.lat= [attributes valueForKeyPath:@"lat"];
    
    return self;
}

- (void) deepCopy:(MALocationEntity *)sender
{
    _sharedInstance.area_id = [sender.area_id mutableCopy];
    _sharedInstance.name = [sender.name mutableCopy];
    _sharedInstance.name = [sender.name mutableCopy];
    _sharedInstance.lont = [sender.lont mutableCopy];
    _sharedInstance.lat = [sender.lat mutableCopy];
}

@end
