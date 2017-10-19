//
//  Centralized_managementViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/10/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Centralized_managementViewController.h"
#import "UserEntity.h"
#import "Central_manageCollectionViewCell.h"

static NSString *cellIdentifier = @"Central_manageCollectionViewCell";

@interface Centralized_managementViewController ()
{
    NSArray *MainBusinessArr;
    UserEntity *userEntity;
}
@end

@implementation Centralized_managementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"集中化管理";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
 
    userEntity = [UserEntity sharedInstance];
    
    if ([userEntity.type_id intValue]== ROLE_CUSTOMER || [userEntity.type_id intValue]== ROLE_PRODUCT) {
        
        MainBusinessArr = @[@{@"section":@"0",@"list":
                                  @[@{@"title":@"欠费提醒",@"icon":@"欠费-icon",@"viewController":@"Payment_arrears_listViewController",@"VCbool":@"1"},
                                    @{@"title":@"合同到期提醒",@"icon":@"合同",@"viewController":@"Contract_expiresViewController",@"VCbool":@"10"},
                                    @{@"title":@"客户生日提醒",@"icon":@"生日",@"viewController":@"Birthday_listViewController",@"VCbool":@"1"},
                                    @{@"title":@"长期未拜访",@"icon":@"拜访记录",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"}]},
                            @{@"section":@"1",@"list":
                                  @[@{@"title":@"资料库",@"icon":@"资料2",@"viewController":@"Product_imformationViewController",@"VCbool":@"1"},
                                    @{@"title":@"祝福短信库",@"icon":@"短信",@"viewController":@"SMS_MessageViewController",@"VCbool":@"1"},
                                    @{@"title":@"案例库",@"icon":@"案例",@"viewController":@"CaseViewController",@"VCbool":@"1"},
                                    @{@"title":@"营销活动信息库",@"icon":@"营销",@"viewController":@"Markeing_classificationViewController",@"VCbool":@"1"}]},
                            @{@"section":@"2",@"list":
                                  @[@{@"title":@"在线考试",@"icon":@"在线考试-(1)",@"viewController":@"Examination_SeconViewController",@"VCbool":@"1"},
                                    @{@"title":@"历史试卷",@"icon":@"试卷",@"viewController":@"Exam_historylistViewController",@"VCbool":@"1"},
                                    @{@"title":@"自测",@"icon":@"考试",@"viewController":@"Exam_self_testingViewController",@"VCbool":@"1"},
                                    @{@"title":@"积分排行",@"icon":@"积分",@"viewController":@"Integral_rankingViewController",@"VCbool":@"1"}]},
                            ];
    }else{
        MainBusinessArr = @[@{@"section":@"0",@"list":
                                  @[@{@"title":@"欠费提醒",@"icon":@"欠费-icon",@"viewController":@"Payment_arrears_listViewController",@"VCbool":@"1"},
                                    @{@"title":@"合同到期提醒",@"icon":@"合同",@"viewController":@"Contract_expiresViewController",@"VCbool":@"10"},
                                    @{@"title":@"客户生日提醒",@"icon":@"生日",@"viewController":@"Birthday_listViewController",@"VCbool":@"1"},
                                    @{@"title":@"长期未拜访",@"icon":@"拜访记录",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"}]},
                            @{@"section":@"1",@"list":
                                  @[@{@"title":@"资料库",@"icon":@"资料2",@"viewController":@"Product_imformationViewController",@"VCbool":@"1"},
                                    @{@"title":@"祝福短信库",@"icon":@"短信",@"viewController":@"SMS_MessageViewController",@"VCbool":@"1"},
                                    @{@"title":@"案例库",@"icon":@"案例",@"viewController":@"CaseViewController",@"VCbool":@"1"},
                                    @{@"title":@"营销活动信息库",@"icon":@"营销",@"viewController":@"Markeing_classificationViewController",@"VCbool":@"1"}]},
                            @{@"section":@"2",@"list":
                                  @[@{@"title":@"在线考试",@"icon":@"在线考试-(1)",@"viewController":@"Examination_SeconViewController",@"VCbool":@"1"},
                                    @{@"title":@"历史试卷",@"icon":@"试卷",@"viewController":@"Exam_historylistViewController",@"VCbool":@"1"},
                                    @{@"title":@"积分排行",@"icon":@"积分",@"viewController":@"Integral_rankingViewController",@"VCbool":@"1"}]},
                            ];
    }
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scorllorView代理

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return MainBusinessArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    for (int iC = 0; iC < MainBusinessArr.count; iC++) {
        
        if (section == iC) {
            return [[[MainBusinessArr objectAtIndex:iC] objectForKey:@"list"] count];
        }
        
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Central_manageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    cell.titleLable.text = [[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.iconImageView.image = [UIImage imageNamed:[[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"icon"]];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLable.font = [UIFont systemFontOfSize:12];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = RGBCOLOR(244, 244, 244, 1);
        
        UILabel *titilabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 25)];
        titilabel.font = [UIFont systemFontOfSize:13];
        titilabel.textColor = RGBCOLOR(130, 130, 130, 1);
        
        if (indexPath.section == 0) {
            titilabel.text = @"策略集中制定";
        }else if (indexPath.section == 1) {
            titilabel.text = @"政策集中解读";
        }else if (indexPath.section == 2) {
            titilabel.text = @"学习集中管理";
        }else{
            
        }
        
        [headerView addSubview:titilabel];
        reusableview = headerView;
        
    }
    
    return reusableview;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSString *strType = [[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"VCbool"];
    if ([strType isEqualToString:@"0"]) {
        
//        [self goViewController:[[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"viewController"]];
        
    }else{
        
        UIViewController* viewController = [[NSClassFromString( [[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"viewController"]) alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 10)/4, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 25);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
