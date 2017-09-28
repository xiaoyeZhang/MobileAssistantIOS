//
//  Business_BillListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_BillListViewController.h"
#import "UpDownLabelTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "UIColor+Hex.h"
#import "Business_BillDetailViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "GroupIDModel.h"

@interface Business_BillListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_BillListViewController

- (void)dealloc{
    
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
    
    self.arrayCutomer = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];
    [self loadData];
    
    [self addRefreshView];
    self.output.alpha = 0;
    self.title = @"集团账户列表";
    
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.arrayCustomerTemp removeAllObjects];
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableViewList;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf doTask];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCustomerTemp count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"UpDownLabelTableViewCell";
    UpDownLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GroupIDModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
//    NSString *EffectDate;
//    if (entity.EffectDate.length != 0) {
//        EffectDate=[NSString stringWithFormat:@"截至日期：%@-%@-%@",
//                    [entity.EffectDate substringWithRange:NSMakeRange(0, 4)],
//                    [entity.EffectDate substringWithRange:NSMakeRange(4, 2)],
//                    [entity.EffectDate substringWithRange:NSMakeRange(6, 2)]];
//    }
//    
    cell.titleLable.text = entity.AcctAlias;
    cell.subTitleLbl.text = [NSString stringWithFormat:@"帐户编号：%@",entity.AccountId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_BillDetailViewController *vc = [[Business_BillDetailViewController alloc]init];
    vc.GroupIDentity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    vc.groupId = self.groupId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void) doTask
{
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_QueryGroupAccountInfo",
                           @"user_id":userEntity.user_id,
                           @"GroupId":self.entity?self.entity.num:self.groupId,
                           };

    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"AcctInfo"];
            [self.arrayCutomer removeAllObjects];
            [self.arrayCustomerTemp removeAllObjects];
            
            for (NSDictionary* attributes in array) {
            
                GroupIDModel *entity = [[GroupIDModel alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                [self.arrayCustomerTemp addObject:entity];
            }
            [self.tableViewList reloadData];
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

- (void)queryBtn:(UIButton *)sender{
    
   

}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
