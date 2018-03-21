//
//  Overtime_work_childlistViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/12.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Overtime_work_childlistViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;

@end
