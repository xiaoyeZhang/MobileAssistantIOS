//
//  Payment_arrears_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Payment_arrears_listViewController.h"
#import "Payment_arrears_listTableViewCell.h"
#import "MBProgressHUD.h"
#import "Payment_arrears_listEntity.h"
#import "Arrears_taskViewController.h"

@interface Payment_arrears_listViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *HUD;
    NSString *company_num;
    NSString *company_name;
}
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Payment_arrears_listViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"欠费任务提醒";
    self.arrayCutomer =[[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.textFiled.returnKeyType = UIReturnKeyDone;
    //    [self.textFiled addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self getData:0];
    
    [self addRefreshView];

    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = self.tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        company_name = @"";
        company_num = @"";
        [weakSelf getData:0];
    };
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getData:weakSelf.arrayCutomer.count];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Payment_arrears_listTableViewCell";
    
    Payment_arrears_listTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Payment_arrears_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = entity.company_name;
    cell.company_num.text = [NSString stringWithFormat:@"集团编号:%@",entity.company_num];
    cell.all_amountLabel.text = [NSString stringWithFormat:@"总欠费金额:%@",entity.all_amount];
    cell.timeLabel.text = [NSString stringWithFormat:@"截止日期:%@",entity.time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Arrears_taskViewController *vc = [[Arrears_taskViewController alloc]init];
    Payment_arrears_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.company_name = entity.company_name;
    vc.company_num = entity.company_num;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//- (void)TextFieldEndEdited:(UITextField *)TextField
//{
//    [TextField resignFirstResponder];
//}

- (void)getData:(NSUInteger)page{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_arrearage_list" forKey:@"method"];
    
    [dict setObject:@(page) forKey:@"local"];
    
    if (self.user_num.length > 0) {
        [dict setObject:self.user_num forKey:@"user_num"];
    }else{
        [dict setObject:userEntity.num forKey:@"user_num"];
    }
    
    //    if (company_name.length != 0) {
    //        [dict setObject:company_name forKey:@"company_name"];
    //    }
    //
    //    if (company_num.length != 0) {
    //       [dict setObject:company_num forKey:@"company_num"];
    //    }
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (page == 0) {
            [self.arrayCutomer removeAllObjects];
        }
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Payment_arrears_listEntity *entity = [[Payment_arrears_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                
            }
            
        }else{
            
            [self.arrayCutomer removeAllObjects];
            
        }
        [self.tableView reloadData];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        [HUD hide:YES];

    }];
    
    
}
//- (IBAction)doSelectByKey:(UIButton *)sender {
//
//    [self.view endEditing:YES];
//
//    if (![self isPureNumandCharacters:self.textFiled.text]) {
//        company_name = self.textFiled.text;
//    }
//
//    if ([self isPureNumandCharacters:self.textFiled.text]) {
//        company_num = self.textFiled.text;
//    }
//
//    [self getData:0];
//}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(string.length > 0)
    {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
