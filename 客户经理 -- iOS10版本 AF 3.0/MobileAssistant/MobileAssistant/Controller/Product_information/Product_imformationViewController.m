//
//  Product_imformationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/4.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Product_imformationViewController.h"
#import "UIColor+Hex.h"
#import "Product_classificCollectionViewCell.h"
#import "ImageCollectionReusableView.h"
#import "Product_informationEntity.h"
#import "Product_classificationViewController.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define MAINSCROLLHEIGHT self.view.bounds.size.height - 64

@interface Product_imformationViewController ()
{
    NSMutableArray *arrayList;
}

@property (strong, nonatomic) NSString *Type;
@end

static NSString *cellIdentifier = @"Product_classificCollectionViewCell";

static NSString *headerIdentifier = @"ImageCollectionReusableView";

@implementation Product_imformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品资料库";
    
    arrayList = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.headerReferenceSize = CGSizeMake(WIDTH,135);
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, MAINSCROLLHEIGHT) collectionViewLayout:flowlayout];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    
    _collectionview.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
    [_collectionview registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerIdentifier];
    
    
    nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionview registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:_collectionview];
    
    [self getDataScope:@"1"];
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
    
    Product_classificationViewController *vc = [[Product_classificationViewController alloc]init];
    
    vc.name = entity.name;
    vc.type_id = entity.type_id;

    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake((collectionView.bounds.size.width-15)/2, (collectionView.bounds.size.height - 30 - 135 - 150)/2);
//    return CGSizeMake((collectionView.bounds.size.width-4)/2, (collectionView.bounds.size.height-30-135-150)/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 1, 1, 1);
}

-(void)getDataScope:(NSString *)scope_id{
    
    self.Type = scope_id;
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userinfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"get_product_type_list",
                           @"scope_id":scope_id,
                           @"user_id":userinfo.user_id
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
        
        [self.collectionview reloadData];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:1000];
        [toast show:iToastTypeNotice];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
