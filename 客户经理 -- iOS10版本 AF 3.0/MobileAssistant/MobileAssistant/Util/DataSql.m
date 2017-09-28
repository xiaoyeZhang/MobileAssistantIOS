//
//  DataSql.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/19.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import "DataSql.h"

@implementation DataSql


- (NSString *)getDbpath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *dbpath = [path stringByAppendingPathComponent:@"MobileAssistant.db"];

//     NSString *path = @"/Users/zhangxiaoye/Desktop/";
//
//     NSString *dbpath = [path stringByAppendingString:@"MobileAssistant.db"];

    return dbpath;
    
}

#pragma mark 创建数据库
- (void)createMyDB{
    
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    
    // 动态配置表
    [self.db executeUpdate:@"CREATE TABLE t_configureBtn( tag text, Btn_name text, Btn_image text,is_show text)"];
    
    [self.db executeUpdate:@"CREATE TABLE t_focus( focus_id text, type_id text, target_id text,is_read text)"];
    
    [self.db close];
    
    
}


-(void)addConfigure:(NSMutableDictionary *)messageDic{
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];

    
    [self.db executeUpdate:@"INSERT INTO t_configureBtn(tag,Btn_name,Btn_image,is_show) VALUES (?,?,?,?)",[messageDic objectForKey:@"tag"],[messageDic objectForKey:@"Btn_name"],[messageDic objectForKey:@"Btn_image"],[messageDic objectForKey:@"is_show"]];
    
    [self.db close];
    
}

- (NSMutableArray *)selectConfigure{
    
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM t_configureBtn"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([rs next]){
        
        NSString *tag = [rs stringForColumn:@"tag"];
        NSString *Btn_name = [rs stringForColumn:@"Btn_name"];
        NSString *Btn_image = [rs stringForColumn:@"Btn_image"];
        NSString *is_show = [rs stringForColumn:@"is_show"];
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setValue:tag forKey:@"tag"];
        [dic setValue:Btn_name forKey:@"Btn_name"];
        [dic setValue:Btn_image forKey:@"Btn_image"];
        [dic setValue:is_show forKey:@"is_show"];
        
        [array addObject:dic];
    }
    [self.db close];
    
    return array;
    
}

- (BOOL)isConfigure:(NSString *)message inTable:(NSString *)table{
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    
    FMResultSet *rs = [self.db executeQuery:sqlstr];
    
    BOOL boo = false;
    
    while ([rs next]) {
        NSString *str1 = [rs stringForColumn:@"Btn_name"];
        
        if ([str1 isEqualToString:message]) {
            boo = YES;
            break;
        }else{
            
            boo = NO;
        }
    }
    return boo;
}

- (BOOL)removeConfigure:(NSString *)message{
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    [self.db executeUpdate:@"DELETE FROM t_configureBtn WHERE Btn_name = ?",message];
    
    [self.db close];
    
    return YES;
    
}

- (void)addFocus:(NSDictionary *)messageDic{
    

    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    
    NSString *is_read = @"0";
    
    if ([self isFocus:[messageDic objectForKey:@"focus_id"] inTable:@"t_focus"]) {
        
    }else{
    
        [self.db executeUpdate:@"INSERT INTO t_focus(focus_id,type_id,target_id,is_read) VALUES (?,?,?,?)",[messageDic objectForKey:@"focus_id"],[messageDic objectForKey:@"type_id"],[messageDic objectForKey:@"target_id"],is_read];
    }

    [self.db close];

}

- (NSString *)selectFocus:(NSString *)focus_id{
 
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM t_focus WHERE focus_id = ?",focus_id];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    while ([rs next]){
        
        NSString *focus_id = [rs stringForColumn:@"focus_id"];
        NSString *type_id = [rs stringForColumn:@"type_id"];
        NSString *target_id = [rs stringForColumn:@"target_id"];
        NSString *is_read = [rs stringForColumn:@"is_read"];
        
        [dic setValue:focus_id forKey:@"focus_id"];
        [dic setValue:type_id forKey:@"type_id"];
        [dic setValue:target_id forKey:@"target_id"];
        [dic setValue:is_read forKey:@"is_read"];
        
        [array addObject:dic];
    }
    
    [self.db close];
    
    return [dic objectForKey:@"is_read"];

}

- (BOOL)changeFocus:(NSString *)focus_id{
    
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];

    NSString *sqlStr = @"UPDATE t_focus SET is_read = ? WHERE focus_id = ?";
    
    if ([self.db open])
    {
        BOOL result = [self.db executeUpdate:sqlStr withArgumentsInArray:@[ @"1", focus_id ]];
        if (result)
        {
            NSLog(@"更新成功！");
        }
    }
    [self.db close];
    
    return YES;

}

- (BOOL)isFocus:(NSString *)focus_id inTable:(NSString *)table{
 
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    
    FMResultSet *rs = [self.db executeQuery:sqlstr];
    
    BOOL boo = false;
    
    while ([rs next]) {
        NSString *str1 = [rs stringForColumn:@"focus_id"];
        
        if ([str1 isEqualToString:focus_id]) {
            boo = YES;
            break;
        }else{
            
            boo = NO;
        }
    }
    return boo;
}

- (int)countFocus{
    self.db = [FMDatabase databaseWithPath:[self getDbpath]];
    [self.db open];
    
    if ([self.db open]) {
    
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT Count(*) FROM t_focus WHERE is_read='1'"];
        
//        [self.db close];
        
        return  [self.db intForQuery:selectSQL];
    }

    return 0;
}
@end
