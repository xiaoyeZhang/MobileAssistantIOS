
//
//  Group_V_NetContactModel.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/24.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Group_V_NetContactModel.h"

@implementation Group_V_NetContactModel

@synthesize IsIn;
@synthesize ServiceNum;
@synthesize ShortNum;
@synthesize UserId;
@synthesize Department;
@synthesize GroupId;
@synthesize MemberName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (![[attributes valueForKeyPath:@"IsIn"] isKindOfClass:[NSNull class]]){
        self.IsIn = [attributes valueForKeyPath:@"IsIn"];
    }else{
        self.IsIn = @"";
    }
    
    if (![[attributes valueForKeyPath:@"ServiceNum"] isKindOfClass:[NSNull class]]){
        self.ServiceNum = [attributes valueForKeyPath:@"ServiceNum"];
    }else{
        self.ServiceNum = @"";
    }
    
    if (![[attributes valueForKeyPath:@"ShortNum"] isKindOfClass:[NSNull class]]){
        self.ShortNum = [attributes valueForKeyPath:@"ShortNum"];
    }else{
        self.ShortNum = @"";
    }
    
    if (![[attributes valueForKeyPath:@"UserId"] isKindOfClass:[NSNull class]]){
        self.UserId = [attributes valueForKeyPath:@"UserId"];
    }else{
        self.UserId = @"";
    }
    
    if (![[attributes valueForKeyPath:@"Department"] isKindOfClass:[NSNull class]]){
        self.Department = [attributes valueForKeyPath:@"Department"];
    }else{
        self.Department = @"";
    }
    
    if (![[attributes valueForKeyPath:@"GroupId"] isKindOfClass:[NSNull class]]){
        self.GroupId = [attributes valueForKeyPath:@"GroupId"];
    }else{
        self.GroupId = @"";
    }
    
    if (![[attributes valueForKeyPath:@"MemberName"] isKindOfClass:[NSNull class]]){
        self.MemberName = [attributes valueForKeyPath:@"MemberName"];
    }else{
        self.MemberName = @"";
    }
    return self;
}

@end
