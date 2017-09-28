//
//  Markeing_classificationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Markeing_classificationViewController.h"
#import "ShortcutItemCollectionViewCell.h"
#import "ImageCollectionReusableView.h"
#import "UIColor+Hex.h"
#import "Marking_listViewController.h"
#import "Marking_queryViewController.h"

@interface Markeing_classificationViewController ()
{
    NSMutableArray *dataArray;
    NSMutableArray *imageArray;
}
@end

static NSString *cellIdentifier = @"ShortcutItemCollectionViewCell";
static NSString *headerIdentifier = @"ImageCollectionReusableView";

@implementation Markeing_classificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销活动方案";
    
    _CollectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    dataArray = [[NSMutableArray alloc]initWithObjects:@"营销活动方案",@"营销活动ID查询",nil];
    imageArray = [[NSMutableArray alloc]initWithObjects:@"programme",@"magnifier",nil];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
    [_CollectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerIdentifier];

    
    nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_CollectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
}

#pragma mark - ButtonMethod

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShortcutItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.iconImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.titleLbl.text = dataArray[indexPath.row];
    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#4d4d4d"];

    cell.backgroundColor = [UIColor whiteColor];

    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]){
        ImageCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:headerIdentifier
                                                                                      forIndexPath:indexPath];
        
        view.imageView.image = [UIImage imageNamed:@"title_image"];
        return view;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        Marking_listViewController *vc = [[Marking_listViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        Marking_queryViewController *vc = [[Marking_queryViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
   
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width-4)/2, (collectionView.bounds.size.height-5*5-135-50)/3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 135);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
