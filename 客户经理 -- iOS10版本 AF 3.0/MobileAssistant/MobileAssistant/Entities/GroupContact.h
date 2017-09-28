//
//  GroupContact.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/15.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupContact : NSObject

@property (nonatomic, strong) NSString *GroupId;
@property (nonatomic, strong) NSString *ServiceNum;
@property (nonatomic, strong) NSString *CustName;
@property (nonatomic, strong) NSString *MemberKind;
@property (nonatomic, strong) NSString *MemberCustId;
@property (nonatomic, strong) NSString *VipFlag;
@property (nonatomic, strong) NSString *PartyRoleId;
@property (nonatomic, strong) NSString *Gender;
@property (nonatomic, strong) NSString *job;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
