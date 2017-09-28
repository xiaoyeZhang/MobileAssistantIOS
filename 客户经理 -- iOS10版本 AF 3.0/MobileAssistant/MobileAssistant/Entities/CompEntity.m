//
//  CompEntity.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CompEntity.h"

@implementation CompEntity

@synthesize company_id;
@synthesize name;
@synthesize tel;
@synthesize num;
@synthesize type;
@synthesize scope;
@synthesize contact;
@synthesize key_name;
@synthesize key_tel;
@synthesize address;
@synthesize update_time;
@synthesize company_level;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.company_id= [attributes valueForKeyPath:@"company_id"];
    self.company_level= [attributes valueForKeyPath:@"company_level"];
    self.name= [attributes valueForKeyPath:@"name"];
    self.tel = [attributes valueForKeyPath:@"tel"];
    self.num = [attributes valueForKeyPath:@"num"];
    self.type = [attributes valueForKeyPath:@"type"];
    self.scope = [attributes valueForKeyPath:@"scope"];
    self.contact = [attributes valueForKeyPath:@"contact"];
    self.key_name = [attributes valueForKeyPath:@"key_name"];
    self.key_tel = [attributes valueForKeyPath:@"key_tel"];
    self.address = [attributes valueForKeyPath:@"address"];
    self.update_time = [attributes valueForKeyPath:@"update_time"];
    self.company_status = [attributes valueForKeyPath:@"company_status"];

    UserEntity *userEntity = [UserEntity sharedInstance];
    
    if ([userEntity.is_first isEqual:@"1"]) {
        
        self.is_fist_UserNum = [attributes valueForKeyPath:@"user_num"];
        self.user_id = [attributes valueForKeyPath:@"user_id"];
        self.user_name = [attributes valueForKeyPath:@"user_name"];
    }
    return self;
}

@end
