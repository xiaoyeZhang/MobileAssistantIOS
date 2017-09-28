//
//  Exam_History_DetailEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exam_History_DetailEntity : NSObject

@property (copy, nonatomic) NSString *subject_id;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *type_id;

@property (copy, nonatomic) NSString *options;

@property (copy, nonatomic) NSString *right_answer;

@property (copy, nonatomic) NSString *library_id;

@property (copy, nonatomic) NSString *select_answer;

@property (copy, nonatomic) NSString *is_right;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
