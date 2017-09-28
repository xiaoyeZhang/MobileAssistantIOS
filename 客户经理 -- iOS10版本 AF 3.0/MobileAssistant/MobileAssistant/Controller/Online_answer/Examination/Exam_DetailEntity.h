//
//  Exam_DetailEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/26.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exam_DetailEntity : NSObject


@property (copy, nonatomic) NSString *subject_id;

@property (copy, nonatomic) NSString *title;//题干

@property (copy, nonatomic) NSString *type_id;//0-单选  1-复选

@property (copy, nonatomic) NSString *options;//选项

@property (copy, nonatomic) NSString *right_answer;//正确答案（无需解析）

@property (copy, nonatomic) NSString *library_id;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
