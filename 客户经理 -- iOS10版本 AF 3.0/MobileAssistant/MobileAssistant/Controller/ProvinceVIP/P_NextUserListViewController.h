//
//  P_NextUserListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"

@class P_NextUserListViewController;
@protocol NextUserListViewControllerDelegate <NSObject>

@optional
- (void)NextuserListViewController:(P_NextUserListViewController *)vc didSelectUser:(UserListModel *)model;

@end
@interface P_NextUserListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, copy) NSString *business_id;

@property(nonatomic, weak) id<NextUserListViewControllerDelegate> delegate;
@end

