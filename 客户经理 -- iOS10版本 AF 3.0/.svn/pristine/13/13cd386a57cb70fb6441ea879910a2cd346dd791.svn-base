//
//  Business_Group_V_Net_ContactViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Group_V_Net_ContactViewController.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "Group_V_NetModel.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "MJRefresh.h"
#import "Business_Group_V_Net_DetailViewController.h"

@interface Business_Group_V_Net_ContactViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MJRefreshHeaderView *refreshHeader;
    NSMutableArray *selectArray;
    NSString *str;
    NSTimer* timer1;
    int count;
}

@end

@implementation Business_Group_V_Net_ContactViewController

- (void)dealloc
{
    [refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
    
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
    self.output.hidden = YES;
    [self loadData];
    [self addRefreshView];
    self.title = @"集团V网列表";

}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.arrayCustomerTemp removeAllObjects];
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf getData];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCustomerTemp count];
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
    
    Group_V_NetModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    cell.CustomerName.text = entity.VpmnName;
    cell.CustomerNum.text = [NSString stringWithFormat:@"虚拟网成员数：%@",entity.MemberNum];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"虚拟网编号：%@",entity.VpmnId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_Group_V_Net_DetailViewController *vc = [[Business_Group_V_Net_DetailViewController alloc]init];
    vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    vc.compEntity = self.entity;
    [vc loadData];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)loadData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
    
}

- (void) getData
{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{@"method":@"whole_province",
                            @"oicode":@"OI_QueryGroupOrderVmpnInfo",
                            @"user_id":userEntity.user_id,
                            @"GroupId":self.entity.num,
                            };
    
    [service getNetWorkData:dict1  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            NSDictionary *dic = [entity objectForKey:@"content"];
            NSMutableArray *array = [dic objectForKey:@"VpmnInfo"];
            [self.arrayCutomer removeAllObjects];
            [self.arrayCustomerTemp removeAllObjects];
            if ([array count] > 0) {
                for (NSDictionary* attributes in array) {
                    Group_V_NetModel *entity = [[Group_V_NetModel alloc] init];
                    entity = [entity initWithAttributes:attributes];
                    [self.arrayCutomer addObject:entity];
                    [self.arrayCustomerTemp addObject:entity];
                }
                [self.tableView reloadData];
            }
            
        }else if(state == -1){
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
        [HUD hide:YES];
        [refreshHeader endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        [refreshHeader endRefreshing];
       
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
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
//        if (![str isEqualToString:self.textFieldKey.text]) {
            [selectArray removeAllObjects];
            for (int i = 0; i < [self.arrayCutomer count]; i++) {
                Group_V_NetModel *entity = [self.arrayCutomer objectAtIndex:i];

                if ([entity.VpmnName rangeOfString:self.textFieldKey.text].location != NSNotFound) {
                    [selectArray addObject:entity];
                }
            }
            if ([selectArray count] == 0) {
                
                ALERT_ERR_MSG(@"没有你想要的！");
                return;
            }
            self.arrayCustomerTemp = selectArray;
            [self.tableView reloadData];
//        }else{
//            
//        }
        str = self.textFieldKey.text;
    }else{
        
        [self.arrayCustomerTemp removeAllObjects];
        [self loadData];
    }
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
