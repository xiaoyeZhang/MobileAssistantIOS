//
//  ExecutorViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateViewController.h"
#import "Task_Two_CreateViewController.h"

@interface ExecutorViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewExecutor;
@property (nonatomic, strong) NSMutableArray *arrayExecutor;

@property (nonatomic, strong) TaskCreateViewController *tcVC;
@property (nonatomic, strong) Task_Two_CreateViewController *t_two_VC;

@property (assign) int enter_type;
@end
