//
//  Exam_study_listEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exam_study_listEntity : NSObject


@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *point;

@property (copy, nonatomic) NSString *dep_name;

@property (copy, nonatomic) NSString *user_id;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
