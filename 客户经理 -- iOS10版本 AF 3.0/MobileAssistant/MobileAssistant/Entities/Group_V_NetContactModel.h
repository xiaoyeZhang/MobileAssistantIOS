//
//  Group_V_NetContactModel.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/24.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 IsIn - 是否网内成员 ：0:网内；1：网外,
 ServiceNum - 成员服务号码,
 ShortNum - 成员短号,
 UserId - 用户编号,
 Department - 部门,
 GroupId - 集团编号,
 MemberName - 成员名称,
 */

@interface Group_V_NetContactModel : NSObject

@property (strong, nonatomic) NSString *IsIn;
@property (strong, nonatomic) NSString *ServiceNum;
@property (strong, nonatomic) NSString *ShortNum;
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *Department;
@property (strong, nonatomic) NSString *GroupId;
@property (strong, nonatomic) NSString *MemberName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
