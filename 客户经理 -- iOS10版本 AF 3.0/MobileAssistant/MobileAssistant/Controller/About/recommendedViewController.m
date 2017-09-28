//
//  recommendedViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "recommendedViewController.h"
#import "UIColor+Hex.h"
#import "recommendedEntity.h"
#import "IconCollectionViewCell.h"
#import "Reommended_DetailViewController.h"
#import "MBProgressHUD.h"

@interface recommendedViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

static NSString * CellIdentifier = @"IconCollectionViewCell";

@implementation recommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"APP应用推荐";
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    [self getData];
    
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IconCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    recommendedEntity *entity = self.arrayCutomer[indexPath.row];
    
    cell.titleLbl.text = entity.name;
    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.iconImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((collectionView.bounds.size.width - 20)/3, (collectionView.bounds.size.height-5*4-135)/3);
    return CGSizeMake((collectionView.bounds.size.width - 20)/3, (collectionView.bounds.size.width - 20)/3);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    recommendedEntity *entity = self.arrayCutomer[indexPath.row];
    Reommended_DetailViewController *vc = [[Reommended_DetailViewController alloc]init];
    
    vc.APP_ID = entity.app_id;
    vc.APP_Name = entity.name;
    vc.tel = self.tel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"get_app_list",@"method",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"]) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                recommendedEntity *entity = [[recommendedEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            }
            
            [self.collectionView reloadData];
        }
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
