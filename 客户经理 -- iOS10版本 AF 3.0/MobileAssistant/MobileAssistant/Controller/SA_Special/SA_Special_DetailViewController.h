//
//  SA_Special_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/8/7.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface SA_Special_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *order_id;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况
@end
