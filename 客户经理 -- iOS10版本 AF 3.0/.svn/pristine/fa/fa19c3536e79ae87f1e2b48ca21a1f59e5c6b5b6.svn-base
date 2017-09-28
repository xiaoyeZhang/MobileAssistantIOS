//
//  PlistLocalInfo.m
//  三个界面
//
//  Created by 林琪 on 15/8/9.
//  Copyright (c) 2015年 gem-inno. All rights reserved.
//

#import "PlistLocalInfo.h"

@implementation PlistLocalInfo


-(id)init
{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _rootPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserPlist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_rootPath]==NO) {
            if(![[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:NO attributes:nil error:nil]){
                
            }
        }
    }
    return self;
}

-(BOOL)createDirectory:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]) {
            // error
            return NO;
        }
    }
    return YES;
}

//存放用户信息的文件
-(NSString *)userInformationPath
{
    //    NSString *path = [_rootPath stringByAppendingPathComponent:@"LoginInfo.plist"];
    if ([self createDirectory:_rootPath]) {
        return _rootPath;
    }
    return nil;
}


@end
