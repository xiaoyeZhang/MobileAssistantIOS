//
//  Business_change_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/7.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Business_change_listViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;

@end
