//
//  SummaryEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-5.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryEntity : NSObject

//@property (nonatomic, strong) NSString *today;
//@property (nonatomic, strong) NSString *this_week;
//@property (nonatomic, strong) NSString *this_month;
//@property (nonatomic, strong) NSString *last_month;
//@property (nonatomic, strong) NSString *today_finish;
//@property (nonatomic, strong) NSString *this_week_finish;
//@property (nonatomic, strong) NSString *this_month_finish;
//@property (nonatomic, strong) NSString *last_month_finish;
@property (nonatomic, strong) NSNumber *today;
@property (nonatomic, strong) NSNumber *this_week;
@property (nonatomic, strong) NSNumber *this_month;
@property (nonatomic, strong) NSNumber *last_month;
@property (nonatomic, strong) NSNumber *today_finish;
@property (nonatomic, strong) NSNumber *this_week_finish;
@property (nonatomic, strong) NSNumber *this_month_finish;
@property (nonatomic, strong) NSNumber *last_month_finish;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
