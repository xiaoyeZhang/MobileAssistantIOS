//
//  PackageEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-24.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageEntity : NSObject
@property (nonatomic, strong) NSString *packageId;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
