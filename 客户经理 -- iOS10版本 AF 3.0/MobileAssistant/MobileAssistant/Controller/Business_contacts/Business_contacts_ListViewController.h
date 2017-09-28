//
//  Business_contacts_ListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/1.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Business_contacts_ListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayCustomerTemp;
@end
