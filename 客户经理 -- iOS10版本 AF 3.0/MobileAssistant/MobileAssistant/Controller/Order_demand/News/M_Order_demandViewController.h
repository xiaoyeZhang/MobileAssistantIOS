//
//  M_Order_demandViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M_Order_demandViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;

@end
