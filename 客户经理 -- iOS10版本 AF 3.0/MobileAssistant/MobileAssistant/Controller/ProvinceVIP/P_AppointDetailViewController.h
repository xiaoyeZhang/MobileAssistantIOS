//
//  P_AppointDetailViewController.h
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "BusinessListModel.h"

@interface P_AppointDetailViewController : XYBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
}

//@property(nonatomic, copy) NSString *businessId;
@property(nonatomic, strong) BusinessListModel *bListModel;

@end
