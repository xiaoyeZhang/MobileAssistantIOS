//
//  Order_demandViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Order_demandViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Order_Demand_DetailViewController.h"
#import "Oder_DemandEntity.h"

@interface Order_demandViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    MBProgressHUD *HUD;
    UserEntity *userEntity;

}
@end

@implementation Order_demandViewController

//user_id :1286
- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单需求发起";
    userEntity = [UserEntity sharedInstance];
    self.arrayCustomerTemp = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([userEntity.type_id isEqualToString:@"0"]) {
        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

//添加
- (void)submitBtnClicked:(id)sender
{
    [self.navigationController pushViewController:[[NSClassFromString(@"Order_Demand_SumiltViewController") alloc]init] animated:YES];
    
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
    NSString *order_state;
    
    switch ([entity.state intValue]) {
        case -1:
            order_state = @"已驳回";
            break;
        case 0:
            order_state = @"客户经理已提交";
            break;
        case 1:
            order_state = @"已派发";
            break;
        case 2:
            order_state = @"已处理";
            break;
        case 3:
            order_state = @"已评价";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",entity.company_name,order_state];
    cell.detailTextLabel.text = entity.create_time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Oder_DemandEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    Order_Demand_DetailViewController *vc = [[Order_Demand_DetailViewController alloc]init];
    vc.entity = entity;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData:(NSUInteger)location{
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"order_list",
                           @"user_id":userEntity.user_id,
                           @"location":@(location),
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            if (location == 0) {
                [self.arrayCustomerTemp removeAllObjects];
            }
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Oder_DemandEntity *entity = [[Oder_DemandEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCustomerTemp addObject:entity];
            }
            
            [self.tableView reloadData];

        }
        else
        {
            
//            ALERT_ERR_MSG(entity[@"msg"]);
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
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
