//
//  Business_StopOpenViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/15.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_StopOpenViewController.h"
#import "TxtFieldTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIActionSheet+Block.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"

@interface Business_StopOpenViewController ()<MBProgressHUDDelegate>
{
    TxtFieldTableViewCell *cell;
    MBProgressHUD *HUD;
    NSMutableArray *detailMuArr;
    NSMutableArray *array;
    NSString *OsStatus;
    int AdministrationNum;
    int BusinessNum;
    int AccountingNum;
    int StateTypeNum;
    int i;
    int Num2;
}
@end

@implementation Business_StopOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    OsStatus = @"0000000000000000000000000000000000000000000000000000000000000000";
    AdministrationNum = 0;
    BusinessNum = 0;
    AccountingNum = 0;
    StateTypeNum = 0;
    i = 0;
    [self initData];
    self.title = @"停开机";
}

- (void)initData
{
    
    int Num1 = [OsStatus substringWithRange:NSMakeRange(14,1)].intValue;
    Num2 = [OsStatus substringWithRange:NSMakeRange(15,1)].intValue;
    if (Num1 == 1 || Num2 == 1) {
        detailMuArr = [[NSMutableArray alloc] initWithObjects:
                       @{@"title":@"当前号码：",          @"type":@"Label"},
                       @{@"title":@"当前状态：",          @"type":@"Label"},
                       @{@"title":@"管理状态：",          @"type":@"Label"},
                       @{@"title":@"营业状态：",          @"type":@"Label"},
                       @{@"title":@"账务状态：",          @"type":@"Label"},
                       @{@"title":@"状态类型：",          @"type":@"Label"},
                       @{@"title":@"申请开机：",          @"type":@"Button"},
                       nil];
    }else{
        detailMuArr = [[NSMutableArray alloc] initWithObjects:
                       @{@"title":@"当前号码：",          @"type":@"Label"},
                       @{@"title":@"当前状态：",          @"type":@"Label"},
                       @{@"title":@"管理状态：",          @"type":@"Label"},
                       @{@"title":@"营业状态：",          @"type":@"Label"},
                       @{@"title":@"账务状态：",          @"type":@"Label"},
                       @{@"title":@"申请开机：",          @"type":@"Button"},
                       nil];
    }
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [detailMuArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"TxtFieldTableViewCell";
    static NSString *CellIdentifier2 = @"ButtonTableViewCell";

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.txtField.tag = indexPath.row;
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    NSString *type = dict[@"type"]; //类型

    if ([type isEqualToString:@"Label"]) {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.ServiceNum;
                break;
            }
            case 1:
            {
                cell.titleLbl.text = title;
                if ([OsStatus rangeOfString:@"1"].location != NSNotFound) {
                    cell.txtField.text = @"停机";
                }else{
                    cell.txtField.text = @"开机";
                }
                
                break;
            }
            case 2:
            {
                cell.titleLbl.text = title;
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                if (OsStatus.length > 25) {
//                    int Num = [OsStatus substringWithRange:NSMakeRange(25,1)].intValue;
                    if (AdministrationNum == 1) {
                        cell.txtField.text = @"管理停机";
                    }else{
                        cell.txtField.text = @"管理开机";
                    }
                    
                }
                if (self.Administration.length != 0) {
                    cell.txtField.text = self.Administration;
                    
                }
                break;
            }
            case 3:
            {
                cell.titleLbl.text = title;
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                if (OsStatus.length > 25) {
//                    int Num = [OsStatus substringWithRange:NSMakeRange(2,1)].intValue;
                    if (BusinessNum == 1) {
                        cell.txtField.text = @"营业停机";
                    }else{
                        cell.txtField.text = @"营业开机";
                    }
                    
                }
                if (self.Business.length != 0) {
                    cell.txtField.text = self.Business;
                    
                }
                break;
            }
            case 4:
            {
                cell.titleLbl.text = title;
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                if (OsStatus.length > 25) {
//                   int Num = [OsStatus substringWithRange:NSMakeRange(14,1)].intValue;
                    if (AccountingNum == 1 || Num2 == 1) {

                        cell.txtField.text = @"账务停机";
                    }else{
                        cell.txtField.text = @"账务开机";
                    }
                    
                }
                if (self.Accounting.length != 0) {
                    cell.txtField.text = self.Accounting;
                    
                }
                break;
            }
           
            default:
                break;
        }
        if ([detailMuArr count]== 7) {
            if (indexPath.row == 5) {
                 cell.titleLbl.text = title;
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                if (OsStatus.length > 25) {
//                    int Num = [OsStatus substringWithRange:NSMakeRange(15,1)].intValue;
                    if (StateTypeNum == 1) {
                        cell.txtField.text = @"呼出限制";
                    }else{
                        cell.txtField.text = @"财务停机";
                    }
                    
                }
                if (self.StateType.length != 0) {
                    cell.txtField.text = self.StateType;
                    
                }
            }
        }
        
    }
     if ([type isEqualToString:@"Button"]) {
         ButtonTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
         if (!cell2) {
             cell2 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
             cell2.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         cell2.button.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
         [cell2.button setTitle:@"申  请" forState:UIControlStateNormal];
         cell2.button.tag = 2;
         [cell2.button addTarget:self action:@selector(logoutBtn:) forControlEvents:UIControlEventTouchUpInside];
         return cell2;
     }
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 ){
        return NO;
    }else if(textField.tag == 2){ //
        [self.view endEditing:YES];
        if (BusinessNum == 1) {
            ALERT_ERR_MSG(@"你已经选择营业停机，不能再选择管理停机了");
            return NO;
        }else if(AccountingNum == 1){
            ALERT_ERR_MSG(@"你已经选择账务停机，不能再选择管理停机了");
            return NO;
        }
        
        [UIActionSheet showInView:self.view
                        withTitle:@"管理状态"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"管理复机",@"管理停机"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.Administration = @"管理复机";
                                     AdministrationNum = 0;
                                     BusinessNum = 0;
                                     AccountingNum = 0;
                                 }else if(buttonIndex == 1){
                                     self.Administration = @"管理停机";
                                     AdministrationNum = 1;
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
        
    }else if(textField.tag == 3){ //
        [self.view endEditing:YES];
        
        if (AdministrationNum == 1) {
            ALERT_ERR_MSG(@"你已经选择管理停机，不能再选择营业停机了");
            return NO;
        }else if(AccountingNum == 1){
            ALERT_ERR_MSG(@"你已经选择账务停机，不能再选择营业停机了");
            return NO;
        }
        
        [UIActionSheet showInView:self.view
                        withTitle:@"营业状态"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"营业复机",@"营业停机"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.Business = @"营业复机";
                                     BusinessNum = 0;
                                     AdministrationNum = 0;
                                     AccountingNum = 0;
                                 }else if(buttonIndex == 1){
                                     self.Business = @"营业停机";
                                     BusinessNum = 1;
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    }else if(textField.tag == 4){ //
        [self.view endEditing:YES];
        
        if (AdministrationNum == 1) {
            ALERT_ERR_MSG(@"你已经选择管理停机，不能再选择账务停机了");
            return NO;
        }else if(BusinessNum == 1){
            ALERT_ERR_MSG(@"你已经选择营业停机，不能再选择账务停机了");
            return NO;
        }
        
        [UIActionSheet showInView:self.view
                        withTitle:@"账务状态"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"账务复机",@"账务停机"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.Accounting = @"账务复机";
                                     AccountingNum = 0;
                                     AdministrationNum = 0;
                                     BusinessNum = 0;
                                     [detailMuArr removeObject:@{@"title":@"状态类型：",@"type":@"Label"}];
                                 }else if(buttonIndex == 1){
                                     self.Accounting = @"账务停机";
                                     AccountingNum = 1;
                                     [detailMuArr removeObject:@{@"title":@"状态类型：",@"type":@"Label"}];
                                     [detailMuArr insertObject:@{@"title":@"状态类型：",@"type":@"Label"} atIndex:detailMuArr.count-1];
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    }else if(textField.tag == 5){ //
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"状态类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"账务停机",@"呼出限制"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.StateType = @"账务停机";
                                     StateTypeNum = 0;
        
                                 }else if(buttonIndex == 1){
                                     self.StateType = @"呼出限制";
                                     StateTypeNum = 1;
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    }
    
    
    return YES;
}

- (void)logoutBtn:(UIButton *)sender{
    
    if(AdministrationNum == 0){
        
    }
    array = [NSMutableArray array];
    NSString *Administration = [NSString stringWithFormat:@"%d",AdministrationNum];
    NSString *Business = [NSString stringWithFormat:@"%d",BusinessNum];
    NSString *Accounting = [NSString stringWithFormat:@"%d",AccountingNum];
    
    if ([OsStatus substringWithRange:NSMakeRange(25,1)].intValue != AdministrationNum) {
        [array addObject:@{@"title":@"1", @"num":Administration}];
    }
    if ([OsStatus substringWithRange:NSMakeRange(2,1)].intValue != BusinessNum) {
        [array addObject:@{@"title":@"2", @"num":Business}];
    }
    if ([OsStatus substringWithRange:NSMakeRange(14,1)].intValue != AccountingNum) {
        [array addObject:@{@"title":@"3", @"num":Accounting}];
    }
    if (Accounting == 0 &&[OsStatus substringWithRange:NSMakeRange(15,1)].intValue == 1) {
        [array addObject:@{@"title":@"3", @"num":Accounting}];
    }

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"num" ascending:NO];
    
    NSArray *array3 = [[NSArray alloc]initWithObjects:&sort count:1];
   
    [array sortUsingDescriptors:array3];
    
    if ([array count] > 0) {
        i = [array count] -1;
        [self sort];
    }
    
}

- (void)sort{
    
    NSString *OsType;
    
    NSDictionary *dic = [array objectAtIndex:i];
    NSString *title = [dic objectForKey:@"title"];
    if ([title isEqualToString:@"1"]) {
        if (AdministrationNum == 0) {
            OsType = @"1";
        }else{
            OsType = @"0";
        }
    }else if ([title isEqualToString:@"2"]){
        if (BusinessNum == 0) {
            OsType = @"3";
        }else{
            OsType = @"2";
        }
    }else if ([title isEqualToString:@"3"]){
        if (AccountingNum == 0) {
            OsType = @"5";
        }else{
            OsType = @"4";
        }
    }
    
    [self upDate:OsType];
    
}

- (void)upDate:(NSString *)OsType{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"申请中...";
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    NSDictionary *dict = [[NSDictionary alloc]init];
    if ([OsType isEqualToString:@"4"]) {
        dict = @{
                 @"method":@"whole_province",
                 @"user_id":userEntity.user_id,
                 @"oicode":@"OI_StopOrStartUser",
                 @"ServiceNum":_ServiceNum,
                 @"OsType":OsType,
                 @"ZtType":[NSString stringWithFormat:@"%d",StateTypeNum],
                               };
    }else{
        dict = @{
                 @"method":@"whole_province",
                 @"oicode":@"OI_StopOrStartUser",
                 @"user_id":userEntity.user_id,
                 @"ServiceNum":_ServiceNum,
                 @"OsType":OsType,
                               };
    }
   
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSDictionary *dic = [entity valueForKeyPath:@"content"];
            if (dic) {
                NSString *msg = [NSString stringWithFormat:@"受理成功,当前流水号:\n%@",[dic objectForKey:@"DoneCode"]];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                i--;
                if (i >= 0) {
                    [self sort];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                }];
                [HUD hide:YES];
            }

        }
        else if([strState isEqualToString:@"-1"] == YES)
        {
            NSString *msgg = [entity valueForKeyPath:@"msg"];

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msgg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
            }];
            [HUD hide:YES];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
            ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
        }else{
//            ALERT_ERR_MSG(@"服务时间超时!");
        }
    }];
}

-(void)loadData{
    
    [self getData];
    
}

- (void) getData
{
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_GetUserNormalInfo",
                           @"user_id":userEntity.user_id,
                           @"ServiceNum":_ServiceNum,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
           NSMutableArray  *UserInfoArray = [[entity objectForKey:@"content"] objectForKey:@"UserInfo"];
            
            if (UserInfoArray) {
                OsStatus = [[UserInfoArray objectAtIndex:0] objectForKey:@"OsStatus"];
                AdministrationNum = [OsStatus substringWithRange:NSMakeRange(25,1)].intValue;;
                BusinessNum = [OsStatus substringWithRange:NSMakeRange(2,1)].intValue;;
                AccountingNum = [OsStatus substringWithRange:NSMakeRange(14,1)].intValue;;
                StateTypeNum = [OsStatus substringWithRange:NSMakeRange(15,1)].intValue;
                [self initData];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            
        }
        
    } Failed:^(int errorCode, NSString *message) {

    }];
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
