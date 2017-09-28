//
//  BusinessListModel.h
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//  预约拜访列表

#import <Foundation/Foundation.h>

@interface BusinessListModel : NSObject

@property(nonatomic, copy) NSString *business_id;
@property(nonatomic, copy) NSString *num;
@property(nonatomic, copy) NSString *type_id;
@property(nonatomic, copy) NSString *create_id;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *update_time;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *next_processor;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *process_list;
@property(nonatomic, copy) NSString *user_name;
@property(nonatomic, copy) NSString *dep_name;
@property(nonatomic, copy) NSString *picname;
//@property(nonatomic, copy) NSString *recorded_image;
//@property(nonatomic, copy) NSString *fault_description;
//@property(nonatomic, copy) NSString *company_name;
//@property(nonatomic, copy) NSString *company_num;
//@property(nonatomic, copy) NSString *company_address;
//@property(nonatomic, copy) NSString *client_name;
//@property(nonatomic, copy) NSString *client_tel;

@end
