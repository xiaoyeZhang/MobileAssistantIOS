//
//  Site_serviceViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/26.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Site_serviceViewController.h"
#import "UIColor+Hex.h"
#import "BusinessListCollectionViewCell.h"
#import "Business_Group_V_NetViewController.h"
#import "Business_Coloring_RingViewController.h"
#import "Business_Group_DirectoruyViewController.h"
#import "Business_InternationalViewController.h"
#import "Bussiness_CustomerViewController.h"
#import "Bussiness_productViewController.h"
#import "Business_groupBillViewController.h"
#import "Payment_arrears_listViewController.h"
#import "Contract_expiresViewController.h"
#import "Birthday_listViewController.h"

@interface Site_serviceViewController ()
{
    NSArray *BusinessArr;
}
@end

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";

@implementation Site_serviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"现场服务";
    [self initData];
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground-2"] forBarMetrics:UIBarMetricsDefault];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData{
    
//    BusinessArr = @[ @{@"title":@"集团彩铃"},
//                     @{@"title":@"集团V网"},
//                     @{@"title":@"集团号簿"},
//                     @{@"title":@"国际漫游"},
//                     @{@"title":@"现场开补卡"},
//                     @{@"title":@"成员管理"},
//                     @{@"title":@"业务订购"},
//                     @{@"title":@"产品查询退订"},
//                     @{@"title":@"刷卡付款"},
//                     @{@"title":@"集团账单"},
//                     @{@"title":@"欠费催缴任务推送"},
//                     @{@"title":@"合同到期提醒推送"},
//                     @{@"title":@"集团关键人联系人生日提醒"},
//                    ];
    BusinessArr = @[ @{@"title":@"集团彩铃"},
                     @{@"title":@"集团V网"},
                     @{@"title":@"集团号簿"},
                     @{@"title":@"国际漫游"},
                     @{@"title":@"成员管理"},
                     @{@"title":@"产品查询退订"},
                     @{@"title":@"集团账单"},
                     @{@"title":@"欠费催缴任务推送"},
                     @{@"title":@"合同到期提醒推送"},
                     @{@"title":@"集团关键人联系人生日提醒"},
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
            [self goColoring_Ring];
            break;
        case 1:
            [self goGroup_V_Net];
            break;
        case 2:
            [self goGroup_Directoruy];
            break;
        case 3:
            [self goInternational];
            break;
        case 4:
//            ALERT_ERR_MSG(@"开发中");
            [self goCustomer];
            break;
        case 5:
//            [self goCustomer];
            [self goproduct];
            break;
        case 6:
//            ALERT_ERR_MSG(@"开发中");
            [self gogroupBill];
            break;
        case 7:
//            [self goproduct];
            [self Payment_arrearsBtnClicked];
            break;
        case 8:
//            ALERT_ERR_MSG(@"开发中");
            [self Contract_expiresBtnClicked];
            break;
        case 9:
//            [self gogroupBill];
             [self goStock];
            break;
        case 10:
//            [self Payment_arrearsBtnClicked];
            break;
        case 11:
//            [self Contract_expiresBtnClicked];
            break;
        case 12:
//            [self goStock];
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

#pragma mark -集团彩铃
- (void)goColoring_Ring{
    Business_Coloring_RingViewController *vc = [[Business_Coloring_RingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -集团V网
- (void)goGroup_V_Net{
    Business_Group_V_NetViewController *vc = [[Business_Group_V_NetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -集团号簿
- (void)goGroup_Directoruy{
    Business_Group_DirectoruyViewController *vc = [[Business_Group_DirectoruyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -国际漫游
- (void)goInternational{
    Business_InternationalViewController *vc = [[Business_InternationalViewController alloc] init];
    vc.num = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -成员管理
- (void)goCustomer{
    Bussiness_CustomerViewController *vc = [[Bussiness_CustomerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 产品查询退订
- (void)goproduct{
    
    Bussiness_productViewController *vc = [[Bussiness_productViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 集团账单
- (void)gogroupBill{
    
    Business_groupBillViewController *vc = [[Business_groupBillViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 欠费缴费提醒
- (void)Payment_arrearsBtnClicked{
    
    Payment_arrears_listViewController *vc = [[Payment_arrears_listViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 合同到期
- (void)Contract_expiresBtnClicked{
    Contract_expiresViewController *vc = [[Contract_expiresViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -集团生日提醒
- (void)goStock{
    
    Birthday_listViewController *vc = [[Birthday_listViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
