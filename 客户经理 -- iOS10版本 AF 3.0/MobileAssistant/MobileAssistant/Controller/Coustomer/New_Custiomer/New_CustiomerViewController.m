//
//  New_CustiomerViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/9/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "New_CustiomerViewController.h"
#import "BusinessListCollectionViewCell.h"
#import "UIColor+Hex.h"
#import "UserEntity.h"


@interface New_CustiomerViewController ()
{
    UserEntity *userEntity;
    NSMutableArray *arr;

}
@end

static NSString *cellIdentifier = @"BusinessListCollectionViewCell";


@implementation New_CustiomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userEntity = [UserEntity sharedInstance];
    
    arr = [[NSMutableArray alloc]init];
    
    [arr addObject:@{@"name":@"我的集团",@"image":@"bm_vnetwork",@"viewController":@"New_MyGroupViewController"}];
    
    //客户经理才可添加联系人
    if ([userEntity.type_id isEqualToString:@"0"]) {
        
        [arr addObject:@{@"name":@"添加联系人",@"image":@"bm_addclient-1",@"viewController":@"ContactAddViewController"}];
    
    }
    
    _CollectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_CollectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];

    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLable.text = arr[indexPath.row][@"name"];

    cell.iconImageView.image = [UIImage imageNamed:arr[indexPath.row][@"image"]];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 4)/3, (collectionView.bounds.size.height-4*4-135)/3);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [_mainVC.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIViewController* viewController = [[NSClassFromString([[arr objectAtIndex:indexPath.row] objectForKey:@"viewController"]) alloc] init];
    
    [_mainVC.navigationController pushViewController:viewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
