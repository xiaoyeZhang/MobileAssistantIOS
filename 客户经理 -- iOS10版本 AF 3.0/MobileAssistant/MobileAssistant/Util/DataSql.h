//
//  DataSql.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/19.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataSql : NSObject

@property (strong, nonatomic) FMDatabase *db;

//创建数据库
- (void)createMyDB;
- (NSString *)getDbpath;

//添加动态配置信息
-(void) addConfigure:(NSMutableDictionary *)messageDic;

//获取动态配置信息
-(NSMutableArray *) selectConfigure;

//判断是否存在
- (BOOL)isConfigure:(NSString *)tag inTable:(NSString *)table;

//删除配置信息
- (BOOL) removeConfigure:(NSString *)message;

//添加集中化管理信息
-(void) addFocus:(NSDictionary *)messageDic;

//获取集中化管理信息
-(NSString *) selectFocus:(NSString *)focus_id;

//修改集中化管理信息
-(BOOL) changeFocus:(NSString *)focus_id;

//判断集中化管理信息是否存在
- (BOOL)isFocus:(NSString *)focus_id inTable:(NSString *)table;

//统计集中化管理的已读个数
- (int)countFocus;


@end
