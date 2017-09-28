//
//  Payment_arrears_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface Payment_arrears_listViewController : XYBaseViewController
{
    MJRefreshHeaderView *refreshHeader;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (copy, nonatomic) NSString *user_num;
@end
