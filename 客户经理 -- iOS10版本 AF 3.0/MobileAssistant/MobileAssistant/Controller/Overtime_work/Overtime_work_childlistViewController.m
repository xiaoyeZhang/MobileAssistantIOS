//
//  Overtime_work_childlistViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/12.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Overtime_work_childlistViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Oder_DemandEntity.h"
#import "M_Order_Demand_DetailViewController.h"

@interface Overtime_work_childlistViewController ()<MBProgressHUDDelegate>
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    
}
@property(assign,nonatomic)NSInteger page;
@end

@implementation Overtime_work_childlistViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _name;
    
    self.page = 0;
    userEntity = [UserEntity sharedInstance];
    self.arrayCustomerTemp = [[NSMutableArray alloc]init];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"数据加载中...";
    [HUD show:YES];
    
    [self getData:_page];
    
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
        weakSelf.page = 0;
        [weakSelf getData:0];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getData:weakSelf.page];
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
    M_Order_Demand_DetailViewController *vc = [[M_Order_Demand_DetailViewController alloc]init];
    vc.order_id = entity.order_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)getData:(NSUInteger)location{
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_order_list_delay",
                           @"user_id":userEntity.user_id,
                           @"location":@(location),
                           @"state":_state,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (location == 0) {
            [self.arrayCustomerTemp removeAllObjects];
        }
        
        if ([strState isEqualToString:@"1"] == YES) {
            
           self.page += 1;
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Oder_DemandEntity *entity = [[Oder_DemandEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCustomerTemp addObject:entity];
            }
            
        }
        else
        {
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
