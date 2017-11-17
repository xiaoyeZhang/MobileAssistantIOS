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
    
//    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{

    self.detailMuArr = [[NSMutableArray alloc] initWithObjects:
                        @{@"title":@"数据日期：",@"detail":_entity.time},
                        @{@"title":@"集团归属县市名称：",@"detail":_entity.area_name},
                        @{@"title":@"集团名称：",@"detail":_entity.company_name},
                        @{@"title":@"集团编号：",@"detail":_entity.company_num},
                        @{@"title":@"行业类别：",@"detail":_entity.type},
                        @{@"title":@"集团客户经理：",@"detail":_entity.user_name},
                        @{@"title":@"集团客户经理编号：",@"detail":_entity.user_num},
                        @{@"title":@"集团归属地市名称：",@"detail":_entity.city_name},
                        @{@"title":@"账号付费周期：",@"detail":_entity.cycle},
                        @{@"title":@"账号编号：",@"detail":_entity.acc_num},
                        @{@"title":@"当月欠费额：",@"detail":_entity.amount},
                        @{@"title":@"欠费月份：",@"detail":_entity.month},
                        @{@"title":@"欠费催缴标识：",@"detail":_entity.flag},
                        @{@"title":@"账号名称：",@"detail":_entity.acc_name},
                        @{@"title":@"账号编码：",@"detail":_entity.guest_num},
                        @{@"title":@"电话号码：",@"detail":_entity.tel},nil];
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
//    if ([[self.detailMuArr[indexPath.row] objectForKey:@"detail"] isEqualToString:@"time"]) {
//        cell.labelName.text = [NSString stringWithFormat:@"%@%@至%@",[self.detailMuArr[indexPath.row] objectForKey:@"title"],[self.dicCutomer objectForKey:@"start_time"],[self.dicCutomer objectForKey:@"end_time"]];
//    }else{
//         cell.labelName.text = [NSString stringWithFormat:@"%@%@",[self.detailMuArr[indexPath.row] objectForKey:@"title"],[self.dicCutomer objectForKey:[self.detailMuArr[indexPath.row] objectForKey:@"detail"]]];
//    }

    cell.labelName.text = [NSString stringWithFormat:@"%@%@",[self.detailMuArr[indexPath.row] objectForKey:@"title"],[self.detailMuArr[indexPath.row] objectForKey:@"detail"]];
    
    return cell;
}

//- (void)getData{
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    
//    CommonService *service = [[CommonService alloc] init];
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    
//    [dict setObject:@"get_arrearage_detail" forKey:@"method"];
//    [dict setObject:self.arrearage_id forKey:@"arrearage_id"];
//    
//    [service getNetWorkData:dict  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        
//        if ([strState isEqualToString:@"1"] == YES) {
//            
//            self.dicCutomer = [entity objectForKey:@"content"];
//            
//        }else{
//            
//
//            
//        }
//        [self.tableView reloadData];
//        [HUD hide:YES];
//    } Failed:^(int errorCode, NSString *message) {
//        [HUD hide:YES];
//        iToast *toast = [iToast makeText:@"网络连接失败"];
//        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//        [toast setDuration:500];
//        [toast show:iToastTypeNotice];
//    }];
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
