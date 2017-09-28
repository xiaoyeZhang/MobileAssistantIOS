//
//  GroupOrderModel.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "GroupOrderModel.h"

@implementation GroupOrderModel

@synthesize BigActivityName;
@synthesize OfferType;
@synthesize ExpireDate;
@synthesize EffectiveDate;
@synthesize OfferId;
@synthesize BillId;
@synthesize OperType;
@synthesize EffectiveType;
@synthesize Price;
@synthesize OfferName;
@synthesize BillingType;
@synthesize AttrInstInfo;
@synthesize ProdInstInfo;

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
//    self.BigActivityName = [attributes valueForKeyPath:@"BigActivityName"];
    self.OfferType = [attributes valueForKeyPath:@"OfferType"];
    self.ExpireDate = [attributes valueForKeyPath:@"ExpireDate"];
    self.EffectiveDate= [attributes valueForKeyPath:@"EffectiveDate"];
//    self.OfferId= [attributes valueForKeyPath:@"OfferId"];
//    self.BillId= [attributes valueForKeyPath:@"BillId"];
    self.EffectiveType = [attributes valueForKeyPath:@"EffectiveType"];
    self.OfferName= [attributes valueForKeyPath:@"OfferName"];
    self.BillingType = [attributes valueForKeyPath:@"BillingType"];
    self.AttrInstInfo = [attributes valueForKeyPath:@"AttrInstInfo"];
    self.ProdInstInfo = [attributes valueForKeyPath:@"ProdInstInfo"];
    
    if (![[attributes valueForKeyPath:@"OfferId"] isKindOfClass:[NSNull class]]){
        self.OfferId= [attributes valueForKeyPath:@"OfferId"];
    }else{
        self.OfferId = @"";
    }
    
    if (![[attributes valueForKeyPath:@"BillId"] isKindOfClass:[NSNull class]]){
        self.BillId= [attributes valueForKeyPath:@"BillId"];
    }else{
        self.BillId = @"";
    }
    
    if (![[attributes valueForKeyPath:@"BigActivityName"] isKindOfClass:[NSNull class]]){
        self.BigActivityName= [attributes valueForKeyPath:@"BigActivityName"];
    }else{
        self.BigActivityName = @"";
    }
    
    if (![[attributes valueForKeyPath:@"Price"] isKindOfClass:[NSNull class]]){
        self.Price= [attributes valueForKeyPath:@"Price"];
    }else{
        self.Price = @"";
    }
    
    if (![[attributes valueForKeyPath:@"OperType"] isKindOfClass:[NSNull class]]){
        self.OperType= [attributes valueForKeyPath:@"OperType"];
    }else{
        self.OperType = @"";
    }
    return self;
}

@end
