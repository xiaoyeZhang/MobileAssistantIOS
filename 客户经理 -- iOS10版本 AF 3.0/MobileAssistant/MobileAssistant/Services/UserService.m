//
//  UserService.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "UserService.h"
#import "UserEntity.h"
#import "AFNetworking.h"

@implementation UserService

- (void)loginWithPassword:(NSDictionary *)param Successed:(void(^)(UserEntity *entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

//    [self customSecurityPolicy:manager];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:BASEURL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        DebugLog(@"%@", result);
//        
//        NSError *e;
//        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&e];
        
        UserEntity *entity = [[UserEntity alloc] init];
        entity = [entity initWithAttributes:responseObject];
        UserEntity *userEntity = [UserEntity sharedInstance];
        [userEntity deepCopy:entity];
        successed(entity);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger errorCode = error.code;
        NSString *errorMessage = [error localizedDescription];
        
        failed(errorCode,errorMessage);
    }];
    
}

- (void)customSecurityPolicy:(AFHTTPSessionManager *)manager
{
    
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"dayo.net.cn" ofType:@"cer"];

    if (cerPath == nil) {
        NSLog(@"***文件路径没找到");
    }

    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setPinnedCertificates:@[cerData]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
}

@end
