//
//  Exam_historylistEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Exam_historylistEntity.h"

@implementation Exam_historylistEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.answer_id = [attributes valueForKey:@"answer_id"];
    self.user_id = [attributes valueForKey:@"user_id"];
    self.select_subject_ids = [attributes valueForKey:@"select_subject_ids"];
    self.submit_subject_answers = [attributes valueForKey:@"submit_subject_answers"];
    self.score = [attributes valueForKey:@"score"];
    self.time = [attributes valueForKey:@"time"];

    self.exam_id = [attributes valueForKey:@"exam_id"];
    self.right_num = [attributes valueForKey:@"right_num"];
    self.wrong_num = [attributes valueForKey:@"wrong_num"];
    self.resit_right_num = [attributes valueForKey:@"resit_right_num"];
    
    self.resit_wrong_num = [attributes valueForKey:@"resit_wrong_num"];
    self.type_id = [attributes valueForKey:@"type_id"];
    self.title = [attributes valueForKey:@"title"];
    
    return self;
    
}

@end
