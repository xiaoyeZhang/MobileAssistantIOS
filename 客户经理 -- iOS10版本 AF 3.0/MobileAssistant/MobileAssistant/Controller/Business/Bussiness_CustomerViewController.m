//
//  Bussiness_CustomerViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/10.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Bussiness_CustomerViewController.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "Business_AddclientViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "UserEntity.h"
#import "CompEntity.h"

@interface Bussiness_CustomerViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *selectArray;
    NSString *str;
    NSTimer *timer1;
    int count;
}
@end

@implementation Bussiness_CustomerViewController

- (void)dealloc
{
    [refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self select_logmodel:NSStringFromClass([self class])];
    
    self.tableViewCustomer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textFieldKey.returnKeyType = UIReturnKeyDone;
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.arrayCutomer = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];
    selectArray = [[NSMutableArray alloc] init];
    [self loadData];
    
    [self addRefreshView];
    self.output.alpha = 0;
    self.title = @"集团列表";
}



- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.arrayCustomerTemp removeAllObjects];
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableViewCustomer;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf doTask];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCustomerTemp count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *CellIdentifier = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CompEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    cell.CustomerName.text = entity.name;
    cell.CustomerNum.text = [NSString stringWithFormat:@"集团编号：%@",entity.num];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"集团地址：%@",entity.address];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_AddclientViewController *vc = [[Business_AddclientViewController alloc]init];
    vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    [vc loadData];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)loadData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"company_list",
                           @"user_num":userEntity.num,
                           @"info":@"成员管理"
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            [self.arrayCutomer removeAllObjects];
            [self.arrayCustomerTemp removeAllObjects];
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                [self.arrayCustomerTemp addObject:entity];
            }
            [self.tableViewCustomer reloadData];
        }
        else
        {
           NSString *msg = entity[@"msg"];
            
            if (msg.length > 0) {
                ALERT_ERR_MSG(msg);
            }else{
                
                iToast *toast = [iToast makeText:@"暂无数据"];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:500];
                [toast show:iToastTypeNotice];
            }
        }
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

//- (void)aleartShow:(NSString *)message{
//    
//    if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
//        ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 1;
//        }];
//        
//        timer1 = [NSTimer scheduledTimerWithTimeInterval:1
//                                                  target:self
//                                                selector:@selector(show)
//                                                userInfo:nil
//                                                 repeats:YES];
//        [timer1 fire];
//    }
//}
//
//- (void)show{
//    
//    if (count++ >= 2) {
//        [timer1 invalidate];
//        count = 0;
//        
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}


- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)backAction:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
//        if (![str isEqualToString:self.textFieldKey.text]) {
            [selectArray removeAllObjects];
            for (int i = 0; i < [self.arrayCutomer count]; i++) {
                CompEntity *entity = [self.arrayCutomer objectAtIndex:i];
                
                if ([entity.name rangeOfString:self.textFieldKey.text].location != NSNotFound || [entity.num rangeOfString:self.textFieldKey.text].location != NSNotFound) {
                    [selectArray addObject:entity];
                }
            }
            if ([selectArray count] == 0) {
                
                ALERT_ERR_MSG(@"没有你想要的！");
                return;
            }
            self.arrayCustomerTemp = selectArray;
            [self.tableViewCustomer reloadData];
//        }else{
//            
//        }
        str = self.textFieldKey.text;
    }else{
        
        [self.arrayCustomerTemp removeAllObjects];
        [self loadData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
