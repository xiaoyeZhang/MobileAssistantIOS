//
//  LocationEntity.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-15.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationEntity : NSObject

@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lont;
@property (nonatomic, strong) NSString *lat;
@property (assign) int times;
//area_id;区域id
//name;区
//lont;经度
//lat;纬度
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void) deepCopy:(LocationEntity *)sender;
+ (id)sharedInstance;

@end
