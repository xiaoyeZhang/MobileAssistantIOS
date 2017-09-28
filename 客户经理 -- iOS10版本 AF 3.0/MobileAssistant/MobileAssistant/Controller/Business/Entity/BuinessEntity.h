//
//  BuinessEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-14.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BContactEntity.h"
@interface BuinessEntity : NSObject

@property (nonatomic, strong) NSString *bNO;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) BContactEntity *contact;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *time;

@end
