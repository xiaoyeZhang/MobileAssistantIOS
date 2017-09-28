//
//  Business_AddclientViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompEntity.h"
#import "MJRefresh.h"

@interface Business_AddclientViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *refreshHeader;
}
@property (weak, nonatomic) IBOutlet UITextField *textfile;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (weak, nonatomic) IBOutlet UIButton *addContact;

@property (nonatomic, strong) NSMutableArray *arrayContact;
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;

@property (nonatomic, strong) CompEntity *entity;

@property (assign, nonatomic) BOOL power;
- (void)loadData;
- (void)Refresh;

@end
