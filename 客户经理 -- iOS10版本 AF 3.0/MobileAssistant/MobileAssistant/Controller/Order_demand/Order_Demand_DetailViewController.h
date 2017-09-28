//
//  Order_Demand_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/28.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Oder_DemandEntity.h"

@interface Order_Demand_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Oder_DemandEntity *entity;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况

@end
