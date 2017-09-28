//
//  ContactEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ContactEntity.h"

@implementation ContactEntity

@synthesize GroupId;
@synthesize name;
@synthesize tel;
@synthesize job;
@synthesize MemberKind;
@synthesize level;
@synthesize MemberCustId;
@synthesize MemberClass;
@synthesize MemberType;
@synthesize Gender;
@synthesize MemUserId;
@synthesize MemberLevel;
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.GroupId= [attributes valueForKeyPath:@"GroupId"];
    self.MemberKind = [attributes valueForKeyPath:@"MemberKind"];
    self.name= [attributes valueForKeyPath:@"CustName"];
    self.tel = [attributes valueForKeyPath:@"ServiceNum"];
    
    if (![[attributes valueForKeyPath:@"Job"] isKindOfClass:[NSNull class]]){
        self.job = [attributes valueForKeyPath:@"Job"];
    }else{
        self.job = @"";
    }
    
    if (![[attributes valueForKeyPath:@"MemberType"] isKindOfClass:[NSNull class]]){
        self.MemberType = [attributes valueForKeyPath:@"MemberType"];
    }else{
        self.MemberType = @"0";
    }
    self.MemberCustId = [attributes valueForKeyPath:@"MemberCustId"];
    
    
    if ([[attributes valueForKeyPath:@"Gender"] isEqual:@"1"]) {
        self.Gender = @"男";
    }else if ([[attributes valueForKeyPath:@"Gender"] isEqual:@"2"]) {
        self.Gender = @"女";
    }else{
        self.Gender = @"未知";
    }
    self.MemberClass = [attributes valueForKeyPath:@"MemberClass"];
    self.level = [attributes valueForKeyPath:@"level"];
    self.MemUserId = [attributes valueForKeyPath:@"MemUserId"];
    
    if (![[attributes valueForKeyPath:@"MemberLevel"] isKindOfClass:[NSNull class]]){
        self.MemberLevel = [attributes valueForKeyPath:@"MemberLevel"];
    }else{
        self.MemberLevel = @"";
    }
    
//    if (![[attributes valueForKeyPath:@"KernelLevel"] isKindOfClass:[NSNull class]]){
//        self.KernelLevel = [attributes valueForKeyPath:@"KernelLevel"];
//    }else{
//        self.KernelLevel = @"";
//    }
    
    return self;
}


@end
