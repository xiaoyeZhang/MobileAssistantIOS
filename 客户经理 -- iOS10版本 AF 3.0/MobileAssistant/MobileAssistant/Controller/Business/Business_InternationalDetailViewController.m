//
//  Business_InternationalDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_InternationalDetailViewController.h"
#import "TwoLablesTableViewCell.h"
#import "MessageTableViewCell.h"
#import "UIColor+Hex.h"
#import "ButtonTableViewCell.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"

@interface Business_InternationalDetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *detailMuArr;
    NSDictionary *dic;
    NSTimer *timer1;
    int count;
}
@end

@implementation Business_InternationalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self select_logmodel:NSStringFromClass([self class])];
    
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"手机号码",     @"list":@"state",                @"type":@"Label"},
                   @{@"title":@"当前状态",     @"list":@"state",                @"type":@"Label"},
                   @{@"title":@"变  更",        @"detail":@"company_name",     @"type":@"Button"},
                   nil];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"国际漫游";
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
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_QueryUserRoamState",
                           @"user_id":userEntity.user_id,
                           @"ServiceNum":_ServiceNum,
                           };

    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            dic = entity[@"content"];
//            [self initData];
            [_tableView reloadData];
        }
        [HUD hide:YES];
 
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)initData
{
    if([[dic objectForKey:@"retFlag"] isEqualToString:@"0"]){
       
        NSArray *array = @[@{@"title":@"证件类型",     @"list":@"user_name",            @"type":@"Label"},
                           @{@"title":@"证件号码",     @"list":@"dep_name",             @"type":@"Label"},
                           @{@"title":@"随机号码",     @"detail":@"activity_name",      @"type":@"Text"},
                           @{@"title":@"产品名称",     @"detail":@"company_name",       @"type":@"Label"},];
        NSRange range = NSMakeRange(2, [array count]);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
       
        [detailMuArr insertObjects:array atIndexes:indexSet];

    }
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//              withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [detailMuArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"MessageTableViewCell";
    static NSString *identifier3 = @"ButtonTableViewCell";
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    NSString *type = dict[@"type"]; //类型
    
    if ([type isEqualToString:@"Label"]) { //普通标签
        TwoLablesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
            cell.subTitleLbl.text = _ServiceNum;
        }
        else if (indexPath.row == 1) {
            if ([[dic objectForKey:@"CurrState"] isEqualToString:@"3"]) {
                cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                cell.subTitleLbl.text = @"国际漫游已开通";
            }else {
                cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                cell.subTitleLbl.text = @"国际漫游未开通";
            }
           
        }else{
            cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
            cell.subTitleLbl.text = @"";
        }
        return cell;
    }else if([type isEqualToString:@"Text"]){
        
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = [NSString stringWithFormat:@"%@:",title];
        cell.btn.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
        [cell.btn setTitle:@"获取" forState:UIControlStateNormal];
        cell.btn.tag = 1;
        [cell.btn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if([type isEqualToString:@"Button"]){
        
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.button.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
        if ([[dic objectForKey:@"CurrState"] isEqualToString:@"3"]) {
            
            [cell.button setTitle:@"变  更" forState:UIControlStateNormal];
        }else{
            [cell.button setTitle:@"开通国际漫游" forState:UIControlStateNormal];
        }
        
        cell.button.tag = 2;
        [cell.button addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (void)changeBtn:(UIButton *)sender{
    
    if (sender.tag == 1) {
        
        
    }else if(sender.tag == 2){
        NSString *type = nil;
        if ([[dic objectForKey:@"CurrState"] isEqualToString:@"3"]) {
            type = @"1";
            
        }else{
            type = @"0";
        }
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"努力加载中...";
        
        CommonService *service = [[CommonService alloc] init];
        UserEntity *userEntity = [UserEntity sharedInstance];
        
        NSDictionary *dict = @{@"method":@"whole_province",
                               @"oicode":@"OI_ChangeInternationalRoaming",
                               @"ServiceNum":_ServiceNum,
                               @"user_id":userEntity.user_id,
                               @"ChangeType":type,
                               };
        
        [service getNetWorkData:dict  Successed:^(id entity) {
            
            int state = [entity[@"state"] intValue];
            
            if (state == 1) {
                NSMutableDictionary *dicc = [entity objectForKey:@"content"];
                    if (dicc) {
                        NSString *msg = [NSString stringWithFormat:@"受理成功，订单号：\n%@",[dicc objectForKey:@"CustomerOrderCode"]];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                            [self loadData];
                        }];
                    }
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"变更失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                }];
            }
            [HUD hide:YES];
            
        } Failed:^(int errorCode, NSString *message) {
            [HUD hide:YES];
            iToast *toast = [iToast makeText:@"网络连接失败"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:500];
            [toast show:iToastTypeNotice];
            
        }];
    }
    
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

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
