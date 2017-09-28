//
//  Contract_expries_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Contract_expries_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *contract_id;

@end
