//
//  Management_business_ListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/1/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@class Management_business_ListViewController;

@protocol Management_business_ListViewControllerDelegate <NSObject>
@optional
- (void)Management_business_ListViewController:(Management_business_ListViewController *)vc addInfo:(NSString *)info;

@end

@interface Management_business_ListViewController : XYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak,nonatomic) id<Management_business_ListViewControllerDelegate>delegate;

@property(nonatomic, copy) NSString *device_info;

@end
