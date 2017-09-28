//
//  Business_ContactDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_ContactDetailViewController.h"
#import "TxtFieldTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Block.h"
#import "LineTwoLabelTableViewCell.h"

@interface Business_ContactDetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    LineTwoLabelTableViewCell *cell1;
    NSTimer *timer1;
    int count;
}


@end

@implementation Business_ContactDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeClick = NO;
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
    
    UIButton *changeButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [changeButton addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *changeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changeButton];
   
    if (self.power == YES) {
        self.navigationItem.rightBarButtonItems = @[changeButtonItem,deleteButtonItem];
    }else{

    }
    
    if (self.entity) {
        self.groupName = self.CompEntity.name;
        self.address = self.CompEntity.address;
        self.MemberCustId = self.entity.MemberCustId;
        self.name = self.entity.CustName;
        self.tel = self.entity.ServiceNum;
        self.kind = self.entity.MemberKind;
        self.job = self.entity.job;
    }
    
    self.title = @"成员信息";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (self.changeClick == NO) {
        num = 7;
    }
    if (self.changeClick == YES) {
        num = 8;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
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
    static NSString *CellIdentifier2 = @"ButtonTableViewCell";
    static NSString *CellIdentifier3 = @"LineTwoLabelTableViewCell";
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.txtField.tag = indexPath.row;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    if (self.changeClick == NO) {
        cell.txtField.userInteractionEnabled = NO;
    }else{
        cell.txtField.userInteractionEnabled = YES;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier3 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = @"集团名称：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.groupName];
            
            return cell1;
            break;
        }
        case 1:
        {
            
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier3 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = @"集团地址：";
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.address];
            
            return cell1;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"工      号：";
            cell.txtField.text = self.MemberCustId;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"姓      名：";
            cell.txtField.text = self.name;
            
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"职      务：";
            cell.txtField.text = self.job;
            [cell.txtField becomeFirstResponder];
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"电       话：";
            cell.txtField.text = self.tel;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"成员种类：";
            if ([self.kind isEqualToString:@"1"]) {
                cell.txtField.text = @"网内成员";
            }else if ([self.kind isEqualToString:@"3"]){
                cell.txtField.text = @"网外成员";
            }else{
               
            }
            break;
        }
       default:
            break;
    }
    
    if (indexPath.row == 7) {
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.button.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
        [cell.button setTitle:@"保 存" forState:UIControlStateNormal];
        cell.button.tag = 2;
        [cell.button addTarget:self action:@selector(holdBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 |
        textField.tag == 2 |
        textField.tag == 5 |
        textField.tag == 6){
        return NO;
    }
    if (textField.tag == 3) {
        if ([self.kind isEqualToString:@"3"]) {
            return YES;
        }else if ([self.kind isEqualToString:@"1"]){
            return NO;
        }else{
            return NO;
        }
    }
//    else if (textField.tag == 6){
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"成员种类"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"网内成员",@"网外成员"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.kind = @"1";
//                                     }else if(buttonIndex == 1){
//                                         self.kind = @"3";
//                                     }
//                                     
//                                     [__tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 3:
        {
            self.name = textField.text;
            break;
        }
        case 4:
        {
            self.job = textField.text;
            break;
        }
//        case 5:
//        {
//            self.tel = textField.text;
//            break;
//        }
//        case 6:
//        {
//            if ([textField.text isEqualToString:@"网内成员"]) {
//                self.kind  = @"1";
//            }else if ([textField.text isEqualToString:@"网外成员"]){
//                self.kind  = @"3";
//            }
//            break;
//        }
        default:
            break;
    }
}

- (void)holdBtn:(UIButton *)sender{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    NSDictionary *dict;

    dict = @{@"method":@"update_client",
             @"oicode":@"edit",
             @"user_id":userEntity.user_id,
             @"c_type":@"2",
             @"GroupId":self.entity.GroupId,
             @"CustId":self.entity.MemberCustId,
             @"user_num":userEntity.num,
             @"MemberKind":self.kind,
             @"CustName":self.name,
             @"ServiceNum":self.tel,
             @"Job":self.job?self.job:@"",
             };

    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];

           
        }
        else
        {
            NSNumber *state = [entity valueForKeyPath:@"state"];
            NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
            if ([strState isEqualToString:@"0"] == YES) {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
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

                dict = @{@"method":@"update_client",
                         @"oicode":@"delete",
                         @"user_id":userEntity.user_id,
                         @"c_type":@"2",
                         @"GroupId":self.entity.GroupId,
                         @"CustId":self.entity.MemberCustId,
                         @"user_num":userEntity.num,
                         @"ServiceNum":self.entity.ServiceNum,
                         @"MemberKind":self.kind,
                         };

            
            [service getNetWorkData:dict  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                if ([strState isEqualToString:@"1"] == YES) {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    }];
                  
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


- (void)changeAction:(UIButton *)sender{
    
    self.changeClick = YES;
    [__tableView reloadData];
}

-(void)TextFieldEndEdited:(UITextField *)TextField
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
