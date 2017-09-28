//
//  TerminalHistoryEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminalHistoryEntity : NSObject

@property (nonatomic, strong) NSString *process_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *state;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
