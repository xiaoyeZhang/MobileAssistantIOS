//
//  UserCenterViewController.h
//  MobileAssistant
//
//  Created by xy on 15/10/15.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "MainViewController.h"

@protocol UserCenterViewControllerDelegate <NSObject>

- (void)successDelegate:(NSString *)push_starttime andWithEndtime:(NSString *)push_endtime;

@end

@interface UserCenterViewController : XYBaseViewController<UITableViewDataSource,
                                                           UITableViewDelegate,UserCenterViewControllerDelegate>
{
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic, weak) MainViewController *mainVC;


- (void) loadData;

@end
