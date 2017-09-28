//
//  SMS_MessageViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/8.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "SMS_MessageViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+Hex.h"
#import "SMS_CollectionViewCell.h"
#import "Bless_informationViewController.h"
@interface SMS_MessageViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *array;
}
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

static NSString * CellIdentifier = @"SMS_CollectionViewCell";

@implementation SMS_MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"祝福短信库";
    self.arrayCutomer =[[NSMutableArray alloc]init];
    array = [[NSMutableArray alloc]init];
    
    _CollectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [_CollectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];

    
    
    //这个地方一定要写，不然会crash
    [_CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    
    [_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    [self getData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    for (int i = 0; i < array.count; i++) {
        
        if (section == i) {
            return [[[array objectAtIndex:i] objectForKey:@"item"] count];
        }
        
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMS_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.TitleLabel.text = [[[[array objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"title"];

    cell.TitleLabel.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//        return CGSizeMake((collectionView.bounds.size.width - 20)/3, (collectionView.bounds.size.height-5*4-135)/3);

    return CGSizeMake((collectionView.bounds.size.width - 20)/4, 40);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 30);
}


//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        headerView.backgroundColor = [UIColor orangeColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[[array objectAtIndex:indexPath.section] objectForKey:@"title"]];
        
        UILabel *titilabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
        titilabel.text = [[array objectAtIndex:indexPath.section] objectForKey:@"title"];
        
        [headerView addSubview:imageView];
        [headerView addSubview:titilabel];
        reusableview = headerView;
        
    }
    
    return reusableview;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Bless_informationViewController *vc = [[Bless_informationViewController alloc]init];
    
    vc.type_id = [[[[array objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"type_id"];
    vc.Title = [[[[array objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    if ([self.type isEqualToString:@"1"]) {
        vc.telArr = self.telArr;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"get_sms_type",@"method",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"]) {
            
            array = [entity objectForKey:@"content"];
            
            [self.CollectionView reloadData];
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