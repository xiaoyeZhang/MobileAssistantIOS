//
//  Arrear_task_DeatilViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/24.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Arrears_taskEntity.h"

@interface Arrear_task_DeatilViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Arrears_taskEntity *entity;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况

@end
