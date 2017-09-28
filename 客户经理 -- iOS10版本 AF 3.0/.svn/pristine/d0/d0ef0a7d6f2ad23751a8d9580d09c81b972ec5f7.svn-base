//
//  Business_MarkingPlanDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/15.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_MarkingPlanDetailViewController.h"
#import "TwoLablesTableViewCell.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "GroupOrderModel.h"
#import "Business_MarkingPlanListViewController.h"
@interface Business_MarkingPlanDetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *detailMuArr;
    NSDictionary *dic;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_MarkingPlanDetailViewController

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
    self.arrayCustomerTemp = [[NSMutableArray alloc]init];
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.title = @"已办营销活动列表";
    self.output.alpha = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }else if (section == 1){
        num = [self.arrayCustomerTemp count];
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){

       return 95;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"Bussiness_CustomerTableViewCell";
    
    TwoLablesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.titleLbl.text = @"电话号码：";
        cell.subTitleLbl.text  = self.ServiceNum;
        return cell;
    }else{
        Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        GroupOrderModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];;
        cell.CustomerName.text = entity.OfferName;
        NSString *EffectiveDate;
        NSString *ExpireDate;
        if (entity.EffectiveDate.length != 0) {
            EffectiveDate=[NSString stringWithFormat:@"%@-%@-%@",
                        [entity.EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                        [entity.EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                        [entity.EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
        }
        if (entity.ExpireDate.length != 0) {
            ExpireDate=[NSString stringWithFormat:@"%@-%@-%@",
                        [entity.ExpireDate substringWithRange:NSMakeRange(0, 4)],
                        [entity.ExpireDate substringWithRange:NSMakeRange(4, 2)],
                        [entity.ExpireDate substringWithRange:NSMakeRange(6, 2)]];
        }
        cell.CustomerNum.text = [NSString stringWithFormat:@"生效时间：%@",EffectiveDate];
        cell.CustomerAddress.text = [NSString stringWithFormat:@"失效时间：%@",ExpireDate];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_MarkingPlanListViewController *vc = [[Business_MarkingPlanListViewController alloc]init];
    vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 营销活动列表";
    }
    
    return title;
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
                           @"oicode":@"OI_GetUserOffer",
                           @"user_id":userEntity.user_id,
                           @"ServiceNum":_ServiceNum,
                           @"ValidType":@"2",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
    
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"OfferInstInfo"];
            for (NSDictionary* attributes in array) {
            
                GroupOrderModel *entity = [[GroupOrderModel alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                [self.arrayCustomerTemp addObject:entity];
            }
            [self.tableView reloadData];
        }
        else
        {
            ALERT_ERR_MSG(entity[@"msg"]);
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
