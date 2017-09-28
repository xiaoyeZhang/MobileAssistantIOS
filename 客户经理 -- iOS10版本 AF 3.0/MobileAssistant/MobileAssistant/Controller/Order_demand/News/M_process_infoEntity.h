//
//  M_process_infoEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M_process_infoEntity : NSObject

@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *remarks;

@property (copy, nonatomic) NSString *state_name;

@property (copy, nonatomic) NSString *user_name;

@property (copy, nonatomic) NSString *cur_state_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
