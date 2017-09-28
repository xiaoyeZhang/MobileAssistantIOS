//
//  Marking_Detail_ListEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/18.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marking_Detail_ListEntity : NSObject


@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *num;

@property (copy, nonatomic) NSString *end_time;

@property (copy, nonatomic) NSString *start_time;

@property (copy, nonatomic) NSString *sub_marketing_id;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
