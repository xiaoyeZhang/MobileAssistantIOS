//
//  BillSubInfoModel.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillSubInfoModel : NSObject

@property (nonatomic, strong) NSArray *BillSubInfo;
@property (nonatomic, strong) NSString *AccountId;

@property (nonatomic, strong) NSString *SubName;
@property (nonatomic, strong) NSString *YingShou;
@property (nonatomic, strong) NSString *SubFee;
@property (nonatomic, strong) NSString *TiaoZhang;
@property (nonatomic, strong) NSString *ZhangWuYouhui;
@property (nonatomic, strong) NSString *XianDanYouHui;

@property (nonatomic, strong) NSString *AcctName;
@property (nonatomic, strong) NSString *BillingCycle;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
