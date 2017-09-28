//
//  GroupIDModel.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupIDModel : NSObject

@property (nonatomic, strong) NSString *AcctAlias;
@property (nonatomic, strong) NSString *EffectDate;
@property (nonatomic, strong) NSString *AccountId;
@property (nonatomic, strong) NSString *AccountName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
