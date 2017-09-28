//
//  Business_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_DetailViewController.h"
#import "TxtFieldTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIAlertView+Blocks.h"
#import "Business_ProdInstInfoViewController.h"
#import "Business_AttrInstInfoViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "MBProgressHUD.h"

@interface Business_DetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    LineTwoLabelTableViewCell *cell1;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_DetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    
    self.title = @"集团产品信息详情";
    self.output.alpha = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        CGFloat cellheight;
        cellheight = cell1.subTitleLbl.layer.frame.size.height;
        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 27;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"TxtFieldTableViewCell";
    static NSString *CellIdentifier2 = @"LineTwoLabelTableViewCell";
    static NSString *CellIdentifier3 = @"ButtonTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 1) {
        
    }else{
        cell.txtField.tag = indexPath.row;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"套餐编号：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.entity.OfferId;
            break;
        }
//        case 2:
//        {
//            cell.titleLbl.text = @"套餐价格：";
//            cell.txtField.placeholder = nil;
//            cell.txtField.text = self.entity.Price;
//            break;
//        }
        case 2:
        {
            cell.titleLbl.text = @"服务号码：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.entity.BillId;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"计费类型：";
            cell.txtField.placeholder = nil;
            NSString *billingType;
            if ([self.entity.BillingType isEqualToString:@"0"]) {
                billingType = @"免费";
            }else if ([self.entity.BillingType isEqualToString:@"1"]){
                billingType = @"按条计费";
            }else if ([self.entity.BillingType isEqualToString:@"2"]){
                billingType = @"包月计费";
            }else if ([self.entity.BillingType isEqualToString:@"3"]){
                billingType = @"包时计费";
            }else if ([self.entity.BillingType isEqualToString:@"4"]){
                billingType = @"包次计费";
            }else if ([self.entity.BillingType isEqualToString:@"5"]){
                billingType = @"按照栏目包月";
            }else{
                
            }
            cell.txtField.text = billingType;
            break;
        }
//        case 5:
//        {
//            cell.titleLbl.text = @"操作类型：";
//            cell.txtField.placeholder = nil;
//            
//            NSString *OperType;
//            if ([self.entity.OperType isEqualToString:@"0"] == YES) {
//                OperType = @"订购";
//            }else if ([self.entity.OperType isEqualToString:@"1"]){
//                OperType = @"退订";
//            }else if ([self.entity.OperType isEqualToString:@"2"]){
//                OperType = @"变更";
//            }else{
//                
//            }
//            
//            cell.txtField.text = OperType;
//            break;
//        }
        case 4:
        {
            cell.titleLbl.text = @"生效类型：";
            NSString *EffectiveType;
            if ([self.entity.EffectiveType isEqualToString:@"0"]) {
                EffectiveType = @"立即生效";
            }else if ([self.entity.EffectiveType isEqualToString:@"1"]){
                EffectiveType = @"下周期生效";
            }else if ([self.entity.EffectiveType isEqualToString:@"2"]){
                EffectiveType = @"指定生效";
            }else{
                
            }
            cell.txtField.text = EffectiveType;
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"生效日期：";
            NSString *EffectiveType;
            if (self.entity.EffectiveDate.length != 0) {
                EffectiveType=[NSString stringWithFormat:@"%@-%@-%@",
                            [self.entity.EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                            [self.entity.EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                            [self.entity.EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
            }
            cell.txtField.text = EffectiveType;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"失效日期：";
            NSString *ExpireDate;
            if (self.entity.ExpireDate.length != 0) {
                ExpireDate=[NSString stringWithFormat:@"%@-%@-%@",
                               [self.entity.ExpireDate substringWithRange:NSMakeRange(0, 4)],
                               [self.entity.ExpireDate substringWithRange:NSMakeRange(4, 2)],
                               [self.entity.ExpireDate substringWithRange:NSMakeRange(6, 2)]];
            }
            cell.txtField.text = ExpireDate;
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"产品信息：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = @"查看产品信息";
            cell.txtField.textColor = RGBA(29, 98, 254, 1);
            break;
        }
        case 8:
        {
            cell.titleLbl.text = @"产品属性：";
            cell.txtField.placeholder = nil;
            cell.txtField.text = @"查看产品属性";
            cell.txtField.textColor = RGBA(29, 98, 254, 1);
            break;
        }
        default:
            break;
    }
    
    if (indexPath.row == 1) {
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if(!cell1)
        {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell1.titLabel.text = @"套餐名称：";
        cell1.subTitleLbl.layer.borderWidth = 0.5;
        cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
        cell1.subTitleLbl.layer.cornerRadius = 6;
        cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
        cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.OfferName];

        return cell1;
    }
    
    if (indexPath.row == 9) {
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier3 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.button.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
        [cell.button setTitle:@"退 订" forState:UIControlStateNormal];
        cell.button.tag = 2;
        [cell.button addTarget:self action:@selector(logoutBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 7){

        Business_ProdInstInfoViewController *vc = [[Business_ProdInstInfoViewController alloc]init];
        vc.ProdInstInfo = self.entity.ProdInstInfo;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (textField.tag == 8){

        Business_AttrInstInfoViewController *vc = [[Business_AttrInstInfoViewController alloc]init];
        vc.AttrInstInfo = self.entity.AttrInstInfo;
        vc.num = 1;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    else{
        return NO;
    }
    return YES;
}

- (void)logoutBtn:(UIButton *)sender{
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退订吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"努力加载中...";

            CommonService *service = [[CommonService alloc] init];
            UserEntity *userEntity = [UserEntity sharedInstance];

            NSDictionary *dict = @{@"method":@"whole_province",
                                   @"oicode":@"OI_LogoutGroupProduct",
                                   @"user_id":userEntity.user_id,
                                   @"GroupId":self.GroupId,
                                   @"OfferId":self.entity.OfferId,
                                   @"MainBillId":self.entity.BillId,
                                   };

            [service getNetWorkData:dict  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                if ([strState isEqualToString:@"1"] == YES) {
                    NSMutableDictionary *dic = [entity objectForKey:@"content"];
                    if (dic) {
                        
                        //受理成功后，返回列表，数据就少一条
                         NSString *msg = [NSString stringWithFormat:@"受理成功，订单号：\n%@",[dic objectForKey:@"DoneCode"]];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                        }];

                    }
                    
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
        else{
            
        }
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
