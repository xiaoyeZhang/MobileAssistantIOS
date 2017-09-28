//
//  Business_Coloring_RingDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/28.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Coloring_RingDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Block.h"
#import "LineTwoLabelTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "CommonService.h"

@interface Business_Coloring_RingDetailViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    LineTwoLabelTableViewCell *cell1;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_Coloring_RingDetailViewController

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
    
    UIButton *deleteButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];

    self.navigationItem.rightBarButtonItem = deleteButtonItem;
    
    self.title = @"成员信息";
    self.output.alpha = 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
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
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.txtField.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = @"集团名称：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.name];
            
            return cell1;
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"集团编号：";
            cell.txtField.text = self.entity.GroupId;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"成员编号：";
            cell.txtField.text = self.entity.MemberCustId;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"姓      名：";
            cell.txtField.text = self.entity.CustName;
            
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"电       话：";
            cell.txtField.text = self.entity.ServiceNum;

            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"职       位：";
            cell.txtField.text = self.entity.Job;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"集团类型：";
            if ([self.entity.GroupMode isEqualToString:@"1"]) {
                cell.txtField.text = @"企业类";
            }else if ([self.entity.GroupMode isEqualToString:@"2"]) {
                cell.txtField.text = @"村镇类";
            }
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"成员类型：";
            if ([self.entity.MemberKind isEqualToString:@"1"]) {
                cell.txtField.text = @"网内成员";
            }else if ([self.entity.MemberKind isEqualToString:@"3"]) {
                cell.txtField.text = @"网外成员";
            }
            
            break;
        }
        case 8:
        {
            cell.titleLbl.text = @"成员状态：";
            if ([self.entity.State isEqualToString:@"1"]) {
                cell.txtField.text = @"正常";
            }else if([self.entity.State isEqualToString:@"3"]){
                cell.txtField.text = @"暂停中";
            }else if([self.entity.State isEqualToString:@"4"]){
                cell.txtField.text = @"免费体验";
            }
            
            break;
        }
        case 9:
        {
            cell.titleLbl.text = @"办理时间：";
            NSString *CreateDate;
            if (self.entity.CreateDate.length != 0) {
                CreateDate=[NSString stringWithFormat:@"%@-%@-%@",
                            [self.entity.CreateDate substringWithRange:NSMakeRange(0, 4)],
                            [self.entity.CreateDate substringWithRange:NSMakeRange(4, 2)],
                            [self.entity.CreateDate substringWithRange:NSMakeRange(6, 2)]];
                cell.txtField.text = CreateDate;
            }else{
                cell.txtField.text = @"";
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)deleteAction:(UIButton *)sender{
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"努力加载中...";
            CommonService *service = [[CommonService alloc] init];
            UserEntity *userEntity = [UserEntity sharedInstance];
            
            NSDictionary *dict;

            dict = @{@"method":@"whole_province",
                     @"oicode":@"OI_DelUserOrderGroupProduct",
                     @"user_id":userEntity.user_id,
                     @"GroupId":self.entity.GroupId,
                     @"MainBillId":self.BillId,
                     @"ServiceNum":self.entity.ServiceNum,
                     @"OfferId":@"211230514400",
                     };
            
            [service getNetWorkData:dict  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                if ([strState isEqualToString:@"1"] == YES) {
                    NSDictionary *dic = [entity valueForKeyPath:@"content"];
                    
                    if (dic) {
                        NSString *msg = [NSString stringWithFormat:@"受理成功,当前流水号:\n%@",[dic objectForKey:@"DoneCode"]];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                            [self.navigationController popViewControllerAnimated:YES];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                        }];
                    }
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
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
