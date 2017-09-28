//
//  Business_Add_Coloring_RingViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/28.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Add_Coloring_RingViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "phone.h"

@interface Business_Add_Coloring_RingViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
    NSMutableArray *detailMuArr;
    NSTimer *timer1;
    int count;
}

///集团名称
@property(nonatomic, copy) NSString *GroupName;
///计费号
@property(nonatomic, copy) NSString *GroupBillId;
///电话
@property(nonatomic, copy) NSString *MemBillId;

@end


@implementation Business_Add_Coloring_RingViewController

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
    self.title = @"添加彩铃成员";
    
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
                   @{@"title":@"计 费 号 ：",      @"num":@"1",    @"type":@"Text"},
                   @{@"title":@"电       话：",   @"num":@"2",   @"type":@"Text"},
                   nil];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailMuArr count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
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
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.entity.name];
                
                return cell1;
                
                break;
            }
            case 1:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = self.BillId;
                cell.txtField.userInteractionEnabled = NO;
                break;
            }
            case 2:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请输入手机号码";
                break;
            }
        }
    }
    return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {

        case 2:
        {
            self.MemBillId = textField.text;
            break;
        }
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
    
    if (self.MemBillId.length == 0) {
        ALERT_ERR_MSG(@"请填写电话");
        
        return;
    }

    
    if (self.MemBillId.length != 11) {
        ALERT_ERR_MSG(@"请检查电话号码格式！");
        
        return;
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
    if ([type isEqualToString:@"2"]) {
        if([phoneNum isEqualToString:self.MemBillId]) {
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
                           @"oicode":@"OI_GetGroupProductMember",
                           @"user_id":userEntity.user_id,
                           @"GroupId":self.entity.num,
                           @"OfferId":@"211290610001",
                           @"ServiceNum":self.MemBillId,
                           };
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if([strState isEqualToString:@"1"] == YES)
        {
            NSDictionary *dic = entity[@"content"];
            NSMutableArray *array = [dic objectForKey:@"MemberInfo"];
            if ([array count] > 0) {
                [HUD hide:YES];
                ALERT_ERR_MSG(@"成员已存在！");
                return ;
            }else{
                [HUD hide:YES];
                [self addCustor];
            }
            
        }else{
            [HUD hide:YES];
            [self addCustor];
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

- (void)addCustor{

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    phone *save = [[phone alloc]init];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmm"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    CommonService *service = [[CommonService alloc] init];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_DelaMemOrderGroupRingtones",
                           @"user_id":userEntity.user_id,
                           @"GroupBillId":self.BillId,
                           @"MemBillId":self.MemBillId,
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
            NSDictionary *dic = [entity valueForKeyPath:@"content"];
            if (dic) {
                NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
                
                [userDic setObject:self.MemBillId forKey:@"phoneNum"];
                [userDic setObject:locationString forKey:@"date"];
                [userDic setObject:@"2" forKey:@"type"];
                __block NSString *infoStr;
                
                [save saveToPlist:userDic andSuccess:^(NSString *successInfo) {
                    infoStr = successInfo;
                }];
                
//                NSString *msg = [NSString stringWithFormat:@"受理成功,当前流水号:\n%@",[dic objectForKey:@"DoneCode"]];
                NSString *msg = [NSString stringWithFormat:@"受理成功，已短信发送给客户"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
            
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
    
}



@end
