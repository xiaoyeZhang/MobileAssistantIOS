//
//  News_ProvinceVip_ListTwoViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/2.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYStartEndDatePicker.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface News_ProvinceVip_ListTwoViewController : XYBaseViewController<XYStartEndDatePickerDelegate>
{
    NSMutableArray *listMuArr;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    
}
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, assign) int currentPage;
///业务列表类型 1:特号列表 2:预约列表 3:终端列表 4:退库列表 5:维修单列表 6:台账列表 7:办卡列表 8:发票列表 8:营销活动更改
//      9:终端出库列表 10:营销方案更改列表 11:故障处理列表 12:退款列表 13:分合户列表 14:进账查询列表 15:营销方案确认列表 16:基础业务受理
@property(nonatomic, copy) NSString *typeId;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *titleName;

@end
