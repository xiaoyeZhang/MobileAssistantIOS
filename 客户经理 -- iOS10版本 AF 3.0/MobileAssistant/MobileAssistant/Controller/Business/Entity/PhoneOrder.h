//
//  PhoneOrder.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-14.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneEnity.h"

@interface PhoneOrder : NSObject

@property (nonatomic, strong) PhoneEnity *phoneEntity;
@property (nonatomic, strong) NSString *packageSell;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *customer;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *doPerson;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *pNo;
@property (nonatomic, strong) NSString *status;

@end
