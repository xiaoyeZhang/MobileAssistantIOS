//
//  Special_line_platformViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/7.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Special_line_platformViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "XYStartEndDatePicker.h"
#import "Utilies.h"
#import "Oder_DemandEntity.h"
#import "Special_line_platformDetailViewController.h"

@interface Special_line_platformViewController ()<MBProgressHUDDelegate,XYStartEndDatePickerDelegate>
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;

@end

@implementation Special_line_platformViewController


- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"专线平台工单";
    userEntity = [UserEntity sharedInstance];
    self.arrayCustomerTemp = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    self.start_time = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.end_time = [dateFormatter stringFromDate:[NSDate date]];;
    
    [_dateBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time]
              forState:UIControlStateNormal];
    
    [self getData:0];
    
    [self addRefreshView];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf getData:0];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getData:weakSelf.arrayCustomerTemp.count];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    Oder_DemandEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",entity.company_name,entity.state_name];
    cell.detailTextLabel.text = entity.create_time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Oder_DemandEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    Special_line_platformDetailViewController *vc = [[Special_line_platformDetailViewController alloc]init];
    vc.order_id = entity.order_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData:(NSUInteger)location{
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_order_list",
                           @"type":@"4",
                           @"user_id":userEntity.user_id,
                           @"location":@(location),
                           @"state":@"0",
                           @"start_time":self.start_time?self.start_time:@"",
                           @"end_time":self.end_time?self.end_time:@"",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (location == 0) {
            [self.arrayCustomerTemp removeAllObjects];
        }
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Oder_DemandEntity *entity = [[Oder_DemandEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCustomerTemp addObject:entity];
            }
            
        }
        else
        {
            
            //            ALERT_ERR_MSG(entity[@"msg"]);
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
        
    }];
    
}

- (IBAction)dateBtnClicked:(UIButton *)sender {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.start_time];
    NSDate *endDate = [dateFormatter dateFromString:self.end_time];
    
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
    
    self.start_time = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.end_time = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time];
    [_dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    [self getData:0];
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    
    [self getData:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
