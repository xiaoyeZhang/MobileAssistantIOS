//
//  Manangement_detailListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/1/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Manangement_detailListViewController : XYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *business_info;
@end
