//
//  Case_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/19.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Case_listViewController.h"
#import "Product_classificationTableViewCell.h"
#import "Product_classificationEntity.h"
#import "Case_DetailViewController.h"
#import "MBProgressHUD.h"

@interface Case_listViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *arrayList;
}
@end

@implementation Case_listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    arrayList = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Product_classificationTableViewCell";
    
    Product_classificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.icon.layer.masksToBounds = YES;
        cell.SeeLabel.alpha = 0;
    }
    
    Product_classificationEntity *entity = [arrayList objectAtIndex:indexPath.row];
    
    cell.bgView.layer.borderWidth = 1;
    cell.bgView.layer.borderColor = [UIColor colorWithRed:236.0/255 green:239.0/255 blue:239.0/255 alpha:1].CGColor;
    
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.icon setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLabel.text = entity.name;
    cell.messageLabel.text = entity.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Product_classificationEntity *entity = [arrayList objectAtIndex:indexPath.row];
    
    Case_DetailViewController *vc = [[Case_DetailViewController alloc]init];
    vc.name = self.name;
    vc.entity = entity;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_case_list",
                           @"type_id":self.type_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            [arrayList removeAllObjects];
            
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                
                Product_classificationEntity *entity = [[Product_classificationEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                [arrayList addObject:entity];
                
            }
            
            
        }else{
            
        }
        
        [self.tableView reloadData];
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
