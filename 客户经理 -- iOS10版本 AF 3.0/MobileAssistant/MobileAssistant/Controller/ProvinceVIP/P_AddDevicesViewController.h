//
//  P_AddDevicesViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"

@class P_AddDevicesViewController;
@protocol AddDevicesViewControllerDelegate <NSObject>

@optional
- (void)addDevicesViewController:(P_AddDevicesViewController *)vc addDevicesInfo:(NSString *)info;

@end

@interface P_AddDevicesViewController : XYTableBaseViewController<UITableViewDataSource,
                                                                  UITableViewDelegate>

@property(nonatomic, copy) NSString *device_info;
@property(nonatomic, weak) id<AddDevicesViewControllerDelegate> delegate;
@property(nonatomic, copy) NSString *order_type;

@end
