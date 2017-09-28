//
//  MALocationEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 15/5/6.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MALocationEntity : NSObject

@property (nonatomic, strong) NSString *area_id;
@property (atomic, strong) NSString *name;
@property (atomic, strong) NSString *lont;
@property (atomic, strong) NSString *lat;
@property (assign) int times;
//area_id;区域id
//name;区
//lont;经度
//lat;纬度
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void) deepCopy:(MALocationEntity *)sender;
+ (MALocationEntity *)sharedInstance;
@end