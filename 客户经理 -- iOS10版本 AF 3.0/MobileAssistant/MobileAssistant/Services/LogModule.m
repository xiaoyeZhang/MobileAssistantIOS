//
//  LogModule.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/22.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "LogModule.h"
#import "CommonService.h"

@implementation LogModule


- (void)Select_LogModule:(NSString *)module{
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"logmodule",
                           @"log_type":module,
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        


    } Failed:^(int errorCode, NSString *message) {

    }];
        
}

- (void)Select_statistics:(NSString *)info{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"frequency_statistics",
                           @"info":info,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        //        NSNumber *state = [entity valueForKeyPath:@"state"];
        //        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
    
}

@end
