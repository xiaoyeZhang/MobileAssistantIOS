//
//  P_ContractListViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/5.
//  Copyright (c) 2015年 avatek. All rights reserved.
//  合同列表

#import "XYBaseViewController.h"
#import "BillListModel.h"

@class P_ContractListViewController;
@protocol ContractListViewControllerDelegate <NSObject>

@optional
- (void)contractListViewController:(P_ContractListViewController *)vc
                  didSelectedModel:(BillListModel *)model;

@end

@interface P_ContractListViewController : XYBaseViewController<UITableViewDataSource,
                                                               UITableViewDelegate,
                                                               UISearchBarDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISearchBar *_searchBar;
    
}

@property(nonatomic, weak) id<ContractListViewControllerDelegate> delegate;

@end
