//
//  Contract_expiresViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Contract_expiresViewController.h"
#import "NewsTableViewCell.h"
#import "Birthday_DetailViewController.h"
#import "MBProgressHUD.h"
#import "Contract_listEntity.h"
#import "Contract_expries_DetailViewController.h"

@interface Contract_expiresViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSMutableArray *arrayCutomerOne;
@property (strong, nonatomic) NSMutableArray *arrayCutomerTwo;
@property (strong, nonatomic) NSMutableArray *arrayCutomerThree;
@property (strong, nonatomic) NSMutableArray *arrayCutomerFour;
@end

@implementation Contract_expiresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"合同到期提醒";
    self.arrayCutomerOne = [[NSMutableArray alloc]init];
    self.arrayCutomerTwo = [[NSMutableArray alloc]init];
    self.arrayCutomerThree = [[NSMutableArray alloc]init];
    self.arrayCutomerFour = [[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textFieldKey.returnKeyType = UIReturnKeyDone;
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self getData:@""];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        
        return [self.arrayCutomerOne count];
    }else if(section == 1){
        
        return [self.arrayCutomerTwo count];
    }else if(section == 2){
        
        return [self.arrayCutomerThree count];
    }else if(section == 3){
        
        return [self.arrayCutomerFour count];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    headLabel.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        headLabel.text = @"本月内";
    }else if (section == 1){
        headLabel.text = @"一个月后";
    }else if (section == 2){
        headLabel.text = @"两个月后";
    }else if (section == 3){
        headLabel.text = @"三个月后";
    }else{
        headLabel.text = @"";
    }
    
    [headView addSubview:headLabel];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    cell.typeLabel.text = @"详情查看";
    cell.typeLabel.textColor = [UIColor colorWithRed:16.0/255 green:66.0/255 blue:199.0/255 alpha:1];
    
    Contract_listEntity *entity;
    
    if (indexPath.section == 0) {
        
        entity = [self.arrayCutomerOne objectAtIndex:indexPath.row];

    }else if (indexPath.section == 1) {
        
        entity = [self.arrayCutomerTwo objectAtIndex:indexPath.row];
        
    }else if (indexPath.section == 2) {
        
        entity = [self.arrayCutomerThree objectAtIndex:indexPath.row];
        
    }else if (indexPath.section == 3) {
        
        entity = [self.arrayCutomerFour objectAtIndex:indexPath.row];
        
    }else{

    }
    
    cell.labelTitle.text = [NSString stringWithFormat:@"%@",entity.company_name];
    cell.labelDate.text = [NSString stringWithFormat:@"(%@)",entity.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *contract_id;
    
    if (indexPath.section == 0) {
        Contract_listEntity *entity = [self.arrayCutomerOne objectAtIndex:indexPath.row];
        contract_id = entity.contract_id;
    }else if (indexPath.section == 1) {
        Contract_listEntity *entity = [self.arrayCutomerTwo objectAtIndex:indexPath.row];
        contract_id = entity.contract_id;
    }else if (indexPath.section == 2) {
        Contract_listEntity *entity = [self.arrayCutomerThree objectAtIndex:indexPath.row];
        contract_id = entity.contract_id;
    }else if (indexPath.section == 3) {
        Contract_listEntity *entity = [self.arrayCutomerFour objectAtIndex:indexPath.row];
        contract_id = entity.contract_id;
    }else{
        
    }
    
    Contract_expries_DetailViewController *vc = [[Contract_expries_DetailViewController alloc]init];
    
    vc.contract_id = contract_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData:(NSString *)company_name{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_contract_list",
                           @"user_num":userEntity.num,
                           @"company_name":company_name,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [self.arrayCutomerOne removeAllObjects];
        [self.arrayCutomerTwo removeAllObjects];
        [self.arrayCutomerThree removeAllObjects];
        [self.arrayCutomerFour removeAllObjects];

        if ([strState isEqualToString:@"1"] == YES) {

            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Contract_listEntity *entity = [[Contract_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                
                if ([[entity.show_type stringValue] isEqualToString:@"0"]){
                    
                    [self.arrayCutomerOne addObject:entity];
                
                }else if ([[entity.show_type stringValue] isEqualToString:@"1"]) {
                
                    [self.arrayCutomerTwo addObject:entity];
                
                }else if ([[entity.show_type stringValue] isEqualToString:@"2"]) {
                
                    [self.arrayCutomerThree addObject:entity];
                
                }else if ([[entity.show_type stringValue] isEqualToString:@"3"]) {
                    
                    [self.arrayCutomerFour addObject:entity];
                    
                }else{
                
                }
                
            }
            [self.tableView reloadData];
        }else if([strState isEqualToString:@"0"] == YES){
            

        }else{
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
    
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
    
    [self getData:self.textFieldKey.text];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self getData:self.textFieldKey.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
