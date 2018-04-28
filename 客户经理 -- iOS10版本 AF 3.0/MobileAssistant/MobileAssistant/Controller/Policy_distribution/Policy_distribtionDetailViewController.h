//
//  Policy_distribtionDetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Policy_distribtionDetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *s_id;
@property (copy, nonatomic) NSString *type_id;
@end
