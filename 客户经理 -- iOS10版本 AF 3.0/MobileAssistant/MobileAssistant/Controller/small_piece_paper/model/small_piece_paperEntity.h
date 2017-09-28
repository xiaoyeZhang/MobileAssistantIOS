//
//  small_piece_paperEntity.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/13.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface small_piece_paperEntity : NSObject


@property (nonatomic, copy) NSString *tape_id;
@property (nonatomic, copy) NSString *isnew;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *img_name;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *create_name;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *reply_content;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
