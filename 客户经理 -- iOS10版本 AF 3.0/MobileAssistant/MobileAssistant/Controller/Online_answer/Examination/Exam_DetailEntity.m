//
//  Exam_DetailEntity.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/26.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Exam_DetailEntity.h"

@implementation Exam_DetailEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.subject_id = [attributes valueForKey:@"subject_id"];
    self.title = [attributes valueForKey:@"title"];
    self.type_id = [attributes valueForKey:@"type_id"];
    self.options = [attributes valueForKey:@"options"];
    self.right_answer = [attributes valueForKey:@"right_answer"];
    self.library_id = [attributes valueForKey:@"library_id"];
    
    return self;
    
}

@end
