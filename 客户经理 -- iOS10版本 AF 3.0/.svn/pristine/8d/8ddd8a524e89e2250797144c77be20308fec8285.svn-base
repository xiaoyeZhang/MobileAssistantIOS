//
//  Arrears_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Arrears_DetailViewController.h"
#import "MBProgressHUD.h"
#import "NameTableViewCell.h"

@interface Arrears_DetailViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSDictionary *dicCutomer;
@property (strong, nonatomic) NSMutableArray *detailMuArr;
@end

@implementation Arrears_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"欠费任务详情";
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initData];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    self.detailMuArr = [[NSMutableArray alloc] initWithObjects:
                        @{@"title":@"地区：",@"detail":@"area_name"},
                        @{@"title":@"县市：",@"detail":@"city_name"},
                        @{@"title":@"集团归属县市：",@"detail":@"city_name"},
                        @{@"title":@"客户经理名称：",@"detail":@"user_name"},
                        @{@"title":@"集团ID：",@"detail":@"company_num"},
                        @{@"title":@"账号ID：",@"detail":@"account_id"},
                        @{@"title":@"计费号码：",@"detail":@"num"},
                        @{@"title":@"策划名称：",@"detail":@"name"},
                        @{@"title":@"欠费月：",@"detail":@"time"},
                        @{@"title":@"付费周期：",@"detail":@"cycle"},
                        @{@"title":@"欠费金额：",@"detail":@"sum"},nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailMuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"NameTableViewCell";
    
    NameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([[self.detailMuArr[indexPath.row] objectForKey:@"detail"] isEqualToString:@"time"]) {
        cell.labelName.text = [NSString stringWithFormat:@"%@%@至%@",[self.detailMuArr[indexPath.row] objectForKey:@"title"],[self.dicCutomer objectForKey:@"start_time"],[self.dicCutomer objectForKey:@"end_time"]];
    }else{
         cell.labelName.text = [NSString stringWithFormat:@"%@%@",[self.detailMuArr[indexPath.row] objectForKey:@"title"],[self.dicCutomer objectForKey:[self.detailMuArr[indexPath.row] objectForKey:@"detail"]]];
    }
   
    
    return cell;
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"get_arrearage_detail" forKey:@"method"];
    [dict setObject:self.arrearage_id forKey:@"arrearage_id"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            self.dicCutomer = [entity objectForKey:@"content"];
            
        }else{
            

            
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
