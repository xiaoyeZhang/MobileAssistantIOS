//
//  Arrears_task_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/24.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Arrears_task_ListViewController.h"
#import "MBProgressHUD.h"
#import "Arrears_taskEntity.h"
#import "Arrears_taskTableViewCell.h"
#import "UserEntity.h"
#import "MJRefresh.h"
#import "Arrear_task_DeatilViewController.h"

@interface Arrears_task_ListViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
}

@property (strong ,nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation Arrears_task_ListViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"欠费延期任务";

    userEntity = [UserEntity sharedInstance];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
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
    
    Arrear_task_DeatilViewController *vc = [[Arrear_task_DeatilViewController alloc]init];
    
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
    
    [dict setObject:@"m_arrearage_task" forKey:@"method"];
    
    [dict setObject:userEntity.user_id forKey:@"user_id"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        //        NSNumber *state = [entity valueForKeyPath:@"state"];
        //        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (page == 0) {
            
            [self.arrayCutomer removeAllObjects];
            
        }
        
        NSMutableArray *array = [entity objectForKey:@"content"];
        for (NSDictionary* attributes in array) {
            Arrears_taskEntity *entity = [[Arrears_taskEntity alloc] init];
            entity = [entity initWithAttributes:attributes];
            [self.arrayCutomer addObject:entity];
            
        }
        
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
