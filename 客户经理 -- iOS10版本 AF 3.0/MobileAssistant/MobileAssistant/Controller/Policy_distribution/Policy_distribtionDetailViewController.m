//
//  Policy_distribtionDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Policy_distribtionDetailViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "strategy_DetailEntity.h"

@interface Policy_distribtionDetailViewController ()
{
    LineTwoLabelTableViewCell *cell;
    UserEntity *userEntity;
    NSMutableDictionary *MU_Dic;
    NSMutableArray *detailMuArr;
}
@end

@implementation Policy_distribtionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _name;
    
    userEntity = [UserEntity sharedInstance];
    MU_Dic = [NSMutableDictionary dictionary];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"发起人姓名:",@"detail":@"user_name"},
                   @{@"title":@"发起人部门:",@"detail":@"dep_name"},
                   @{@"title":@"策略分类:",@"detail":@"type"},
                   @{@"title":@"策略名称:",@"detail":@"name"},
                   @{@"title":@"工作要求:",@"detail":@"job"},
                   @{@"title":@"执行开始时间:",@"detail":@"start_time"},
                   @{@"title":@"执行结束时间:",@"detail":@"end_time"},
                   @{@"title":@"执行过程监控方式:",@"detail":@"process"},
                   @{@"title":@"完成结果评估标准:",@"detail":@"standard"},nil];
    
    [self getData];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return detailMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
    cell.titLabel.text = [[detailMuArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.subTitleLbl.text = [MU_Dic objectForKey:[[detailMuArr objectAtIndex:indexPath.row] objectForKey:@"detail"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)getData{
    
    NSDictionary *dict = @{@"method":@"strategy_list",
                           @"user_id":userEntity.user_id,
                           @"type_id":_type_id,
                           @"s_id":_s_id
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 9) {
                          
                          MU_Dic = [entity objectForKey:@"content"];
    
                      }
                      
                      [self.tableView reloadData];
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
