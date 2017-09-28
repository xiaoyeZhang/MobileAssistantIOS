//
//  News_ProvinceVIPViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/22.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_ProvinceVIPViewController.h"
#import "News_ProvinceVIPTableViewCell.h"
#import "CommonService.h"
#import "News_ProvinceVipEntity.h"
#import "UIView+WZLBadge.h"
#import "News_ProviceVIP_ListViewController.h"


@interface News_ProvinceVIPViewController ()
{
    News_ProvinceVIPTableViewCell *cell;
}

@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation News_ProvinceVIPViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"统一下单业务受理";
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"News_ProvinceVIPTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    News_ProvinceVipEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:entity.icon];
    
    [cell.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLabel.text = entity.name;
    
    [cell.iconImage showBadgeWithStyle:WBadgeStyleNumber
                            value:[entity.count intValue]
                    animationType:WBadgeAnimTypeNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    News_ProviceVIP_ListViewController *vc = [[News_ProviceVIP_ListViewController alloc]init];
    News_ProvinceVipEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.module_id = entity.module_id;
    vc.name = entity.name;
    [self.navigationController pushViewController:vc animated:YES];
    
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
            
            [self.tableView reloadData];
            
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
