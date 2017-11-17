//
//  Payment_arrears_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "MJRefresh.h"

@interface Payment_arrears_listViewController : XYBaseViewController
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (copy, nonatomic) NSString *user_num;
@end
