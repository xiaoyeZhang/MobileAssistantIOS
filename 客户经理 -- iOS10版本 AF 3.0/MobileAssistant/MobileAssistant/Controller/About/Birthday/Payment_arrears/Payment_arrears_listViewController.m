//
//  Payment_arrears_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Payment_arrears_listViewController.h"
#import "NewsTableViewCell.h"
#import "MBProgressHUD.h"
#import "Payment_arrears_listEntity.h"
#import "Arrears_taskViewController.h"

@interface Payment_arrears_listViewController ()<MBProgressHUDDelegate>
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
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"欠费任务提醒";
    self.arrayCutomer =[[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textFiled.returnKeyType = UIReturnKeyDone;
    [self.textFiled addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self getData];
    
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
        [weakSelf getData];
    };
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.typeLabel.alpha = 0;

    Payment_arrears_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = entity.company_name;
    cell.labelDate.text = [NSString stringWithFormat:@"(欠费金额 %@)",entity.sum];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Arrears_taskViewController *vc = [[Arrears_taskViewController alloc]init];
    Payment_arrears_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.company_name = entity.company_name;
    vc.company_num = entity.company_num;
    [vc getData];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"get_arrearage_list" forKey:@"method"];
    
    if (self.user_num.length > 0) {
        [dict setObject:self.user_num forKey:@"user_num"];
    }else{
        [dict setObject:userEntity.num forKey:@"user_num"];
    }
    
    if (company_name.length != 0) {
        [dict setObject:company_name forKey:@"company_name"];
    }
    
    if (company_num.length != 0) {
       [dict setObject:company_num forKey:@"company_num"];
    }
    
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [self.arrayCutomer removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Payment_arrears_listEntity *entity = [[Payment_arrears_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            
            }
            
        }else{

        }
        [self.tableView reloadData];
        [refreshHeader endRefreshing];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
    
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
  
    if (![self isPureNumandCharacters:self.textFiled.text]) {
        company_name = self.textFiled.text;
    }
    
    if ([self isPureNumandCharacters:self.textFiled.text]) {
        company_num = self.textFiled.text;
    }
    
    [self getData];
}

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

@end
