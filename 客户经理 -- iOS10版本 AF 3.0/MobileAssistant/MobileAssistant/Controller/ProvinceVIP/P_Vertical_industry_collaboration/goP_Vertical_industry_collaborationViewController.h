//
//  goP_Vertical_industry_collaborationViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/14.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYStartEndDatePicker.h"
#import "MJRefresh.h"
#import "StringHelper.h"

@interface goP_Vertical_industry_collaborationViewController : XYBaseViewController<XYStartEndDatePickerDelegate>
{
    __weak IBOutlet UIButton *waitBtn;
    __weak IBOutlet UIButton *dateBtn;
    
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@property(nonatomic, assign) int currentPage;
//待办事项点击
- (IBAction)waitBtnClicked:(id)sender;
//时间区间选择
- (IBAction)dateBtnClicked:(id)sender;

@end
