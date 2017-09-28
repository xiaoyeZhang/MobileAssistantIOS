//
//  M_Order_Demand_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface M_Order_Demand_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *order_id;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况

@end
