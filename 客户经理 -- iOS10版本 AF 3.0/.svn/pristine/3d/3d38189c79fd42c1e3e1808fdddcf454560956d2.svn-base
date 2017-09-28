//
//  BusinessViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 15-1-13.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessImageCollectionReusableView.h"
#import "UIColor+Hex.h"
#import "MJExtension.h"
#import "BusinessModel.h"
#import "ShortcutItemCollectionViewCell.h"
#import "Business_Group_V_NetViewController.h"
#import "BusinessListCollectionViewCell.h"
#import "Bussiness_CustomerViewController.h"
#import "Business_InternationalViewController.h"
#import "Bussiness_productViewController.h"
#import "Business_groupBillViewController.h"
#import "Business_MarkingPlanViewController.h"
#import "Bussiness_StopOpenViewController.h"
#import "Business_BillDetailViewController.h"
#import "Business_Coloring_RingViewController.h"
#import "Business_Group_DirectoruyViewController.h"
#import "White_list_queryViewController.h"
#import "Customer_portraitViewController.h"

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";
static NSString *headerIdentifier = @"BusinessImageCollectionReusableView";

@interface BusinessViewController ()
{
    NSMutableArray *BusinessMuArr;
}
@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"CRM业务办理";
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
    [_collectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerIdentifier];
    
    nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self initDisplayData];
    
    [self select_logmodel:NSStringFromClass([self class])];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"BusinessViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"BusinessViewController"];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initDisplayData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BussinessList" ofType:@"plist"];
    
    BusinessMuArr = [[NSMutableArray alloc] initWithArray:[BusinessModel objectArrayWithFile:filePath]];
    
//    [BusinessMuArr removeLastObject];
    [BusinessMuArr removeLastObject];
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [BusinessMuArr count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessModel *model = BusinessMuArr[indexPath.row];

    BusinessListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    
    cell.titleLable.text = model.title;
    cell.titleLable.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    cell.iconImageView.image = [UIImage imageNamed:model.ImageName];

    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]){
        BusinessImageCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:headerIdentifier
                                                                                      forIndexPath:indexPath];
        
        return view;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {

            [self goGroup_V_NetViewController:nil];
            break;
        }
        case 1:
        {

            [self goColoring_RingViewController:nil];

            break;
        }
        case 2:
        {

            [self goGroup_DirectoruyViewController:nil];

         break;
        }
        case 3:
        {
            [self goInternationalViewController:@"1"];
            
            break;
        }
        case 4:
        {
            [self goCustomerViewController:nil];
            break;
        }
        case 5:
        {
            [self goProductViewController:nil];
            break;
        }
        case 6:
        {
            [self goGroupBillViewController:nil];
            break;
        }
        case 7:
        {
            [self goInternationalViewController:@"2"];
            break;
        }
        case 8:
        {
            [self SMS_Btn:nil];
            break;
        }
        case 9:
        {
            [self goCustomer_portraitViewController:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 8)/3, (collectionView.bounds.size.height-4*4-135)/3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(collectionView.bounds.size.width, 135);
}

#pragma mark -国际漫游
- (void)goInternationalViewController:(id)sender
{
    Business_InternationalViewController *vc = [[Business_InternationalViewController alloc] init];
    vc.num = [sender intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -新增成员
- (void)goCustomerViewController:(id)sender
{
    Bussiness_CustomerViewController *vc = [[Bussiness_CustomerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -产品查询退订
- (void)goProductViewController:(id)sender
{
    Bussiness_productViewController *vc = [[Bussiness_productViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -集团账单
- (void)goGroupBillViewController:(id)sender
{
    Business_groupBillViewController *vc = [[Business_groupBillViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -营销活动
- (void)goMarkingPlanViewController:(id)sender
{
    Business_MarkingPlanViewController *vc = [[Business_MarkingPlanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -停开机
- (void)goStopOpenViewController:(id)sender
{
    Bussiness_StopOpenViewController *vc = [[Bussiness_StopOpenViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -集团V网
- (void)goGroup_V_NetViewController:(id)sender
{
    Business_Group_V_NetViewController *vc = [[Business_Group_V_NetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -彩铃
- (void)goColoring_RingViewController:(id)sender
{
    Business_Coloring_RingViewController *vc = [[Business_Coloring_RingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -集团号簿
- (void)goGroup_DirectoruyViewController:(id)sender
{
    Business_Group_DirectoruyViewController *vc = [[Business_Group_DirectoruyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -营销白名单查询
- (void)SMS_Btn:(UIButton *)sender {
    
    White_list_queryViewController *vc = [[White_list_queryViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -用户画像
- (void)goCustomer_portraitViewController:(UIButton *)sender {
    
    Customer_portraitViewController *vc = [[Customer_portraitViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end





