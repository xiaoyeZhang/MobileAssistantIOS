//
//  Contract_expries_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Contract_expries_DetailViewController.h"
#import "TwoLablesTableViewCell.h"
#import "MBProgressHUD.h"
#import "Contract_DetailEntity.h"

@interface Contract_expries_DetailViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *arrary;
    NSMutableArray *detailMuArr;
    TwoLablesTableViewCell *cell;
}

@end

@implementation Contract_expries_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"合同详情";
    [self initData];
    self.tableView.scrollEnabled = NO;
    arrary = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
}

- (void)initData
{
        detailMuArr = [[NSMutableArray alloc] initWithObjects:
                       @{@"title":@"集团名称:"},
                       @{@"title":@"集团编号:"},
                       @{@"title":@"合同系列号:"},
                       @{@"title":@"合同名称:"},
                       @{@"title":@"生效时间:"},
                       @{@"title":@"失效时间:"},nil];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                              .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 30;
    }
    return size.height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [detailMuArr count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.titleLbl.text = [detailMuArr objectAtIndex:indexPath.row][@"title"];
    
    if (arrary.count > 0) {
        
        Contract_DetailEntity *entity = [arrary objectAtIndex:0];
        
        if (indexPath.row == 0) {
            cell.subTitleLbl.text = entity.company_name;
        }else if(indexPath.row == 1){
            cell.subTitleLbl.text = entity.company_num;
        }else if(indexPath.row == 2){
            cell.subTitleLbl.text = entity.contract_sn;
        }else if(indexPath.row == 3){
            cell.subTitleLbl.text = entity.contract_name;
        }else if(indexPath.row == 4){
            cell.subTitleLbl.text = entity.start_time;
        }else if(indexPath.row == 5){
            cell.subTitleLbl.text = entity.end_time;
        }
        
    }
    
    return cell;
    
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_contract_detail",
                           @"contract_id":self.contract_id,
                           
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSDictionary *dic = [entity valueForKey:@"content"];
            Contract_DetailEntity *entity = [[Contract_DetailEntity alloc]init];
            
            entity = [entity initWithAttributes:dic];
            
            [arrary addObject:entity];
            
            
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
