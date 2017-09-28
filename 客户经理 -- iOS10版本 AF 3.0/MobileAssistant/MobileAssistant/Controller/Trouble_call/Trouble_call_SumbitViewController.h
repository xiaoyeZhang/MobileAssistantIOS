//
//  Trouble_call_SumbitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/4.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompEntity.h"

@interface Trouble_call_SumbitViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CompEntity *entity;

@end
