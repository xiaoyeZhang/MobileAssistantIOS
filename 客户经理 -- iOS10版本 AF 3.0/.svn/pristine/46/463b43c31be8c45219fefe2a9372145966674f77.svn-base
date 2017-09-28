//
//  daily_managementViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/26.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "daily_managementViewController.h"
#import "UIColor+Hex.h"
#import "BusinessListCollectionViewCell.h"
#import "P_TerminalListViewController.h"
#import "P_StockListViewController.h"
#import "P_TerminalStockListViewController.h"
#import "P_RepairListViewController.h"
#import "P_CardListViewController.h"
#import "P_AppointListViewController.h"
#import "P_SpecialListViewController.h"
#import "P_BookListViewController.h"
#import "P_MarketingPlanViewController.h"
#import "P_BillListViewController.h"
#import "TaskCreateViewController.h"
#import "TaskListViewController.h"

@interface daily_managementViewController ()
{
    NSArray *BusinessArr;
}
@end

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";

@implementation daily_managementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"日常管理";
    
    [self initData];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground-3"] forBarMetrics:UIBarMetricsDefault];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData{
    
//    BusinessArr = @[@{@"title":@"终端订货"},
//                    @{@"title":@"终端退库"},
//                    @{@"title":@"终端出库"},
//                    @{@"title":@"终端售后维修"},
//                    @{@"title":@"办卡"},
//                    @{@"title":@"公司领导预约拜访"},
//                    @{@"title":@"客户画像信息推送"},
//                    @{@"title":@"分合户"},
//                    @{@"title":@"特号办理"},
//                    @{@"title":@"纵向行业任务协同"},
//                    @{@"title":@"台账登记"},
//                    @{@"title":@"长期未拜访客户信息推送"},
//                    @{@"title":@"首席客户代表走访"},
//                    @{@"title":@"制定拜访任务"},
//                    @{@"title":@"走访任务列表"},
//                    @{@"title":@"营销方案更改"},
//                    @{@"title":@"开具发票"},
//                    ];

    BusinessArr = @[@{@"title":@"终端订货"},
                    @{@"title":@"终端退库"},
                    @{@"title":@"终端出库"},
                    @{@"title":@"终端售后维修"},
                    @{@"title":@"办卡"},
                    @{@"title":@"公司领导预约拜访"},
                    @{@"title":@"特号办理"},
                    @{@"title":@"台账登记"},
                    @{@"title":@"制定拜访任务"},
                    @{@"title":@"走访任务列表"},
                    @{@"title":@"开具发票"},
                    ];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return BusinessArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    cell.titleLable.text = [BusinessArr[indexPath.row] objectForKey:@"title"];
    cell.titleLable.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    cell.iconImageView.image = [UIImage imageNamed:[BusinessArr[indexPath.row] objectForKey:@"title"]];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self goTerminalViewController];
            break;
        case 1:
            [self goStockViewController];
            break;
        case 2:
            [self goTerminalStockViewController];
            break;
        case 3:
            [self goRepairViewController];
            break;
        case 4:
            [self goCardViewController];
            break;
        case 5:
            [self goAPPointViewController];
            break;
        case 6:
//            ALERT_ERR_MSG(@"开发中");
            [self goSpecialViewController];
            break;
        case 7:
//            ALERT_ERR_MSG(@"开发中");
            [self goBookViewController];
            break;
        case 8:
//            [self goSpecialViewController];
            [self doCreateTask];
            break;
        case 9:
//            ALERT_ERR_MSG(@"开发中");
             [self doTaskList];
            
            break;
        case 10:
//            [self goBookViewController];
//            [self goMarketingPlanViewController];
            [self goBillViewController];
            break;
        case 11:
//            ALERT_ERR_MSG(@"开发中");
            break;
        case 12:
//            ALERT_ERR_MSG(@"开发中");
            break;
        case 13:
//            [self doCreateTask];
            break;
        case 14:
//            [self doTaskList];
            break;
        case 15:
//            [self goMarketingPlanViewController];
            break;
        case 16:
//            [self goBillViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 8)/3, (collectionView.bounds.size.height-4*4-135)/3);
}
#pragma mark -  终端订货
- (void)goTerminalViewController
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
//        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
//        return;
//    }
    
    P_TerminalListViewController *vc = [[P_TerminalListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
//    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 退库列表
- (void)goStockViewController
{
    P_StockListViewController *vc = [[P_StockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 终端出库
- (void)goTerminalStockViewController
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
//        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
//        return;
//    }
    
    P_TerminalStockListViewController *vc = [[P_TerminalStockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
//    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 终端售后维修
- (void)goRepairViewController
{
    P_RepairListViewController *vc = [[P_RepairListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 办卡列表
- (void)goCardViewController
{
    P_CardListViewController *vc = [[P_CardListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -预约列表
- (void)goAPPointViewController
{
    P_AppointListViewController *vc = [[P_AppointListViewController alloc]  initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 特号列表
- (void)goSpecialViewController
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
//        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
//        return;
//    }
    
    P_SpecialListViewController *vc = [[P_SpecialListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
//    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 台账列表
- (void)goBookViewController
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
//        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
//        return;
//    }
    
    P_BookListViewController *vc = [[P_BookListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
//    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -制定拜访任务
- (void)doCreateTask
{
    TaskCreateViewController *vc = [[TaskCreateViewController alloc]init];
    vc.fromCoustomer = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -走访任务列表
- (void)doTaskList
{
    TaskListViewController *vc = [[TaskListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -营销方案
- (void)goMarketingPlanViewController
{
    P_MarketingPlanViewController *vc = [[P_MarketingPlanViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 发票列表
- (void)goBillViewController
{
    P_BillListViewController *vc = [[P_BillListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
