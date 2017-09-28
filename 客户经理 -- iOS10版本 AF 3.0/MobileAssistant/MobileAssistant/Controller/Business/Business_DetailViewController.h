//
//  Business_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupOrderModel.h"

@interface Business_DetailViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetail;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (strong, nonatomic) GroupOrderModel *entity;
@property (strong, nonatomic) NSString *GroupId;

@end
