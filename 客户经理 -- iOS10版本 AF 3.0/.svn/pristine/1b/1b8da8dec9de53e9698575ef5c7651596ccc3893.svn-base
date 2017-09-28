//
//  UploadPictureService.h
//  MobileAssistant
//
//  Created by 许孝平 on 14-5-10.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PictureEntity;

@interface UploadPictureService : NSObject

- (BOOL)uploadPicture:(NSString *)fileName Image:(NSData *)imageData;
- (BOOL)uploadPicture:(NSString *)state ImageFileName:(NSString *)fileName Image:(NSData *)imageData;

- (BOOL)addPictureToDB:(PictureEntity *)entity;
- (BOOL)deletePictureFromDBWithID:(NSString *)pictureID;
- (NSArray *)loadAllPictureFromDB;

@end
