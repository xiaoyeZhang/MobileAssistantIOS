//
//  Business_MarkingPlanListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupOrderModel.h"

@interface Business_MarkingPlanListViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GroupOrderModel *entity;
@end
