//
//  News_ProviceVIP_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_ProviceVIP_ListViewController.h"
#import "CommonService.h"
#import "MJRefresh.h"
#import "Utilies.h"
#import "XYStartEndDatePicker.h"
#import "News_ProvinceVIP_DetailEntity.h"
#import "News_ProviceVIP_DetailViewController.h"
#import "MBProgressHUD.h"
#import "News_ProviceVIP_SubmitViewController.h"

@interface News_ProviceVIP_ListViewController ()<XYStartEndDatePickerDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    UITableViewCell *cell;
}

@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation News_ProviceVIP_ListViewController

- (void)dealloc{
    
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = self.name;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addRefreshView];

    self.start_time = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.end_time = [dateFormatter stringFromDate:[NSDate date]];;
    
    [_dateBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time]
             forState:UIControlStateNormal];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getDatePage:0];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
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
        weakSelf.currentPage = 0;
        [weakSelf getDatePage:0];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        [weakSelf getDatePage:[weakSelf.arrayCutomer count]];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCutomer count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.numberOfLines = 0;

    }
    
    News_ProvinceVIP_DetailEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    if ([entity.todo_flag isEqualToString:@"1"]) {
        cell.badgeCenterOffset = CGPointMake(-40,10);
        [cell showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeNone];
    }else{
        [cell clearBadge];
    }
    
    
    NSString *title = [NSString stringWithFormat:@"%@(%@)",entity.title,entity.state_name];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = entity.create_time;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    News_ProviceVIP_DetailViewController *vc = [[News_ProviceVIP_DetailViewController alloc]init];
    News_ProvinceVIP_DetailEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];

    vc.business_id = entity.business_id;
    vc.name = self.name;
    vc.state_name = entity.state_name;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)getDatePage:(int)page{
    
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic = @{
                         @"method":@"m_business_list",
                         @"user_id":userEntity.user_id,
                         @"module_id":self.module_id,
                         @"unfinish":_waitBtn.selected?@"1":@"0",
                         @"page":@(page),
                         @"start_time":self.start_time?self.start_time:@"",
                         @"end_time":self.end_time?self.end_time:@"",
                         };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"]) {
            iToast *toast;
            if (page == 0) {
                
                [self.arrayCutomer removeAllObjects];
                [self.tableView reloadData];
                toast = [iToast makeText:@"暂无数据"];
            }else{
                
                toast = [iToast makeText:@"没有更多数据"];
            }
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:500];
            [toast show:iToastTypeNotice];
            
        }else{
            
            if (page == 0) {
                [self.arrayCutomer removeAllObjects];
            }
            
            NSMutableArray *array = [entity objectForKey:@"content"];            
            for (NSDictionary* attributes in array) {
                News_ProvinceVIP_DetailEntity *entity = [[News_ProvinceVIP_DetailEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            }
            
            [self.tableView reloadData];
            
        }
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)waitBtnClicked:(UIButton *)sender {
    _waitBtn.selected = !_waitBtn.selected;
    
    self.currentPage = 0;
    [self getDatePage:self.currentPage];
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
    
    self.currentPage = 0;
    [self getDatePage:self.currentPage];
}

- (void)addBtnClicked:(id)sender
{
    News_ProviceVIP_SubmitViewController *vc = [[News_ProviceVIP_SubmitViewController alloc]init];
    
    vc.module_id = self.module_id;
    vc.name = self.name;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [self getDatePage:0];
}

@end
