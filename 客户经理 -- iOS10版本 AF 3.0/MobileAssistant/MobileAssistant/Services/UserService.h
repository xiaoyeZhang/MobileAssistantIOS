//
//  UserService.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserEntity;

@interface UserService : NSObject

- (void)loginWithPassword:(NSDictionary *)param Successed:(void(^)(UserEntity *entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed;

@end
