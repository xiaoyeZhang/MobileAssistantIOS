//
//  GroupOrderModel.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 失效日期:ExpireDate
 套餐id:OfferId  BillId
 操作类型 0：订购;1：退订;2：变更 : OperType
 生效类型 0：立即生效；1：下周期生效；2：指定生效 :   EffectiveType
 套餐价格 :Price
 生效日期:EffectiveDate
 套餐名称:OfferName
 计费类型 0：免费；1：按条计费；2：包月计费；3：包时计费；4：包次计费；5：按照栏目包月   BillingType
 产品属性类列表:AttrInstInfo
 产品实例信息列表:ProdInstInfo
 集团名称：GroupName
 集团编号：GroupId
*/

@interface GroupOrderModel : NSObject

@property (nonatomic, strong) NSString *BigActivityName;
@property (nonatomic, strong) NSString *ExpireDate;
@property (nonatomic, strong) NSString *EffectiveDate;
@property (nonatomic, strong) NSString *OfferId;
@property (nonatomic, strong) NSString *OfferType;
@property (nonatomic, strong) NSString *BillId;
@property (nonatomic, strong) NSString *OperType;
@property (nonatomic, strong) NSString *EffectiveType;
@property (nonatomic, strong) NSString *Price;
@property (nonatomic, strong) NSString *OfferName;
@property (nonatomic, strong) NSString *BillingType;
@property (nonatomic, strong) NSMutableArray *AttrInstInfo;
@property (nonatomic, strong) NSMutableArray *ProdInstInfo;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
