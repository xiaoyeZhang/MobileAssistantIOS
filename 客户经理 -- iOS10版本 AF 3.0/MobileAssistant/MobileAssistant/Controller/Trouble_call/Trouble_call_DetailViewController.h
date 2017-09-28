//
//  Trouble_call_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/4.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Oder_DemandEntity.h"

@interface Trouble_call_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *order_id;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况
@end
