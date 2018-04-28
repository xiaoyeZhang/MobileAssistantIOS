//
//  strategy_listEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "strategy_listEntity.h"

@implementation strategy_listEntity


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }
}

@end
