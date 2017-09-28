//
//  MainBaseViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "MainBaseViewController.h"
#import "ImageCollectionReusableView.h"
#import "UIColor+Hex.h"
#import "BusinessListCollectionViewCell.h"
#import "UserEntity.h"
#import "CustomerViewController.h"

@interface MainBaseViewController ()
{
    NSMutableArray *BusinessArr;
}
@end

static NSString *headerIdentifier = @"ImageCollectionReusableView";
static NSString *cellIdentifier = @"BusinessListCollectionViewCell";

@implementation MainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    BusinessArr = [NSMutableArray array];
    
    [self initData];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];

}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    if ([self.name isEqualToString:@"走访任务系统"]) {
        
        
        [BusinessArr addObject:@{@"title":@"制定走访任务",@"icon":@"制定走访任务",@"viewController":[userEntity.is_first isEqual:@"1"]?@"Task_Two_CreateViewController":@"TaskCreateViewController"}];  //  首席看管
        
//        [BusinessArr addObject:@{@"title":@"制定走访任务",@"icon":@"制定走访任务",@"viewController":@"TaskCreateViewController"}];
        
        [BusinessArr addObject:@{@"title":@"走访任务列表",@"icon":@"走访任务列表",@"viewController":@"TaskListViewController"}];
//        [BusinessArr addObject:@{@"title":@"走访轨迹",@"icon":@"走访轨迹",@"viewController":@"TrackViewController"}];
        [BusinessArr addObject:@{@"title":@"长期未拜访",@"icon":@"长期未拜访",@"viewController":@"No_visit_baselistViewController"}];
        
        if ([userEntity.type_id intValue] == ROLE_CUSTOMER || [userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE ){
        
            [BusinessArr addObject:@{@"title":@"实时定位查看",@"icon":@"定位1",@"viewController":@"LocationViewViewController"}];
            
            [BusinessArr addObject:@{@"title":@"实时信息查看",@"icon":@"查看",@"viewController":@"InformationViewViewController"}];
        }

        if ([userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE || [userEntity.type_id intValue] == ROLE_PRODUCT){
            
            [BusinessArr addObject:@{@"title":@"产品经理走访",@"icon":@"bm_directory",@"viewController":@"Product_VisitListViewController"}];
            
        }

    }else if ([self.name isEqualToString:@"订单中心"]){
        
        UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
        [_collectionView registerNib:nib
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerIdentifier];
        
        [BusinessArr addObject:@{@"title":@"业务联系人",@"icon":@"p_special3",@"viewController":@"Business_contacts_ListViewController"}];
        
        if ([userEntity.type_id intValue] != ROLE_SOCOALCHANNEL) {
            
            if ([userEntity.type_id intValue]== ROLE_CUSTOMER || [userEntity.type_id intValue]== ROLE_THREE) {
                
                [BusinessArr addObject:@{@"title":@"订单需求发起",@"icon":@"p_book3",@"viewController":@"CustomerViewController"}];
            }
            
            [BusinessArr addObject:@{@"title":@"我的订单",@"icon":@"p_terminal3",@"viewController":@"M_Order_demandViewController"}];
            [BusinessArr addObject:@{@"title":@"故障投诉",@"icon":@"p_stock3",@"viewController":@"Trouble_callListViewController"}];
            [BusinessArr addObject:@{@"title":@"业务变更",@"icon":@"p_marking",@"viewController":@"Business_change_listViewController"}];
        }
        
        if ([userEntity.type_id intValue] != ROLE_CUSTOMER) {
            
            if ([userEntity.type_id intValue] == ROLE_SOCOALCHANNEL) {
                [BusinessArr addObject:@{@"title":@"SA专用发起",@"icon":@"p_book3",@"viewController":@"SA_ListViewController"}];
            }

            [BusinessArr addObject:@{@"title":@"我的SA工单",@"icon":@"分合户",@"viewController":@"SA_SpecialViewController"}];
        }

        
    }else if ([self.name isEqualToString:@"其他资料库"]){
        
        [BusinessArr addObject:@{@"title":@"祝福短信库",@"icon":@"祝福短信库-1",@"viewController":@"SMS_MessageViewController"}];
        [BusinessArr addObject:@{@"title":@"产品资料库",@"icon":@"产品资料库-1",@"viewController":@"Product_imformationViewController"}];
        [BusinessArr addObject:@{@"title":@"案例库",@"icon":@"案例库-1",@"viewController":@"CaseViewController"}];
        [BusinessArr addObject:@{@"title":@"营销活动信息库",@"icon":@"营销活动方案库-1",@"viewController":@"Markeing_classificationViewController"}];
        
//        if ([userEntity.type_id isEqualToString:@"0"] || [userEntity.user_id isEqualToString:@"1286"]) {
//        [BusinessArr addObject:@{@"title":@"订单需求发起",@"icon":@"bm_order",@"viewController":@"Order_demandViewController"}];
//        [BusinessArr addObject:@{@"title":@"新订单需求发起",@"icon":@"bm_order",@"viewController":@"M_Order_demandViewController"}];
//        }
        [BusinessArr addObject:@{@"title":@"营销中心",@"icon":@"产品中心",@"viewController":@"Marketing_CenterListViewController"}];

        [BusinessArr addObject:@{@"title":@"集中化管理",@"icon":@"bm_addclient-1",@"viewController":@"Focus_ListViewController"}];
        
    }else if ([self.name isEqualToString:@"考试系统"]){
        
        [BusinessArr addObject:@{@"title":@"考试",@"icon":@"考试-(1)",@"viewController":@"Examination_SeconViewController"}];
        [BusinessArr addObject:@{@"title":@"历史试卷",@"icon":@"高分试卷",@"viewController":@"Exam_historylistViewController"}];
        [BusinessArr addObject:@{@"title":@"积分排名",@"icon":@"排行",@"viewController":@"Integral_rankingViewController"}];
//        [BusinessArr addObject:@{@"title":@"规则说明",@"icon":@"说明",@"viewController":@"Rule_descriptionViewController"}];
        if ([userEntity.type_id intValue]== ROLE_CUSTOMER || [userEntity.type_id intValue]== ROLE_PRODUCT) {
            
            [BusinessArr addObject:@{@"title":@"自测",@"icon":@"考试-(1)",@"viewController":@"Exam_self_testingViewController"}];
        }
        
        
    }
   
    
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
    cell.iconImageView.image = [UIImage imageNamed:[BusinessArr[indexPath.row] objectForKey:@"icon"]];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.name isEqualToString:@"订单中心"]){
        if ([kind isEqual:UICollectionElementKindSectionHeader]){
            ImageCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                   withReuseIdentifier:headerIdentifier
                                                                                          forIndexPath:indexPath];
            
            return view;
        }
        
        return nil;
    }else{
        
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    
    if ([[[BusinessArr objectAtIndex:indexPath.row] objectForKey:@"viewController"] isEqualToString:@"CustomerViewController"]) {
        
        CustomerViewController *vc = [[CustomerViewController alloc]init];
        
        vc.enter_type = 7;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        UIViewController* viewController = [[NSClassFromString([[BusinessArr objectAtIndex:indexPath.row] objectForKey:@"viewController"]) alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 4)/3, (collectionView.bounds.size.height-4*4-135)/3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([self.name isEqualToString:@"订单中心"]){
        
        return CGSizeMake(collectionView.bounds.size.width, 135);

    }else{
        return CGSizeMake(collectionView.bounds.size.width, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
