//
//  Customer_epresentativeViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateViewController.h"
#import "Task_Two_CreateViewController.h"

@interface Customer_epresentativeViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TaskCreateViewController *tcVC;
@property (nonatomic, strong) Task_Two_CreateViewController *t_two_cVC;

@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;

@property (assign, nonatomic) int enter_type;
@end
