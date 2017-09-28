//
//  Business_ContactAddViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_ContactAddViewController.h"
#import "CheckBoxTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "LineTwoLabelTableViewCell.h"

@interface Business_ContactAddViewController ()<CheckBoxTableViewCellDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
    NSMutableArray *detailMuArr;
    NSTimer *timer1;
    int count;
}
///成员种类
@property(nonatomic, copy) NSString *kind;
///姓名
@property(nonatomic, copy) NSString *name;
///职务
@property(nonatomic, copy) NSString *job;
///电话
@property(nonatomic, copy) NSString *tel;
///性别
@property(nonatomic, copy) NSString *sex;

@end

@implementation Business_ContactAddViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

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
    
    [self initData];
    self.output.alpha = 0;
    self.title = @"添加集团成员";
    
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
                   @{@"title":@"集团地址：",      @"num":@"1",    @"type":@"Text"},
                   @{@"title":@"成员种类：",      @"num":@"2",    @"type":@"Text"},
                   @{@"title":@"职       务：",   @"num":@"3",   @"type":@"Text"},
                   @{@"title":@"电       话：",   @"num":@"4",   @"type":@"Text"},
                   nil];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailMuArr count];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    cell.txtField.textAlignment = NSTextAlignmentCenter;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    NSString *type = dict[@"type"]; //类型

    if ([type isEqualToString:@"Text"]) {
        cell.downArrowImageView.image = [UIImage imageNamed:@"c_down"];
        
        switch (indexPath.row) {
            case 0:
            {
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.Compentity.name;
                
                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(!cell1)
                {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell1.titLabel.text = title;
                cell1.subTitleLbl.layer.borderWidth = 0.5;
                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
                cell1.subTitleLbl.layer.cornerRadius = 6;
                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.Compentity.name];
                
                return cell1;
                
                break;
            }
            case 1:
            {
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.Compentity.address;
                
                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(!cell1)
                {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell1.titLabel.text = title;
                cell1.subTitleLbl.layer.borderWidth = 0.5;
                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
                cell1.subTitleLbl.layer.cornerRadius = 6;
                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.Compentity.address];
                
                return cell1;
                break;
            }
            case 2:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                cell.txtField.text = self.kind;
                break;
            }
            //        case 3:
            //        {
            //            cell.titleLbl.text = @"姓       名：";
            //            cell.txtField.placeholder = nil;
            //            break;
            //        }
            case 3:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                break;
            }
            case 4:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                break;
            }
        }
    }
    if ([type isEqualToString:@"Change"]) {
        if (indexPath.row == 5) {
            cell.titleLbl.text = title;
            cell.txtField.placeholder = nil;
        }
    }
    
        return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
//        case 3:
//        {
//            self.name = textField.text;
//            break;
//        }
        case 3:
        {
            self.job = textField.text;
            break;
        }
        case 4:
        {
            self.tel = textField.text;
            break;
        }
        default:
            break;
    }
    if ([detailMuArr count] == 6) {
        if (textField.tag == 5) {
            self.name = textField.text;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 ){
        return NO;
    }else if (textField.tag == 2){
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"成员种类"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"网内成员",@"网外成员"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.kind = @"网内成员";
                                     [detailMuArr removeObject:@{@"title":@"姓       名：",@"type":@"Change"}];
                                 }else if(buttonIndex == 1){
                                     self.kind = @"网外成员";
                                     [detailMuArr addObject:@{@"title":@"姓       名：",@"type":@"Change"}];
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    }
//    else if(textField.tag == 6){ //集团单位
//        [self.view endEditing:YES];
//        [UIActionSheet showInView:self.view
//                        withTitle:@"性别"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"男",@"女",@"其他"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 if (buttonIndex == 0) {
//                                     self.sex = @"男";
//                                 }else if(buttonIndex == 1){
//                                     self.sex = @"女";
//                                 }else if(buttonIndex == 2){
//                                     self.sex = @"其他";
//                                 }
//                                 
//                                 [_tableView reloadData];
//                             }
//                             
//                         }];
//
//        return NO;
//    }
    return YES;
}

- (void)submitBtnClicked:(id)sender{
    
    [self.view endEditing:YES];
    
    if (self.kind.length == 0) {
        ALERT_ERR_MSG(@"请选择成员种类");
        
        return;
    }
    
//    if (self.job.length == 0) {
//        ALERT_ERR_MSG(@"请填写职务");
//        
//        return;
//    }
    if (self.tel.length == 0) {
        ALERT_ERR_MSG(@"请填写电话");

        return;
    }
    
    if ([detailMuArr count] == 6) {
        if (self.name.length == 0) {
            ALERT_ERR_MSG(@"请填写姓名");
            
            return;
        }
    }
   
    if (self.tel.length != 11) {
        ALERT_ERR_MSG(@"请检查电话号码格式！");
        
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSString *kindNum = nil;

    if ([self.kind isEqualToString:@"网内成员"]) {
        kindNum = @"1";
    }else if ([self.kind isEqualToString:@"网外成员"]){
        kindNum = @"3";
    }

    
    NSDictionary *dict = @{@"method":@"update_client",
                           @"oicode":@"add",
                           @"user_id":userEntity.user_id,
                           @"GroupId":self.Compentity.num,
                           @"MemberKind":kindNum,
                           @"c_type":@"2",
                           @"user_num":userEntity.num,
                           @"CustName":self.name?self.name:@"",
                           @"ServiceNum":self.tel,
                           @"Job":self.job?self.job:@"",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        NSString *msg = [entity valueForKeyPath:@"msg"];
        if ([strState isEqualToString:@"-1"] == YES) {

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([strState isEqualToString:@"1"] == YES)
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {

                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else if([strState isEqualToString:@"0"] == NO){
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
