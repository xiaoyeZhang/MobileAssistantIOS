//
//  GroupContact.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/15.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "GroupContact.h"


@implementation GroupContact

@synthesize GroupId;
@synthesize ServiceNum;
@synthesize CustName;
@synthesize MemberKind;
@synthesize MemberCustId;
@synthesize VipFlag;
@synthesize PartyRoleId;
@synthesize Gender;
@synthesize job;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.GroupId = [attributes valueForKeyPath:@"GroupId"];
    self.ServiceNum= [attributes valueForKeyPath:@"ServiceNum"];
    self.CustName= [attributes valueForKeyPath:@"CustName"];
    self.MemberKind= [attributes valueForKeyPath:@"MemberKind"];
    self.MemberCustId = [attributes valueForKeyPath:@"MemberCustId"];
    self.VipFlag= [attributes valueForKeyPath:@"VipFlag"];
    self.PartyRoleId= [attributes valueForKeyPath:@"PartyRoleId"];
    self.Gender = [attributes valueForKeyPath:@"Gender"];
    
    if (![[attributes valueForKeyPath:@"Job"] isKindOfClass:[NSNull class]]){
        self.job = [attributes valueForKeyPath:@"Job"];
    }else{
        self.job = @"";
    }
    return self;
}


@end
