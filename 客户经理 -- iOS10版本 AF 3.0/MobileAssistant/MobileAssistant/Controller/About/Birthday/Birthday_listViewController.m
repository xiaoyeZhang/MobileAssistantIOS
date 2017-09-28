//
//  Birthday_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/5.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Birthday_listViewController.h"
#import "NewsTableViewCell.h"
#import "Birthday_DetailViewController.h"
#import "MBProgressHUD.h"
#import "Birthday_listEntity.h"
#import "Birthday_departmentViewController.h"

@interface Birthday_listViewController ()<MBProgressHUDDelegate,Birthday_departmentDelegate>
{
    MBProgressHUD *HUD;
    NSString *Dep_id;
}
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@property (strong, nonatomic) NSMutableArray *arrayCutomerTemp;

@end

@implementation Birthday_listViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"生日提醒";
    
    Dep_id = @"-1";
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    self.arrayCutomerTemp = [[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 44);
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(search_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNaviBarRightView:rightBtn];
    
    self.textFieldKey.returnKeyType = UIReturnKeyDone;
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    [self getData:@"" andWithdep_id:Dep_id];
}

#pragma mark - ButtonMethod

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        
        return [self.arrayCutomer count];
    }else{
        return [self.arrayCutomerTemp count];
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
        headLabel.text = @"本周内";
    }
    else{
        headLabel.text = @"一个月内";
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
    
    Birthday_listEntity *entity;
    
    if (indexPath.section == 0) {
        
       entity = [self.arrayCutomer objectAtIndex:indexPath.row];
        
        
        
    }else{
        
        entity = [self.arrayCutomerTemp objectAtIndex:indexPath.row];
        
//        cell.labelTitle.text = [NSString stringWithFormat:@"%@ (%@)",entity.client_name,entity.company_name];
//        cell.labelDate.text = [NSString stringWithFormat:@"距离生日%@天",entity.date];
//        
//        if ([entity.state isEqualToString:@"-1"]) {
//            cell.typeLabel.text = @"未发送短信";
//        }else if ([entity.state isEqualToString:@"0"]){
//            cell.typeLabel.text = @"已发送";
//        }else if ([entity.state isEqualToString:@"1"]){
//            cell.typeLabel.text = @"定时发送";
//        }
    }
    
    cell.labelTitle.text = [NSString stringWithFormat:@"%@ (%@)",entity.client_name,entity.company_name];
    cell.labelDate.text = [NSString stringWithFormat:@"距离生日%@天",entity.date];
    
    if ([entity.state isEqualToString:@"-1"]) {
        cell.typeLabel.text = @"未发送短信";
    }else if ([entity.state isEqualToString:@"0"]){
        cell.typeLabel.text = @"已发送";
    }else if ([entity.state isEqualToString:@"1"]){
        cell.typeLabel.text = @"定时发送";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *birthday_id;
    
    if (indexPath.section == 0) {
        Birthday_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
        birthday_id = entity.birthday_id;
    }else{
        Birthday_listEntity *entity = [self.arrayCutomerTemp objectAtIndex:indexPath.row];
        birthday_id = entity.birthday_id;
    }
    Birthday_DetailViewController *vc = [[Birthday_DetailViewController alloc]init];
    
    vc.birthday_id = birthday_id;
    [vc getData];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)search_Click:(id)sender{
    
    Birthday_departmentViewController *vc = [[Birthday_departmentViewController alloc]init];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)successBirthday_departmentdelegate:(NSDictionary *)successdelegate{
    
    
    NSLog(@"----%@",successdelegate);
    
    Dep_id = [successdelegate objectForKey:@"dep_id"];
    
    [self getData:@"" andWithdep_id:Dep_id];
}

- (void)getData:(NSString *)query andWithdep_id:(NSString *)dep_id{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_birthday_list",
                           @"user_num":userEntity.num,
                           @"query":query,
                           @"dep_id":dep_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            [self.arrayCutomer removeAllObjects];
            [self.arrayCutomerTemp removeAllObjects];
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Birthday_listEntity *entity = [[Birthday_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                if ([entity.birthday_type isEqualToString:@"1"]) {
                    [self.arrayCutomer addObject:entity];
                }else{
                    [self.arrayCutomerTemp addObject:entity];
                }
                
            }
            
        }else{
            [self.arrayCutomer removeAllObjects];
            [self.arrayCutomerTemp removeAllObjects];
            
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
    
    [self getData:self.textFieldKey.text andWithdep_id:Dep_id];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self getData:self.textFieldKey.text andWithdep_id:Dep_id];
    
}


- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    
    [self getData:@"" andWithdep_id:Dep_id];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
