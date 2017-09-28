//
//  Utilies.m
//  MobileAssistant
//
//  Created by 许孝平 on 14-4-16.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import "Utilies.h"

@implementation Utilies

+ (NSString *)getImageHeaderPath {
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/HeaderImage"];
    if (![fileManger fileExistsAtPath:path]) {
        NSError *err;
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    }
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/HeaderImage/header.png"];
}

+ (UIImage *)loadHeaderImage {
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *headerImagePath = [Utilies getImageHeaderPath];
    if ([fileManger fileExistsAtPath:headerImagePath]) {
        return [UIImage imageWithContentsOfFile:headerImagePath];
    }
    else {
        return nil;
    }
}

+ (NSString *)getCheckInImagePath
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CheckIn"];
    if (![fileManger fileExistsAtPath:path]) {
        NSError *err;
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    }
    return path;
}

+ (NSArray *)loadCheckInImage
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *imagePath = [Utilies getCheckInImagePath];
    if ([fileManger fileExistsAtPath:imagePath]) {
        NSError *error;
        NSArray *array = [fileManger contentsOfDirectoryAtPath:imagePath error:&error];
        if (error) {
            return nil;
        }
        return array;
    }
    else {
        return nil;
    }
}

+ (void)UploadImage:(NSString *)imagePath
{
    
}

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//+ (NSString *)getImageStartWorkDirectoryPath {
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/StartWork"];
//    if (![fileManger fileExistsAtPath:path]) {
//        NSError *err;
//        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
//    }
//    return path;
//}
//
//+ (NSString *)getImageEndWorkDirectoryPath {
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/EndWork"];
//    if (![fileManger fileExistsAtPath:path]) {
//        NSError *err;
//        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
//    }
//    return path;
//}

+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage == nil)
    {
        return nil;
    }
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
        {
            transform = CGAffineTransformIdentity;
            break;
        }
        case UIImageOrientationUpMirrored: //EXIF = 2
        {
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        }
        case UIImageOrientationDown: //EXIF = 3
        {
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
        case UIImageOrientationDownMirrored: //EXIF = 4
        {
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        }
        case UIImageOrientationLeftMirrored: //EXIF = 5
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationLeft: //EXIF = 6
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationRightMirrored: //EXIF = 7
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        case UIImageOrientationRight: //EXIF = 8
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        default:
        {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
        }
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


+ (UIImage *)imageAddText:(UIImage *)img textArray:(NSArray *)textArray
{
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor blackColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSInteger count = [textArray count];
    for (int i= 0; i<count; i++) {
        NSString *mark = [textArray objectAtIndex:i];
        [mark drawInRect:CGRectMake(10, 30 + i*90, w - 10, 40) withFont:[UIFont systemFontOfSize:80]];
    }
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
    
}

+ (NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge NSString *)string ;
}

+ (NSString *) GetNowDate
{
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"%@",newDateOne);
    return newDateOne;
}

+ (NSString *) GetNowDateTime
{
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"%@",newDateOne);
    return newDateOne;
}

+ (NSString *) NSDateToNSString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *) NSDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *) NSDateToShortDateNSString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *) getLastWeek
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] ))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    //[components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSLog(@"lastWeek=%@",lastWeek);
    //NSLog(@"lastMonth=%@",lastMonth);
    NSString * strLastMonth = [dateformat stringFromDate:lastMonth];
    NSString * strLasWeek = [dateformat stringFromDate:lastWeek];
    
    return strLasWeek;
}

+ (NSString *) getLastMonth
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day])];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    //[components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    //NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"lastMonth=%@",lastMonth);
    NSString * strLastMonth = [dateformat stringFromDate:lastMonth];
    NSString * strLasWeek = [dateformat stringFromDate:lastWeek];
    
    return strLastMonth;
}

+ (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}


/**
 **判断 日期是否是本周
 **/

+ (BOOL) isCurrentWeek:(NSString *)dateStr
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];

    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setFirstWeekday:2];//一周的第一天设置为周一
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];

    if(!success)
        return NO;

    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs >= dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isCurrentMonth:(NSString*)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    NSDate * newDate = [NSDate date];
    NSCalendar* calendar2 = [NSCalendar currentCalendar];
    NSDateComponents* components2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate]; // Get necessary date components
    
    if ([components year] == [components2 year]) {
        if ([components month] == [components2 month]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL) isCurrentDay:(NSString*)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    NSDate * newDate = [NSDate date];
    NSCalendar* calendar2 = [NSCalendar currentCalendar];
    NSDateComponents* components2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate]; // Get necessary date components
    
    if ([components year] == [components2 year]) {
        if ([components month] == [components2 month]) {
            if ([components2 day] == [components day]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
