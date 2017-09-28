//
//  Product_VisitListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_VisitListViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "Product_VisitListEntity.h"
#import "Product_Visit_SumbitViewController.h"
#import "Product_Visit_DetailViewController.h"
#import "Bussiness_CustomerTableViewCell.h"

@interface Product_VisitListViewController ()<MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    MBProgressHUD *HUD;
}
@end

@implementation Product_VisitListViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"产品经理走访";
    
    userEntity = [UserEntity sharedInstance];
    
    self.arrayCustomerTemp = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([userEntity.type_id intValue]== ROLE_PRODUCT) {
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
    Product_Visit_SumbitViewController *vc = [[Product_Visit_SumbitViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.numberOfLines = 0;
//        cell.detailTextLabel.numberOfLines = 0;
        cell.IconImage.alpha = 0;
    }
    
    Product_VisitListEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    NSString *stateStr ;
    
    switch ([entity.state intValue]) {
        case 0:
            stateStr = @"待执行";
            break;
        case 1:
            stateStr = @"待填写纪要";
            break;
        case 2:
            stateStr = @"任务完成";
            break;
        default:
            break;
    }
    
    cell.CustomerName.text = [NSString stringWithFormat:@"%@(%@)",entity.company_name,stateStr];
    cell.CustomerNum.text = [NSString stringWithFormat:@"执行人：%@",entity.user_name];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"创建时间：%@",entity.create_time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Product_VisitListEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];

    Product_Visit_DetailViewController *vc = [[Product_Visit_DetailViewController alloc]init];
    
    vc.entity = entity;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData:(NSUInteger)location{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"product_visit_list",
                           @"local":@(location),
                           @"user_id":userEntity.user_id,
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
                Product_VisitListEntity *entity = [[Product_VisitListEntity alloc] init];
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
