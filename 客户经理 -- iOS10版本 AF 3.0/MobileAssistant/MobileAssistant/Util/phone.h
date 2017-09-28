//
//  phone.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface phone : NSObject

//写入plist文件
-(void)saveToPlist:(NSMutableDictionary *)dictionary andSuccess:(void (^)(NSString *successInfo))successSave;

//读取plist文件
-(void)readToPlist:(void (^)(NSMutableDictionary *saveDic))successRead;


@end
