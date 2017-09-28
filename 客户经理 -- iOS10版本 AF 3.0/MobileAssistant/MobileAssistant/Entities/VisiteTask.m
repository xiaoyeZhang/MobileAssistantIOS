//
//  VisiteTask.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "VisiteTask.h"

@implementation VisiteTask

@synthesize visit_id;
@synthesize title;
@synthesize time;
@synthesize state;
@synthesize reason;
@synthesize lat;
@synthesize lont;
@synthesize summary;
@synthesize baidu_addr;
@synthesize add2;
@synthesize add1;
@synthesize maker_name;
@synthesize actor_name;
@synthesize job;
@synthesize tel;
@synthesize name;
@synthesize company_name;
@synthesize address;
@synthesize maker_id;
@synthesize actor_id;
@synthesize is_chief;
@synthesize assist_id;
@synthesize assist_name;
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.visit_id= [attributes valueForKeyPath:@"visit_id"];
    self.title= [attributes valueForKeyPath:@"title"];
    self.time = [attributes valueForKeyPath:@"time"];
    self.state = [attributes valueForKeyPath:@"state"];
    self.reason = [attributes valueForKeyPath:@"reason"];
    self.lat = [attributes valueForKeyPath:@"lat"];
    self.lont = [attributes valueForKeyPath:@"lont"];
    self.summary = [attributes valueForKeyPath:@"summary"];
    self.baidu_addr = [attributes valueForKeyPath:@"baidu_addr"];
    self.add2 = [attributes valueForKeyPath:@"add2"];
    self.add1 = [attributes valueForKeyPath:@"add1"];
    self.maker_name = [attributes valueForKeyPath:@"maker_name"];
    self.actor_name = [attributes valueForKeyPath:@"actor_name"];
    self.job = [attributes valueForKeyPath:@"job"];
    self.tel = [attributes valueForKeyPath:@"tel"];
    self.name = [attributes valueForKeyPath:@"name"];
    self.company_name = [attributes valueForKeyPath:@"company_name"];
    self.address = [attributes valueForKeyPath:@"address"];
    self.maker_id = [attributes valueForKeyPath:@"maker_id"];
    self.actor_id = [attributes valueForKeyPath:@"actor_id"];
    self.cacsi = [attributes valueForKeyPath:@"cacsi"];
    self.is_chief = [attributes valueForKeyPath:@"is_chief"];
    
    self.up_date = [attributes valueForKeyPath:@"up_date"];
    
    if([[attributes allKeys] containsObject:@"assist_name"])
    {
        self.assist_name = [attributes valueForKeyPath:@"assist_name"];
    }else
    {

    }
    
    if([[attributes allKeys] containsObject:@"assist_id"])
    {
        self.assist_id = [attributes valueForKeyPath:@"assist_id"];
    }else
    {
        
    }
    
    if([[attributes allKeys] containsObject:@"color"])
    {
        self.color = [attributes valueForKeyPath:@"color"];
    }else
    {
        
    }
    
    return self;
}


@end
