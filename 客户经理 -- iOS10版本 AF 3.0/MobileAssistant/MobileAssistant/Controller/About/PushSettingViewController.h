//
//  PushSettingViewController.h
//  MobileAssistant
//
//  Created by xy on 15/10/20.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UserCenterViewController.h"

@interface PushSettingViewController : XYBaseViewController<UITableViewDataSource,
                                                            UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIButton *dateBtn;
    __weak IBOutlet UISwitch *smsSwitch;
}

@property (strong, nonatomic) UIView *superView;
@property (weak, nonatomic) id<UserCenterViewControllerDelegate>delegate;

@end
