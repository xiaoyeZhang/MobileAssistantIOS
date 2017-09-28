//
//  BillSubInfoModel.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "BillSubInfoModel.h"

@implementation BillSubInfoModel

@synthesize BillSubInfo;
@synthesize AccountId;
@synthesize AcctName;
@synthesize BillingCycle;
@synthesize SubName;
@synthesize YingShou;
@synthesize SubFee;
@synthesize TiaoZhang;
@synthesize ZhangWuYouhui;
@synthesize XianDanYouHui;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.SubName = [attributes valueForKeyPath:@"SubName"];
    self.YingShou = [attributes valueForKeyPath:@"YingShou"];
    self.SubFee= [attributes valueForKeyPath:@"SubFee"];
    self.TiaoZhang= [attributes valueForKeyPath:@"TiaoZhang"];
    self.ZhangWuYouhui= [attributes valueForKeyPath:@"ZhangWuYouhui"];
    self.XianDanYouHui= [attributes valueForKeyPath:@"XianDanYouHui"];
    
    return self;
}

@end
