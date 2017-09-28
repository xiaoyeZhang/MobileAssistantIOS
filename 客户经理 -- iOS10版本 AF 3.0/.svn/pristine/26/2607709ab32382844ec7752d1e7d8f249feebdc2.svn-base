//
//  Bussiness_ListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupOrderModel.h"
#import "CompEntity.h"
#import "MJRefresh.h"

@interface Bussiness_ListViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *refreshHeader;
}

@property (weak, nonatomic) IBOutlet UILabel *CononentNum;
@property (weak, nonatomic) IBOutlet UILabel *CononentName;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;

@property (nonatomic, strong) CompEntity *entity;

@end
