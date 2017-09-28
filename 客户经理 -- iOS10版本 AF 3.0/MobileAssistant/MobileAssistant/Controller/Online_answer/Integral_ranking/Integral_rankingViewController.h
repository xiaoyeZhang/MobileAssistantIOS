//
//  Integral_rankingViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/9.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Integral_rankingViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextFile;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *rank_numLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;
@end
