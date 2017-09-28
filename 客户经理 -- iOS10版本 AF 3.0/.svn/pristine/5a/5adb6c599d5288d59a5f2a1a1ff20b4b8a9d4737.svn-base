//
//  UserEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *reason;
@property (nonatomic,strong) NSString *weather;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *dep_id;
@property (nonatomic,strong) NSString *type_id;
@property (nonatomic,strong) NSString *area_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic, copy) NSString *dep_name;
@property (nonatomic, copy) NSString *num; /*工号*/
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSString *is_first; // 1 : 为首席代表
+ (id)sharedInstance;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void) deepCopy:(UserEntity *)sender;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
