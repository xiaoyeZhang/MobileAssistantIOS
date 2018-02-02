//
//  News_BusinessListModel.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/2.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
"business_id": "3030",
"num": "20180131133038",
"type_id": "17",
"create_id": "1208",
"create_time": "2018-01-31 13:30:38",
"update_time": "2018-01-31 13:33:58",
"state": "23",
"next_processor": "-1",
"title": "贵州省林业种苗站",   ---标题显示
"process_list": "",
"picname": "",
"query_str": "-1",
"user_name": "吴美林",
"dep_name": "客户服务一部",
"todo_flag": "0",   ---是否待办
"state_name": "已领货"   ---状态名称
*/

@interface News_BusinessListModel : NSObject

@property (strong, nonatomic) NSString *business_id;

@property (strong, nonatomic) NSString *num;

@property (strong, nonatomic) NSString *type_id;

@property (strong, nonatomic) NSString *create_id;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *update_time;

@property (strong, nonatomic) NSString *state;

@property (strong, nonatomic) NSString *next_processor;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *process_list;

@property (strong, nonatomic) NSString *picname;

@property (strong, nonatomic) NSString *query_str;

@property (strong, nonatomic) NSString *user_name;

@property (strong, nonatomic) NSString *dep_name;

@property (strong, nonatomic) NSString *todo_flag;

@property (strong, nonatomic) NSString *state_name;

//- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
