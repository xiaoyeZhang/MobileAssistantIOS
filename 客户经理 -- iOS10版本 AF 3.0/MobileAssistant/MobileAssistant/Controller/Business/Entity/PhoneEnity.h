//
//  PhoneEnity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-14.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneEnity : NSObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *rom;
@property (nonatomic, strong) NSArray *arrayColor;
@property (nonatomic, strong) NSArray *arrayType;
@property (nonatomic, strong) NSArray *arrayRom;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *number_sell;

@end
