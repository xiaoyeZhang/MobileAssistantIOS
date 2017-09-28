//
//  Product_VisitListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product_VisitListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;

@end
