//
//  Arrears_taskViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface Arrears_taskViewController : XYBaseViewController
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *company_num;
//- (void)getData:(NSUInteger)page;
@end
