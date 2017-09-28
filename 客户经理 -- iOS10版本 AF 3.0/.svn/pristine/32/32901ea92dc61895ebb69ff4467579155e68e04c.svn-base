//
//  Business_StopOpenViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/15.
//  Copyright © 2015年 avatek. All rights reserved.
//

/** 
 停开机状态 管理停机：第26位；
 营业停机：第3位；
 账务停机：第15位（欠费单停，呼出限制）和16位（欠费停） 
 复机:0
 停机:1
 */

#import <UIKit/UIKit.h>

@interface Business_StopOpenViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *ServiceNum;
@property (copy, nonatomic) NSString *Administration;
@property (copy, nonatomic) NSString *Business;
@property (copy, nonatomic) NSString *Accounting;
@property (copy, nonatomic) NSString *StateType;

- (void)loadData;
@end
