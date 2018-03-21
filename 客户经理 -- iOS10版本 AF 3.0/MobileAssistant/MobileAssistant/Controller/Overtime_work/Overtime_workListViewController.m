//
//  Overtime_workListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/12.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Overtime_workListViewController.h"
#import "UserEntity.h"
#import "Central_manageCollectionViewCell.h"
#import "Overtime_work_childlistViewController.h"

@interface Overtime_workListViewController ()
{
    NSMutableArray *MainBusinessArr;
    NSArray *contentArr;
    UserEntity *userEntity;
}
@end

static NSString *cellIdentifier = @"Central_manageCollectionViewCell";

@implementation Overtime_workListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userEntity = [UserEntity sharedInstance];
    
    MainBusinessArr = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [MainBusinessArr addObject:@{@"title":@"分单",@"icon":@"新建",@"state":@"0"}];
    
    [MainBusinessArr addObject:@{@"title":@"预勘察",@"icon":@"查找表单列表",@"state":@"2"}];
    [MainBusinessArr addObject:@{@"title":@"线路建设",@"icon":@"时间",@"state":@"6"}];
    [MainBusinessArr addObject:@{@"title":@"工单确认归档",@"icon":@"时间",@"state":@"10"}];
    [MainBusinessArr addObject:@{@"title":@"工单归档",@"icon":@"时间",@"state":@"7"}];
 
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scorllorView代理

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    return MainBusinessArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Central_manageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLable.text = [[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.iconImageView.image = [UIImage imageNamed:[[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"icon"]];
    
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLable.font = [UIFont systemFontOfSize:12];
    cell.backgroundColor = [UIColor whiteColor];
    
    int num = [self showUnfinishedNumWithIndex:indexPath.row];
    
    [cell.iconImageView showBadgeWithStyle:WBadgeStyleNumber
                                     value:num
                             animationType:WBadgeAnimTypeNone];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    Overtime_work_childlistViewController *vc = [[Overtime_work_childlistViewController alloc]init];
    
    vc.name = [[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    vc.state = [[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 10)/4, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    

    return CGSizeMake(collectionView.bounds.size.width, 0);
    
}
- (int)showUnfinishedNumWithIndex:(NSInteger)index{
    
    int num = 0;
 
    switch (index) {
        case 0:
            num = [[contentArr objectAtIndex:0] intValue];
            break;
        case 1:
            num = [[contentArr objectAtIndex:1] intValue];
            break;
        case 2:
            num = [[contentArr objectAtIndex:2] intValue];
            break;
        case 3:
            num = [[contentArr objectAtIndex:3] intValue];
            break;
        case 4:
            num = [[contentArr objectAtIndex:4] intValue];
            break;
        default:
            break;
    }
    return num;
}

- (void)getData{
    
    NSDictionary *dict = @{@"method":@"m_order_list_delay",
                           @"user_id":userEntity.user_id,
                           @"location":@"-1",
                           @"state":@"-1"
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          contentArr = entity[@"content"];
                          
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
