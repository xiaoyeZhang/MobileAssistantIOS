//
//  News_ProviceVip_TwoViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_ProviceVip_TwoViewController.h"
#import "BusinessListCollectionViewCell.h"
#import "ImageCollectionReusableView.h"
#import "UIView+WZLBadge.h"
#import "UIColor+Hex.h"
#import "News_ProvinceVipEntity.h"
#import "News_ProviceVIP_ListViewController.h"
#import "goP_Vertical_industry_collaborationViewController.h"

@interface News_ProviceVip_TwoViewController ()

@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";
static NSString *headerIdentifier = @"ImageCollectionReusableView";

@implementation News_ProviceVip_TwoViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"统一下单业务受理";
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
    [_collectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerIdentifier];
    
    nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayCutomer count];
//    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    News_ProvinceVipEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    BusinessListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLable.text = entity.name;

    NSURL *url = [NSURL URLWithString:entity.icon];
    [cell.iconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    [cell.iconImageView showBadgeWithStyle:WBadgeStyleNumber
                                 value:[entity.count intValue]
                         animationType:WBadgeAnimTypeNone];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]){
        ImageCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
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
    News_ProvinceVipEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    if ([entity.module_id isEqualToString:@"-1"]) {
        goP_Vertical_industry_collaborationViewController *vc = [[goP_Vertical_industry_collaborationViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        News_ProviceVIP_ListViewController *vc = [[News_ProviceVIP_ListViewController alloc]init];
        
        vc.module_id = entity.module_id;
        vc.name = entity.name;
        [self.navigationController pushViewController:vc animated:YES];
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

-(void)getData{
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{
                            @"method":@"get_module_list",
                            @"user_id":userEntity.user_id,
                            @"dep_id":userEntity.dep_id,
                            };
    
    
    [service getNetWorkData:dict1 Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"]) {
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:500];
            [toast show:iToastTypeNotice];
            
        }else{
            NSMutableArray *array = [entity objectForKey:@"content"];
            [self.arrayCutomer removeAllObjects];
            
            for (NSDictionary* attributes in array) {
                News_ProvinceVipEntity *entity = [[News_ProvinceVipEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            }
            
            [self.collectionView reloadData];
            
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
    
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
