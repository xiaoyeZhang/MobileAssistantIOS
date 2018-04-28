//
//  Postpaid_Create_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/25.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Postpaid_Create_listViewController.h"
#import "MBProgressHUD.h"
#import "Postpaid_ListEntity.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "UserEntity.h"
#import "MJRefresh.h"
#import "Postpaid_DetailViewController.h"
#import "Postpaid_CreateViewController.h"
@interface Postpaid_Create_listViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
}
@property (strong ,nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Postpaid_Create_listViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"后付费审批列表";
    
    userEntity = [UserEntity sharedInstance];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
        
        UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    [self getData:0];
    
    [self addRefreshView];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClicked:(id)sender{
    
    Postpaid_CreateViewController *vc = [[Postpaid_CreateViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.IconImage.hidden = YES;
        
    }
    Postpaid_ListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    cell.CustomerName.text = entity.company_name;
    
    cell.CustomerNum.text = [NSString stringWithFormat:@"时间：%@",entity.create_time];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"后付费周期：%@",entity.cycle];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Postpaid_DetailViewController *vc = [[Postpaid_DetailViewController alloc]init];
    
    Postpaid_ListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData:(NSUInteger)page{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
//   http://sw.avatek.com.cn/gzcms/cmm_boss.php?method=m_postpaid_list&user_id=1208&page=0
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_postpaid_list" forKey:@"method"];
    
    [dict setObject:userEntity.user_id forKey:@"user_id"];
    [dict setObject:@(page) forKey:@"page"];

    [service getNetWorkData:dict  Successed:^(id entity) {
        //        NSNumber *state = [entity valueForKeyPath:@"state"];
        //        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (page == 0) {
            
            [self.arrayCutomer removeAllObjects];
            
        }
        
        NSMutableArray *array = [entity objectForKey:@"content"];
        for (NSDictionary* attributes in array) {
            Postpaid_ListEntity *entity = [[Postpaid_ListEntity alloc] init];
            [entity setValuesForKeysWithDictionary:attributes];
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
