//
//  Utilies.h
//  MobileAssistant
//
//  Created by 许孝平 on 14-4-16.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilies : NSObject

+ (NSString *)getImageHeaderPath;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)loadHeaderImage;

+ (NSString *)getCheckInImagePath;
+ (NSArray *)loadCheckInImage;

+ (void)UploadImage:(NSString *)imagePath;

//在图片上添加文字
+ (UIImage *)imageAddText:(UIImage *)img textArray:(NSArray *)textArray;

//+ (NSString *)getImageStartWorkDirectoryPath;
//+ (NSString *)getImageEndWorkDirectoryPath;

+ (NSString *)GetUUID;

+ (NSString *) GetNowDate;
+ (NSString *) GetNowDateTime;

+ (NSString *) NSDateToNSString:(NSDate *)date;
+ (NSString *) NSDateToShortDateNSString:(NSDate *)date;
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;

+ (NSString *) getLastMonth;
+ (NSString *) getLastWeek;

//获取一个随机整数，范围在[from,to），包括from，不包括to
+ (NSString *) NSDateToString:(NSDate *)date;
+ (int)getRandomNumber:(int)from to:(int)to;

+ (BOOL) isCurrentWeek:(NSString *)dateStr;
+ (BOOL) isCurrentMonth:(NSString*)dateStr;
+ (BOOL) isCurrentDay:(NSString*)dateStr;

@end
