//
//  Business_Add_Group_V_NetContactViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/24.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Add_Group_V_NetContactViewController.h"
#import "MBProgressHUD.h"
#import "LineTwoLabelTableViewCell.h"
#import "HightTableViewCell.h"
#import "phone.h"

@interface Business_Add_Group_V_NetContactViewController ()<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
    HightTableViewCell *cell2;
    NSMutableArray *detailMuArr;
    NSTimer *timer1;
    int count;
}

///电话
@property(nonatomic, copy) NSString *tel;
///指令短号
@property(nonatomic, copy) NSString *ShortNum;

@end

@implementation Business_Add_Group_V_NetContactViewController

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
    self.title = @"成员信息";
    self.output.alpha = 0;
    
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"V网编号：",      @"num":@"0",    @"type":@"Text"},
                   @{@"title":@"V网名称：",      @"num":@"1",    @"type":@"Text"},
                   @{@"title":@"电      话：",  @"num":@"2",    @"type":@"Text"},
                   @{@"title":@"指令短号：",      @"num":@"3",   @"type":@"Text"},
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
    static NSString *identifier2 = @"HightTableViewCell";
    
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
        
        switch (indexPath.row) {
            case 0:
            {
                
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
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.VpmnId];
                
                return cell1;
                
                break;
            }
            case 1:
            {
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
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.VpmnName];
                
                return cell1;
                break;
            }
            case 2:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请输入手机号码";
                break;
            }

            case 3:
            {
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"不填时由Boss自动分配(短号首位必须为5~8,第二位必须为1~9，长度必须为6)";
                cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if(!cell2)
                {
                    cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
                    cell2.txtView.delegate = self;
                    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell2.txtView.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
                cell2.txtView.layer.borderWidth = 0.5;
                cell2.txtView.layer.cornerRadius = 6;
                cell2.txtView.layer.masksToBounds = YES;
                cell2.txtView.returnKeyType = UIReturnKeyDone;
                cell2.titleLbl.text = title;
                cell2.placeholderLabel.textColor = RGBA(242, 242, 244, 1);
                cell2.placeholderLabel.enabled = NO;
                return cell2;
                break;
            }
        }
    }
    return cell;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [cell2.placeholderLabel setHidden:NO];
    }else{
        [cell2.placeholderLabel setHidden:YES];
       
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
     self.ShortNum = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {

        case 2:
        {
            self.tel = textField.text;
            break;
        }
//        case 3:
//        {
//            self.ShortNum = textField.text;
//            break;
//        }
        default:
            break;
    }
}

- (void)submitBtnClicked:(id)sender{
    
    [self.view endEditing:YES];
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmm"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    if (self.tel.length == 0) {
        ALERT_ERR_MSG(@"请填写电话");
        
        return;
    }
    
    if (self.ShortNum.length > 0) {
        if (self.ShortNum.length == 6) {
            if ([self.ShortNum substringWithRange:NSMakeRange(0, 1)].intValue >= 5 && [self.ShortNum substringWithRange:NSMakeRange(0, 1)].intValue < 9) {
                if ([self.ShortNum substringWithRange:NSMakeRange(1, 1)].intValue > 0 && [self.ShortNum substringWithRange:NSMakeRange(0, 1)].intValue < 10) {
                    
                }else{
                    ALERT_ERR_MSG(@"短号格式不对");
                    return;
                }
            }else{
                ALERT_ERR_MSG(@"短号格式不对");
                return;
            }
        }else{
            ALERT_ERR_MSG(@"短号格式不对");
            return;
        }
       
    }
    
    if (self.ShortNum.length == 0) {
        self.ShortNum = @"";
    }
    
    static NSString *phoneNum;
    static NSString *date;
    static NSString *type;
    
    phone *save = [[phone alloc]init];
    
    [save readToPlist:^(NSMutableDictionary *saveDic) {
        
        phoneNum = [saveDic objectForKey:@"phoneNum"];
        date = [saveDic objectForKey:@"date"];
        type = [saveDic objectForKey:@"type"];
    }];
    if ([type isEqualToString:@"1"]) {
        if([phoneNum isEqualToString:self.tel]) {
            double i = [locationString doubleValue];
            double j = [date doubleValue];
            if ((i - j) < 2) {
                ALERT_ERR_MSG(@"不可重复提交！");
                return;
            }else{
                
            }
        }else{
            
        }
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_UpdateVpmnMember",
                           @"user_id":userEntity.user_id,
                           @"OperType":@"0",
                           @"ServiceNum":self.tel,
                           @"VpmnId":self.entity.VpmnId,
                           @"ShortNum":self.ShortNum,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"-1"] == YES) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([strState isEqualToString:@"1"] == YES)
        {
            NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
            
            [userDic setObject:self.tel forKey:@"phoneNum"];
            [userDic setObject:locationString forKey:@"date"];
            [userDic setObject:@"1" forKey:@"type"];
            __block NSString *infoStr;
            
            [save saveToPlist:userDic andSuccess:^(NSString *successInfo) {
                infoStr = successInfo;
            }];
            
            
//            NSDictionary *content = entity[@"content"];
            NSString *msg = [NSString stringWithFormat:@"受理成功,正在处理,请稍等"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
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

//- (void)addCustor{
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    
//    CommonService *service = [[CommonService alloc] init];
//    phone *save = [[phone alloc]init];
//    NSDate *  senddate=[NSDate date];
//    
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    
//    [dateformatter setDateFormat:@"YYYYMMddHHmm"];
//    
//    NSString *locationString=[dateformatter stringFromDate:senddate];
//
//    NSDictionary *dict = @{@"method":@"whole_province",
//                           @"oicode":@"OI_UpdateVpmnMember",
//                           @"OperType":@"0",
//                           @"ServiceNum":self.tel,
//                           @"VpmnId":self.entity.VpmnId,
//                           @"ShortNum":self.ShortNum,
//                           };
//    
//    [service getNetWorkData:dict  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        if ([strState isEqualToString:@"-1"] == YES) {
//            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else if([strState isEqualToString:@"1"] == YES)
//        {
//            NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
//            
//            [userDic setObject:self.tel forKey:@"phoneNum"];
//            [userDic setObject:locationString forKey:@"date"];
//            __block NSString *infoStr;
//            
//            [save saveToPlist:userDic andSuccess:^(NSString *successInfo) {
//                infoStr = successInfo;
//            }];
//            
//            
//            NSDictionary *content = entity[@"content"];
//            NSString *msg = [NSString stringWithFormat:@"受理成功,正在处理,请稍等"];
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
////                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//            }];
//        }else if([strState isEqualToString:@"0"] == NO){
//            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        [HUD hide:YES];
//    } Failed:^(int errorCode, NSString *message) {
//        [HUD hide:YES];
//    }];
//    
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 ){
        return NO;
    }
    return YES;
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
   
}



@end
