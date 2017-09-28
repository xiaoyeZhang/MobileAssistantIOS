//
//  Focus_ListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface Focus_ListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (nonatomic, strong)NIDropDown *dropDown;

@property (strong, nonatomic)  NSMutableArray *arrayCustomerTemp;
@end
