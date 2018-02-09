//
//  News_ProvinceVip_ListTwoViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/2.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "News_ProvinceVip_ListTwoViewController.h"
#import "News_BusinessListModel.h"
#import "Utilies.h"

#import "P_SpecialSubmitViewController.h"
#import "P_TerminalSubmitViewController.h"
#import "P_StockSubmitViewController.h"
#import "P_TerminalStockLViewController.h"
#import "P_BookSubmitViewController.h"
#import "P_BillSubmitViewController.h"
#import "P_Marketing_PlanSubmitViewController.h"
#import "Basic_business_moduleSubmitViewController.h"
#import "News_ProvinceVip_Detail_TwoViewController.h"

@interface News_ProvinceVip_ListTwoViewController ()
{
    BOOL isDone;
}
@end

@implementation News_ProvinceVip_ListTwoViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleName;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    isDone = NO;

    self.startTime = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
    
    [self.dateBtn setTitle:[NSString stringWithFormat:@"  ~ %@",self.endTime]
             forState:UIControlStateNormal];
    
    listMuArr = [[NSMutableArray alloc] init];
    
    [self addRefreshView];

    [self getBusinessListWithPage:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.currentPage = 0;
        [weakSelf getBusinessListWithPage:weakSelf.currentPage];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getBusinessListWithPage:[listMuArr count]];
    };
}

//添加
- (void)addBtnClicked:(id)sender
{
    if ([self.typeId isEqualToString:@"1"]) {
        
        P_SpecialSubmitViewController *vc = [[P_SpecialSubmitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"3"]){
        
        P_TerminalSubmitViewController *vc = [[P_TerminalSubmitViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"4"]){
        
        P_StockSubmitViewController *vc = [[P_StockSubmitViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.typeId isEqualToString:@"9"]){

        P_TerminalStockLViewController *vc = [[P_TerminalStockLViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"6"]){
        
        P_BookSubmitViewController *vc = [[P_BookSubmitViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.typeId isEqualToString:@"8"]){
        
        P_BillSubmitViewController *vc = [[P_BillSubmitViewController alloc]init];

        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.typeId isEqualToString:@"15"]){
        
        P_Marketing_PlanSubmitViewController *vc = [[P_Marketing_PlanSubmitViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.typeId isEqualToString:@"16"]){
        Basic_business_moduleSubmitViewController *vc = [[Basic_business_moduleSubmitViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }

}

- (IBAction)waitBtnClicked:(UIButton *)sender {
    
    self.waitBtn.selected = !self.waitBtn.selected;
    
    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}

- (IBAction)dateBtnClicked:(UIButton *)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.startTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.date = startDate;
    picker.endDatePicker.date = endDate;
    picker.delegate = self;
    [picker show];
    
}

#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.startTime = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.endTime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime];
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    isDone = YES;
    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listMuArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    News_BusinessListModel *model = listMuArr[indexPath.row];

    if ([model.todo_flag isEqualToString:@"1"]) {
        cell.badgeCenterOffset = CGPointMake(-15,20);
        [cell showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeNone];
    }else{
        [cell clearBadge];
    }
    
    NSArray *arr = [model.title componentsSeparatedByString:@","];
    
    if (arr.count == 2) {
        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],model.state_name];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@",model.create_time,arr[1]]];
        
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(19, 84, 142, 1) range:NSMakeRange(model.create_time.length, str.length - model.create_time.length)];
        
        
        cell.textLabel.text = title;
        cell.detailTextLabel.attributedText = str;
    }else if (arr.count == 3) {
        
        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],model.state_name];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@  %@",model.create_time,arr[1],arr[2]]];
        
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(19, 84, 142, 1) range:NSMakeRange(model.create_time.length, str.length - model.create_time.length)];
        
        
        cell.textLabel.text = title;
        cell.detailTextLabel.attributedText = str;
    }else{
        
        NSString *title = [NSString stringWithFormat:@"%@(%@)",model.title,model.state_name];
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = model.create_time;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    News_BusinessListModel *model = listMuArr[indexPath.row];
    
    News_ProvinceVip_Detail_TwoViewController *vc = [[News_ProvinceVip_Detail_TwoViewController alloc]init];
    
    vc.business_id = model.business_id;
    
    vc.titleName = self.titleName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getBusinessListWithPage:(int)page{
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"new_getbusiness_list",
                           @"dep_id":userInfo.dep_id,
                           @"user_type":userInfo.type_id,
                           @"unfinish":self.waitBtn.selected?@"0":@"1",
                           @"page":@(page),
                           @"model_id":self.typeId,
                           @"start_time":isDone?self.startTime:@"",
                           @"end_time":isDone?self.endTime:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            id content = entity[@"content"];
            NSArray *arr = [News_BusinessListModel objectArrayWithKeyValuesArray:content];
            
            if (page == 0) {
                [listMuArr removeAllObjects];
                [listMuArr addObjectsFromArray:arr];
                
                [_tableView reloadData];
            }else{
                [listMuArr addObjectsFromArray:arr];
                
                NSInteger rows = [_tableView numberOfRowsInSection:0];
                NSInteger insertRows = [arr count];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = rows; i < rows+insertRows; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                
                //插入数据
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [_tableView endUpdates];
            }
            
        }else{
            if (_waitBtn.selected) {
                [listMuArr removeAllObjects];
                
                [_tableView reloadData];
            }
        }
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    }];
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    
    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
