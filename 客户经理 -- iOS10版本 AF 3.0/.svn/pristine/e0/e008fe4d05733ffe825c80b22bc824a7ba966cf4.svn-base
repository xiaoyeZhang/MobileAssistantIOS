//
//  P_UserListViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UserListModel.h"

@class P_UserListViewController;
@protocol UserListViewControllerDelegate <NSObject>

@optional
- (void)userListViewController:(P_UserListViewController *)vc didSelectUser:(UserListModel *)model;

@end


@interface P_UserListViewController : XYBaseViewController<UITableViewDataSource,
                                                            UITableViewDelegate,
                                                            UISearchBarDelegate>
{
    __weak IBOutlet UISearchBar *_searchBar;
    
    __weak IBOutlet UITableView *_tableView;
}

@property(nonatomic, copy) NSString *type_id; //类型 2:二级经理
@property(nonatomic, copy) NSString *dep_id; //部门id
@property(nonatomic, copy) NSString *model_id;

@property(nonatomic, weak) id<UserListViewControllerDelegate> delegate;

@end
