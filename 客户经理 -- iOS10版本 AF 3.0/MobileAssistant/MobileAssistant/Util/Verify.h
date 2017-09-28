//
//  Verify.h
//  MobileAssistant
//
//  Created by 许孝平 on 14-4-19.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Verify : NSObject

+ (BOOL)validateMobile:(NSString *)mobileNum;

//验证字符串中仅包含字母和数字，
+(bool)verifyCharacters:(NSString*)inputstring;

//验证字符串数字，
+(bool)verifyNumbers:(NSString*)inputstring;

//验证短信校验码： 6位数字
+(bool)verifyLimitLenghtCode:(NSString*)inputstring ;

//占便宜用户名校验 2到20位，字母，数字 ，下划线，中划线
+(bool)verifyUserName:(NSString*)inputString;

//银行卡号，16到25位数字
+(bool)verifyBankCardNo:(NSString*)inputString;

//中文，长度2-10
+(bool)verifyChineseCharactor:(NSString*)inputString;

//验证email
+(bool)verifyEmail:(NSString*)inputString;

@end
