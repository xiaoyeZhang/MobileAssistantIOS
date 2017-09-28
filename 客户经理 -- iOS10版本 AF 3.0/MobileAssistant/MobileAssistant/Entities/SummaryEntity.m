//
//  SummaryEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-5.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "SummaryEntity.h"

@implementation SummaryEntity

@synthesize today;
@synthesize this_week;
@synthesize this_month;
@synthesize last_month;
@synthesize today_finish;
@synthesize this_week_finish;
@synthesize this_month_finish;
@synthesize last_month_finish;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.today= [attributes valueForKeyPath:@"today"];
    self.this_week= [attributes valueForKeyPath:@"this_week"];
    self.this_month = [attributes valueForKeyPath:@"this_month"];
    self.last_month = [attributes valueForKeyPath:@"last_month"];
    self.today_finish = [attributes valueForKeyPath:@"today_finish"];
    self.this_week_finish = [attributes valueForKeyPath:@"this_week_finish"];
    self.this_month_finish = [attributes valueForKeyPath:@"this_month_finish"];
    self.last_month_finish = [attributes valueForKeyPath:@"last_month_finish"];
    
    return self;
}

@end
