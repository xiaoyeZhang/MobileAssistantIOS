//
//  phone.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "phone.h"
#import "PlistLocalInfo.h"

@implementation phone

//写入plist文件
-(void)saveToPlist:(NSMutableDictionary *)listDic andSuccess:(void (^)(NSString *))successSave
{
    PlistLocalInfo *localInfo = [[PlistLocalInfo alloc]init];
    NSString *infoPath = [localInfo userInformationPath];
    NSString *lastPath = [infoPath stringByAppendingPathComponent:@"PlistLocalInfo.plist"];
    
    if ([listDic writeToFile:lastPath atomically:YES]) {
        successSave(@"写入成功");
    }
    
    else {
        successSave(@"写入失败");
    }
}

//读取plist文件
-(void)readToPlist:(void (^)(NSMutableDictionary *))successRead
{
    PlistLocalInfo *localInfo = [[PlistLocalInfo alloc]init];
    NSString *infoPath = [localInfo userInformationPath];
    NSString *lastPath = [infoPath stringByAppendingPathComponent:@"PlistLocalInfo.plist"];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithContentsOfFile:lastPath];
    
    if (newDic) {
        successRead(newDic);
    }
    else {
        
    }
}

@end
