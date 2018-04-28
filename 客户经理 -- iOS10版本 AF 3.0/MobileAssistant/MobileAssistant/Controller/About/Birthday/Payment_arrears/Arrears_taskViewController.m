//
//  Arrears_taskViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Arrears_taskViewController.h"
#import "MBProgressHUD.h"
#import "Arrears_taskEntity.h"
#import "Arrears_taskTableViewCell.h"
#import "Arrears_DetailViewController.h"
#import "UserEntity.h"

@interface Arrears_taskViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
@property (strong ,nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation Arrears_taskViewController
- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userEntity = [UserEntity sharedInstance];
    
    self.navigationItem.title = @"欠费任务提醒";
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
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
    refreshHeader.scrollView = self.tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        [weakSelf getData:0];
    };
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getData:weakSelf.arrayCutomer.count];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 10, 20)];
    headLabel.font = [UIFont systemFontOfSize:15];
    
    headLabel.text = self.company_name;
    
    [headView addSubview:headLabel];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Arrears_taskTableViewCell";
    Arrears_taskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
    }
    Arrears_taskEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    cell.company_nameLabel.text = entity.company_name;
    
    cell.acc_numLabel.text = [NSString stringWithFormat:@"账号编号：%@",entity.acc_num];
    cell.amountLabel.text = [NSString stringWithFormat:@"当月欠费额：%@",entity.amount];
    cell.timeLabel.text = [NSString stringWithFormat:@"数据日期：%@",entity.time];
    cell.monthLabel.text = [NSString stringWithFormat:@"欠费月份：%@",entity.month];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Arrears_DetailViewController *vc = [[Arrears_DetailViewController alloc]init];
    Arrears_taskEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData:(NSUInteger)page{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
//    [dict setObject:@"get_arrearage_detail_list" forKey:@"method"];
    [dict setObject:@"m_arrearage_acc_list" forKey:@"method"];

    [dict setObject:self.company_num forKey:@"company_num"];
    [dict setObject:userEntity.num forKey:@"user_num"];
    [dict setObject:@(page) forKey:@"local"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
       
        if (page == 0) {
            
            [self.arrayCutomer removeAllObjects];
        
        }
        
//        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Arrears_taskEntity *entity = [[Arrears_taskEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                
            }
            
//        }else{
//            
//            iToast *toast = [iToast makeText:@"暂无数据"];
//            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//            [toast setDuration:500];
//            [toast show:iToastTypeNotice];
//            
//        }
        [self.tableView reloadData];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
    
    
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
