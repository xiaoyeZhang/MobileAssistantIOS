//
//  P_BusinessBaseViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//  省级业务办理列表基类

#import "XYBaseViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "BusinessListModel.h"
#import "StringHelper.h"
#import "XYStartEndDatePicker.h"
//#import "WZLBadgeImport.h"

@interface P_BusinessBaseViewController : XYBaseViewController<UITableViewDataSource,
                                                               UITableViewDelegate,
                                                               XYStartEndDatePickerDelegate>
{
    __weak IBOutlet UIButton *waitBtn;
    __weak IBOutlet UIButton *dateBtn;
    __weak IBOutlet UITableView *_tableView;
    
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    
    NSMutableArray *listMuArr;
}

@property(nonatomic, assign) int currentPage;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
///业务列表类型 1:特号列表 2:预约列表 3:终端列表 4:退库列表 5:维修单列表 6:台账列表 7:办卡列表 8:发票列表 8:营销活动更改
//      9:终端出库列表 10:营销方案更改列表 11:故障处理列表 12:退款列表 13:分合户列表 14:进账查询列表 15:营销方案确认列表
@property(nonatomic, copy) NSString *typeId;

@property(nonatomic, copy) NSString *specialConfigStr; //处理通用人员


//返回
- (void)backBtnClicked:(id)sender;
//添加
- (void)addBtnClicked:(id)sender;
//待办事项点击
- (IBAction)waitBtnClicked:(id)sender;
//时间区间选择
- (IBAction)dateBtnClicked:(id)sender;

- (void)addRefreshView;
- (void)getBusinessListWithPage:(int)page;

@end
