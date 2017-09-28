//
//  Exam_historylistEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exam_historylistEntity : NSObject

@property (copy, nonatomic) NSString *answer_id;

@property (copy, nonatomic) NSString *user_id;

@property (copy, nonatomic) NSString *select_subject_ids;

@property (copy, nonatomic) NSString *submit_subject_answers;

@property (copy, nonatomic) NSString *score;

@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *exam_id;

@property (copy, nonatomic) NSString *right_num;

@property (copy, nonatomic) NSString *wrong_num;

@property (copy, nonatomic) NSString *resit_right_num;

@property (copy, nonatomic) NSString *resit_wrong_num;

@property (copy, nonatomic) NSString *type_id;

@property (copy, nonatomic) NSString *title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
