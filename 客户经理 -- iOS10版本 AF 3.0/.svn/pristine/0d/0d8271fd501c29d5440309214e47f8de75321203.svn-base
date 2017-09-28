//
//  Verify.m
//  MobileAssistant
//
//  Created by 许孝平 on 14-4-19.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import "Verify.h"

@implementation Verify

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//验证字符串中仅包含字母和数字，
+(bool)verifyCharacters:(NSString*)inputstring
{
    NSString * regex = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputstring];
    
    return  isMatch;
}

//验证字符串数字，
+(bool)verifyNumbers:(NSString*)inputstring
{
    NSString * regex = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputstring];
    
    return  isMatch;
}

//验证6位字符串数字
+(bool)verifyLimitLenghtCode:(NSString*)inputstring
{
    NSString * regex = @"^[0-9]{6,6}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputstring];
    
    return  isMatch;
}

//以首字母打头 2到20位，字母，数字，中划线，下划线
+(bool)verifyUserName:(NSString*)inputString
{
    
    NSString * regex = @"^[a-zA-Z][-_\\w]{1,19}+$"; //以首字母打头 2到20位，字母，数字，中划线，下划线
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputString];
    return  isMatch;
}

//银行卡号 16到25位数字
+(bool)verifyBankCardNo:(NSString*)inputString
{
    NSString * regex = @"^[0-9]{16,25}+$"; //银行卡号 16到25位数字
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputString];
    return  isMatch;
}


//中文长度2-10
+(bool)verifyChineseCharactor:(NSString*)inputString
{
    NSString * regex = @"^[\u4e00-\u9fa5]{2,10}+$"; //中文长度2-10
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputString];
    return  isMatch;
}

//验证email
+(bool)verifyEmail:(NSString*)inputString
{
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:inputString];
    
}


@end
