//
//  Group_V_NetModel.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Group_V_NetModel.h"

@implementation Group_V_NetModel

@synthesize MemberNum;
@synthesize VpmnId;
@synthesize VpmnName;
@synthesize TownMemNum;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (![[attributes valueForKeyPath:@"MemberNum"] isKindOfClass:[NSNull class]]){
        self.MemberNum = [attributes valueForKeyPath:@"MemberNum"];
    }else{
        self.MemberNum = @"";
    }
    
    if (![[attributes valueForKeyPath:@"VpmnId"] isKindOfClass:[NSNull class]]){
         self.VpmnId = [attributes valueForKeyPath:@"VpmnId"];
    }else{
        self.VpmnId = @"";
    }
    
    if (![[attributes valueForKeyPath:@"VpmnName"] isKindOfClass:[NSNull class]]){
        self.VpmnName = [attributes valueForKeyPath:@"VpmnName"];
    }else{
        self.VpmnName = @"";
    }
    
    if (![[attributes valueForKeyPath:@"TownMemNum"] isKindOfClass:[NSNull class]]){
        self.TownMemNum = [attributes valueForKeyPath:@"TownMemNum"];
    }else{
        self.TownMemNum = @"";
    }
    
    return self;
}

@end
