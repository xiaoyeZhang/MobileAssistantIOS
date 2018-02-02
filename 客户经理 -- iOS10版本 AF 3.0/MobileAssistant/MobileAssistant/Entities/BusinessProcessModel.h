//
//  BusinessProcessModel.h
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessProcessModel : NSObject

@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *user_name;
@property(nonatomic, copy) NSString *remark;

@property(nonatomic, copy) NSString *state_name;

@end
