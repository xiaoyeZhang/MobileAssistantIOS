//
//  TerminalEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "TerminalEntity.h"

@implementation TerminalEntity

@synthesize terminalId;
@synthesize name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.terminalId= [attributes valueForKeyPath:@"terminal_id"];
    self.name = [attributes valueForKeyPath:@"name"];
    
    return self;
}


@end
