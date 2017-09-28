//
//  BusinessUtils.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-15.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessUtils.h"

@implementation BusinessUtils

static BusinessUtils * _sharedInstance = nil;

+ (id)sharedInstance
{
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        _sharedInstance = [[BusinessUtils alloc] init];
    });
    return _sharedInstance;
}

- (BOOL) openDb
{
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"business.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        self.db=db;
        BOOL res = [db executeUpdate:@"create table if not exists business  (bNo text, type text, name text, department text,state text, time text,contact_name text, job text,phone text)"];
        if (res == NO) {
            ALERT_ERR_MSG(@"数据保存失败");
        }
//        CREATE TABLE "phone_order" ("packageSell" VARCHAR, "phoneNumber" VARCHAR, "customer" VARCHAR, "contact" VARCHAR, "contactPhone" VARCHAR, "doPerson" VARCHAR, "brand" VARCHAR, "name" VARCHAR, "color" VARCHAR, "type" VARCHAR, "rom" VARCHAR,   "stock" VARCHAR, "number_sell" VARCHAR, "pno" VARCHAR PRIMARY KEY  NOT NULL , "time" VARCHAR)

        res = [db executeUpdate:@"create table if not exists phone_order (packageSell text, phoneNumber text,customer text, contact text,contactPhone text, doPerson text,brand text, name text,color text,type text,rom text, stock text,number_sell text, pno text, time text)"];
        if (res == NO) {
            ALERT_ERR_MSG(@"数据保存失败");
        }
        
        return YES;
    } else {
        return NO;
        NSLog(@"open sqlite error");
    }
    
}

- (void) saveBusinessOrder:(BuinessEntity *)entity
{
    /*
      ("bNo" VARCHAR PRIMARY KEY  NOT NULL , "type" VARCHAR, "name" VARCHAR, "department" VARCHAR, "state" VARCHAR, "time" VARCHAR, "contact_name" VARCHAR, "job" VARCHAR, "phone" VARCHAR)
     */
    NSString *strSQL = @"INSERT INTO business (bNo, type, name, department, state, time, contact_name, job, phone) VALUES (?, ?,?, ?,?, ?,?,?, ?);";
    BOOL res = [self.db executeUpdate:strSQL, entity.bNO, entity.type, entity.name, entity.department, entity.state, entity.time,
                                    entity.contact.name, entity.contact.job, entity.contact.phone];
    NSLog(@"%@", entity.contact.name);
    if (res == NO) {
        ALERT_ERR_MSG(@"数据保存失败");
    }
    //[self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
}

- (NSMutableArray *) queryBusinessOrder
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM business"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        BuinessEntity *entity = [[BuinessEntity alloc] init];
        entity.contact = [[BContactEntity alloc] init];
        entity.bNO = [resultSet stringForColumn:@"bNo"];
        entity.type = [resultSet stringForColumn:@"type"];
        entity.name = [resultSet stringForColumn:@"name"];
        entity.department = [resultSet stringForColumn:@"department"];
        entity.state = [resultSet stringForColumn:@"state"];
        entity.time = [resultSet stringForColumn:@"time"];
        entity.contact.name = [resultSet stringForColumn:@"contact_name"];
        entity.contact.job = [resultSet stringForColumn:@"job"];
        entity.contact.phone = [resultSet stringForColumn:@"phone"];
        
        [array addObject:entity];
    }
    
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
    for (int i = [array count]; i > 0; i--) {
        BuinessEntity *entity = [array objectAtIndex:i-1];
        [array2 addObject:entity];
    }
    return array2;
}

- (void) savePhoneOrder:(PhoneOrder *)entity
{
    /*
     CREATE TABLE "phone_order" ("packageSell" VARCHAR, "phoneNumber" VARCHAR, "customer" VARCHAR, "contact" VARCHAR, "contactPhone" VARCHAR, "doPerson" VARCHAR, "brand" VARCHAR, "name" VARCHAR, "color" VARCHAR, "type" VARCHAR, "rom" VARCHAR,   "stock" VARCHAR, "number_sell" VARCHAR, "pno" VARCHAR PRIMARY KEY  NOT NULL , "time" VARCHAR)
     */
    
    /*
     @property (nonatomic, strong) NSString *packageSell;
     @property (nonatomic, strong) NSString *phoneNumber;
     @property (nonatomic, strong) NSString *customer;
     @property (nonatomic, strong) NSString *contact;
     @property (nonatomic, strong) NSString *contactPhone;
     @property (nonatomic, strong) NSString *doPerson;
     @property (nonatomic, strong) NSString *time;
     @property (nonatomic, strong) NSString *pNo;
     */
    NSString *strSQL = @"INSERT INTO phone_order (packageSell, phoneNumber, customer, contact, contactPhone, doPerson, brand, name, color, type, rom, stock, number_sell, pno, time) VALUES (?, ?,?, ?,?, ?,?,?, ?,?, ?,?, ?,?,?);";
    
     BOOL res =  [self.db executeUpdate:strSQL, entity.packageSell, entity.phoneNumber, entity.customer, entity.contact, entity.contactPhone, entity.doPerson, entity.phoneEntity.brand, entity.phoneEntity.name, entity.phoneEntity.color, entity.phoneEntity.type, entity.phoneEntity.rom, entity.phoneEntity.stock, entity.phoneEntity.number_sell, entity.pNo, entity.time];
    
    if (res == NO) {
        ALERT_ERR_MSG(@"数据保存失败");
    }
}

- (NSMutableArray *) queryPhoneOrder
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM phone_order"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        PhoneOrder *entity = [[PhoneOrder alloc] init];
        entity.phoneEntity = [[PhoneEnity alloc] init];
        
        entity.packageSell = [resultSet stringForColumn:@"packageSell"];
        entity.phoneNumber = [resultSet stringForColumn:@"phoneNumber"];
        entity.customer = [resultSet stringForColumn:@"customer"];
        entity.contact = [resultSet stringForColumn:@"contact"];
        entity.contactPhone = [resultSet stringForColumn:@"contactPhone"];
        entity.doPerson = [resultSet stringForColumn:@"doPerson"];
        entity.phoneEntity.brand = [resultSet stringForColumn:@"brand"];
        entity.phoneEntity.name = [resultSet stringForColumn:@"name"];
        entity.phoneEntity.color = [resultSet stringForColumn:@"color"];
        entity.phoneEntity.type = [resultSet stringForColumn:@"type"];
        entity.phoneEntity.rom = [resultSet stringForColumn:@"rom"];
        entity.phoneEntity.stock = [resultSet stringForColumn:@"stock"];
        entity.phoneEntity.number_sell = [resultSet stringForColumn:@"number_sell"];
        entity.pNo = [resultSet stringForColumn:@"pno"];
        entity.time = [resultSet stringForColumn:@"time"];
        entity.status = @"客户经理受理中";
        
        [array addObject:entity];
    }
    
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
    for (int i = [array count]; i > 0; i--) {
        PhoneOrder *entity = [array objectAtIndex:i-1];
        [array2 addObject:entity];
    }
    
    return array2;
}

@end


