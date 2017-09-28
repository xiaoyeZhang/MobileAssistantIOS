//
//  LevelEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-12-18.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelEntity : NSObject

@property (nonatomic, strong) NSString *lid;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
