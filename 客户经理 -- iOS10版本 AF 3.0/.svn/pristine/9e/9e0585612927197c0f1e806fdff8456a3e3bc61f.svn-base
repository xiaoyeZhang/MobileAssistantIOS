//
//  Arrears_taskViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Arrears_taskViewController.h"
#import "MBProgressHUD.h"
#import "Arrears_taskEntity.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "Arrears_DetailViewController.h"

@interface Arrears_taskViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong ,nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation Arrears_taskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"欠费任务提醒";
    self.arrayCutomer = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 10, 20)];
    headLabel.font = [UIFont systemFontOfSize:15];
    
    headLabel.text = self.company_name;
    
    [headView addSubview:headLabel];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
    }
    Arrears_taskEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    cell.CustomerName.text = entity.name;
    
    cell.CustomerNum.text = [NSString stringWithFormat:@"生效时间：%@",entity.start_time];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"失效时间：%@",entity.end_time];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Arrears_DetailViewController *vc = [[Arrears_DetailViewController alloc]init];
    Arrears_taskEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.arrearage_id = entity.arrearage_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"get_arrearage_detail_list" forKey:@"method"];
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [self.arrayCutomer removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Arrears_taskEntity *entity = [[Arrears_taskEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                
            }
            
        }else{
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:500];
            [toast show:iToastTypeNotice];
            
        }
        [self.tableView reloadData];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
