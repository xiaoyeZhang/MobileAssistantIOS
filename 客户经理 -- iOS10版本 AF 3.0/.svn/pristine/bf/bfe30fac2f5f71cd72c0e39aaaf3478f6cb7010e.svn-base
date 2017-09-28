//
//  Sales_supportViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/26.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Sales_supportViewController.h"
#import "UIColor+Hex.h"
#import "BusinessListCollectionViewCell.h"
#import "SMS_MessageViewController.h"
#import "Business_MarkingPlanViewController.h"
#import "P_MarketingPlanViewController.h"

@interface Sales_supportViewController ()
{
    NSArray *BusinessArr;
}
@end

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";
@implementation Sales_supportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"销售支持";
    
    [self initData];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground-1"] forBarMetrics:UIBarMetricsDefault];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData{
    
//    BusinessArr = @[@{@"title":@"营销活动方案库"},
//                    @{@"title":@"祝福短信库"},
//                    @{@"title":@"营销活动"},
//                    @{@"title":@"案例库"},
//                    @{@"title":@"营销活动查询"},
//                    ];
    BusinessArr = @[
                    @{@"title":@"祝福短信库"},
                    @{@"title":@"营销活动查询"},
                    @{@"title":@"营销方案更改"}
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
//            ALERT_ERR_MSG(@"开发中");
            [self SMS_Btn];
            break;
        case 1:
//            [self SMS_Btn];
            [self goBill];
            break;
        case 2:
//            ALERT_ERR_MSG(@"开发中");
            [self goMarketingPlan];
            break;
        case 3:
            ALERT_ERR_MSG(@"开发中");
            break;
        case 4:
            [self goBill];
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
#pragma mark -祝福短信库
- (void)SMS_Btn{
    
    SMS_MessageViewController *vc = [[SMS_MessageViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 营销活动查询
- (void)goBill{
    Business_MarkingPlanViewController *vc = [[Business_MarkingPlanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 营销方案更改
- (void)goMarketingPlan{
    P_MarketingPlanViewController *vc = [[P_MarketingPlanViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
