//
//  CaseViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/19.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "CaseViewController.h"
#import "UIColor+Hex.h"
#import "Product_classificCollectionViewCell.h"
#import "Product_informationEntity.h"
#import "Case_listViewController.h"

@interface CaseViewController ()
{
    NSMutableArray *arrayList;
}
@end

@implementation CaseViewController

static NSString *cellIdentifier = @"Product_classificCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"案例库";
    
    arrayList = [[NSMutableArray alloc]init];

    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self getDataCase];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Product_classificCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Product_informationEntity *entity = [arrayList objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithHexString:entity.color];
    
    cell.titleLbl.text = entity.name;
    
    cell.titleLbl.font = [UIFont systemFontOfSize:17];
    
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.iconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Product_informationEntity *entity = [arrayList objectAtIndex:indexPath.row];
    
    Case_listViewController* vc = [[Case_listViewController alloc] init];
    
    vc.name = entity.name;
    vc.type_id = entity.type_id;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((collectionView.bounds.size.width - 15)/2, (collectionView.bounds.size.height - 30 - 135 - 150)/2);
    return CGSizeMake((collectionView.bounds.size.width-4)/2, (collectionView.bounds.size.height-30-135-150)/2);
}

-(void)getDataCase{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userinfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"get_case_type_list",
                           @"user_id":userinfo.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            [arrayList removeAllObjects];
            
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                
                Product_informationEntity *entity = [[Product_informationEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                [arrayList addObject:entity];
                
            }
            
            
        }else{
            
        }
        
        [self.collectionView reloadData];
    } Failed:^(int errorCode, NSString *message) {

        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
