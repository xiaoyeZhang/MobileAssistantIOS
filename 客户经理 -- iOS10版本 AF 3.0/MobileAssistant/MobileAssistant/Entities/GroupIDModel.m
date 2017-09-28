//
//  GroupIDModel.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "GroupIDModel.h"

@implementation GroupIDModel

@synthesize AcctAlias;
@synthesize EffectDate;
@synthesize AccountId;
@synthesize AccountName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.AcctAlias = [attributes valueForKeyPath:@"AcctAlias"];
    self.AccountName = [attributes valueForKeyPath:@"AccountName"];
    self.EffectDate= [attributes valueForKeyPath:@"EffectDate"];
    self.AccountId= [attributes valueForKeyPath:@"AccountId"];
      
    return self;
}

@end
