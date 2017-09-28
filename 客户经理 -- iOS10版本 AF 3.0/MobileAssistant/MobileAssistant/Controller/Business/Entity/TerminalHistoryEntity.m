//
//  TerminalHistoryEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "TerminalHistoryEntity.h"

@implementation TerminalHistoryEntity
@synthesize process_id;
@synthesize user_id;
@synthesize time;
@synthesize user_name;
@synthesize state;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.process_id= [attributes valueForKeyPath:@"process_id"];
    self.user_id = [attributes valueForKeyPath:@"user_id"];
    self.state = [attributes valueForKeyPath:@"state"];
    self.time = [attributes valueForKeyPath:@"time"];
    self.user_name = [attributes valueForKeyPath:@"user_name"];
    
    return self;
}

@end
