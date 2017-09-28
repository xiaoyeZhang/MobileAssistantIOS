//
//  BusinessUtils.h
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-15.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuinessEntity.h"
#import "PhoneOrder.h"
#import "FMDB.h"

@interface BusinessUtils : NSObject

@property (nonatomic, strong) FMDatabase *db;
+ (id)sharedInstance;
- (BOOL) openDb;
- (void) saveBusinessOrder:(BuinessEntity *)entity;
- (NSMutableArray *) queryBusinessOrder;

- (void) savePhoneOrder:(PhoneOrder *)entity;
- (NSMutableArray *) queryPhoneOrder;

@end
