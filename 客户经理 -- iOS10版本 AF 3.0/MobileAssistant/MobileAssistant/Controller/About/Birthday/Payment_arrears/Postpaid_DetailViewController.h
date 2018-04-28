//
//  Postpaid_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/25.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Postpaid_ListEntity.h"

@interface Postpaid_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Postpaid_ListEntity *entity;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况

@end
