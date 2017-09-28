//
//  Bussiness_CustomerViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/10.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface Bussiness_CustomerViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *refreshHeader;

}
@property (weak, nonatomic) IBOutlet UITableView *tableViewCustomer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;
@end
