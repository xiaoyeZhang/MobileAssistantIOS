//
//  P_BookSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BookSubmitViewController.h"
#import "CustomerViewController.h"
#import "ContactViewController.h"
#import "UIActionSheet+Block.h"
#import "XYDatePicker.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define ACCOUNT_TYPE_TABLE_INDEX 2 //台账类型
#define COMPANY_TABLE_INDEX 3 //集团单位
#define COMPANY_NUM_TABLE_INDEX 4 //集团编号
#define CLIENT_NAME_TABLE_INDEX 5 //客户姓名
#define PHONE_TABLE_INDEX 6 //电话号码
#define ACCOUNT_COST_TABLE_INDEX 7 //缴费金额
#define ACCOUNT_PAY_TABLE_INDEX 8 //支付方式
#define ACCOUNT_REASON_TABLE_INDEX 9 //挂账理由

@interface P_BookSubmitViewController ()<UITextFieldDelegate,
                                         CustomerViewControllerDelegate,
                                         ContactViewControllerDelegate,
                                         XYDatePickerDelegate>

///台账类型 话费、统付、终端
@property(nonatomic, copy) NSString *account_type;

///集团单位
@property(nonatomic, copy) NSString *company;

///单位编号
@property(nonatomic, copy) NSString *company_num;

///缴费姓名
@property(nonatomic, copy) NSString *client_name;

///电话号码(缴费账号) 话费：电话号码  统付/终端:缴费账号
@property(nonatomic, copy) NSString *account_num;

///缴费金额
@property(nonatomic, copy) NSString *account_cost;

///支付方式 挂账(需填挂账理由)、POS、回执单、现金
@property(nonatomic, copy) NSString *account_pay;

///挂账理由 当支付方式仅为挂账时需要填写 否则置空
@property(nonatomic, copy) NSString *account_reason;

///转账日期 当支付方式仅为对公转账时需要填写 否则置空
@property(nonatomic, copy) NSString *transfer_date;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@end

@implementation P_BookSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"缴费台账登记";
    super.model = NSStringFromClass([self class]);
    self.account_type = @"话费";
    self.account_pay = @"挂账";
    
    if (self.detailDict) {
        self.account_type = self.detailDict[@"account_type"];
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.client_name = self.detailDict[@"client_name"];
        self.account_num = self.detailDict[@"account_num"];
        self.account_cost = self.detailDict[@"account_cost"];
        self.account_pay = self.detailDict[@"account_pay"];
    }
}

#pragma mark - UIButtonMethod

//提交
- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    if(self.company.length == 0){
        msg = @"请选择集团单位";
    }else if (self.client_name.length == 0){
        msg = @"请填写缴费姓名";
    }else if (self.account_num.length == 0){
        msg = @"请填写缴费账号";
    }else if (self.account_cost.length == 0){
        msg = @"请填写缴费金额";
    }else if (self.account_reason.length == 0){
        if ([self.account_pay isEqualToString:@"挂账"]) {
            msg = @"请填写挂账理由";
        }
    }
    
    if ([self.account_pay isEqualToString:@"对公转账"] && self.transfer_date.length == 0) {
        msg = @"请选择转账日期";
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    
    [dict setObject:userInfo.user_id forKey:@"create_id"];
    
    [dict setObject:[self.account_pay isEqualToString:@"挂账"]?([self.account_cost intValue]>3000?@"8":@"16"):@"9" forKey:@"type_id"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@",self.company,self.account_cost] forKey:@"title"];
    
    [dict setObject:self.client_name forKey:@"client_name"];
    
    [dict setObject:self.account_type forKey:@"account_type"];
    
    [dict setObject:self.account_cost forKey:@"account_cost"];
    
    [dict setObject:self.account_num forKey:@"account_num"];
    
    [dict setObject:self.account_pay forKey:@"account_pay"];
    
    [dict setObject:[self.account_pay isEqualToString:@"挂账"]?(self.account_reason?self.account_reason:@""):@"" forKey:@"account_reason"];
    
    [dict setObject:self.transfer_date?self.transfer_date:@"" forKey:@"transfer_date"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"type_id":[self.account_pay isEqualToString:@"挂账"]?([self.account_cost intValue]>3000?@"8":@"16"):@"9",
//                           @"company_name":self.company,
//                           @"company_num":self.company_num,
//                           @"title":[NSString stringWithFormat:@"%@,%@",self.company,self.account_cost],
//                           @"client_name":self.client_name,
//                           @"account_type":self.account_type,
//                           @"account_cost":self.account_cost,
//                           @"account_num":self.account_num,
//                           @"account_pay":self.account_pay,
//                           @"account_reason":[self.account_pay isEqualToString:@"挂账"]?(self.account_reason?self.account_reason:@""):@"",
//                           @"business_id":self.bListModel?self.bListModel.business_id:@"",
//                           @"transfer_date":self.transfer_date?self.transfer_date:@""};

    
    [self get_three_list:[dict objectForKey:@"type_id"] Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:dict];
        }else{
            
            [self goSumbitData:dict];
        }
        isDone = YES;
    }];
    
    
//    CommonService *service = [[CommonService alloc] init];
//
//    [service getNetWorkData:dict  Successed:^(id entity) {
//        
//        int state = [entity[@"state"] intValue];
//        
//        if (state == 1) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//            }];
//        }else{
//            ALERT_ERR_MSG(@"提交失败");
//        }
//        isDone = YES;
//    } Failed:^(int errorCode, NSString *message) {
//        ALERT_ERR_MSG(message);
//        isDone = YES;
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.account_pay isEqualToString:@"挂账"] |
        [self.account_pay isEqualToString:@"对公转账"]) {
        return 10;
    }else{
        return 9;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    switch (indexPath.row) {
        case USER_NAME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"客户经理";
            cell.txtField.placeholder = nil;
            cell.txtField.text = userInfo.name;
            
            break;
        }
        case USER_DEP_TABLE_INDEX:
        {
            cell.titleLbl.text = @"申请部门";
            cell.txtField.placeholder = nil;
            cell.txtField.text = userInfo.dep_name;
            break;
        }
        case ACCOUNT_TYPE_TABLE_INDEX:
        {
            cell.titleLbl.text = @"台账类型";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.account_type;
            break;
        }
        case COMPANY_TABLE_INDEX:
        {
            cell.titleLbl.text = @"集团单位";
            cell.txtField.placeholder = @"请选择集团单位名称";
            cell.txtField.text = self.company;
            break;
        }
        case COMPANY_NUM_TABLE_INDEX:
        {
            cell.titleLbl.text = @"集团编号";
            cell.txtField.placeholder = @"选择集团单位后自动生成";
            cell.txtField.text = self.company_num;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"缴费姓名";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.client_name;
            break;
        }
        case PHONE_TABLE_INDEX:
        {
            if ([self.account_type isEqualToString:@"话费"]) {
                cell.titleLbl.text = @"电话号码";
            }else{
                cell.titleLbl.text = @"缴费账号";
            }
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.account_num;
            break;
        }
        case ACCOUNT_COST_TABLE_INDEX:
        {
            cell.titleLbl.text = @"缴费金额";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.account_cost;
            break;
        }
        case ACCOUNT_PAY_TABLE_INDEX:
        {
            cell.titleLbl.text = @"支付方式";
            cell.txtField.placeholder = nil;
            
            if ([userInfo.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                cell.txtField.text = @"挂账";
            }else{
                cell.txtField.text = self.account_pay;
            }
            break;
        }
        case ACCOUNT_REASON_TABLE_INDEX:
        {
            if ([self.account_pay isEqualToString:@"挂账"]) {
                cell.titleLbl.text = @"挂账理由";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.account_reason;
            }else if([self.account_pay isEqualToString:@"对公转账"]){
                cell.titleLbl.text = @"转账日期";
                cell.txtField.placeholder = @"请选择";
                cell.txtField.text = self.transfer_date;
            }
            
            break;
        }
        default:
            break;
    }
    
    if (indexPath.row == ACCOUNT_COST_TABLE_INDEX) {
        cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        cell.txtField.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    UserEntity *userinfo = [UserEntity sharedInstance];
    if (textField.tag == USER_NAME_TABLE_INDEX |
        textField.tag == USER_DEP_TABLE_INDEX |
        textField.tag == COMPANY_NUM_TABLE_INDEX){
        return NO;
    }else if (textField.tag == ACCOUNT_TYPE_TABLE_INDEX){ //台账类型
        
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"台账类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"话费",@"统付",@"终端"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.account_type = @"话费";
                                 self.account_num = self.selectedComEntitiy.tel;
                             }else if(buttonIndex == 1){
                                 self.account_type = @"统付";
                                 self.account_num = nil;
                             }else if(buttonIndex == 2){
                                 self.account_type = @"终端";
                                 self.account_num = nil;
                             }
                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ACCOUNT_TYPE_TABLE_INDEX inSection:0],[NSIndexPath indexPathForRow:PHONE_TABLE_INDEX inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationFade];
                             
                         }];
        
        return NO;
        
    } else if(textField.tag == COMPANY_TABLE_INDEX){ //集团单位
        
        [self.view endEditing:YES];
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if (textField.tag == CLIENT_NAME_TABLE_INDEX){ //姓名
        
//        [self.view endEditing:YES];
//        
//        ContactViewController *vc = [[ContactViewController alloc] init];
//        vc.compEntity = self.selectedComEntitiy;
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return NO;
        
        return YES;
    }else if (textField.tag == ACCOUNT_PAY_TABLE_INDEX){ //支付方式
        
        [self.view endEditing:YES];
        if ([userinfo.dep_id rangeOfString:@"10007"].location != NSNotFound) {
            
        }else{
            [UIActionSheet showInView:self.view
                            withTitle:@"支付方式"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"挂账",@"POS",@"回执单",@"现金",@"对公转账"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex == 0) {
                                     self.account_pay = @"挂账";
                                     
                                     self.transfer_date = nil;
                                 }else if(buttonIndex == 1){
                                     self.account_pay = @"POS";
                                     
                                     self.transfer_date = nil;
                                 }else if(buttonIndex == 2){
                                     self.account_pay = @"回执单";
                                     
                                     self.transfer_date = nil;
                                 }else if(buttonIndex == 3){
                                     self.account_pay = @"现金";
                                     
                                     self.transfer_date = nil;
                                 }else if(buttonIndex == 4){
                                     self.account_pay = @"对公转账";
                                 }
                                 [_tableView reloadData];
                                 
                             }];
            
           
        }
         return NO;
    }else if(textField.tag == ACCOUNT_REASON_TABLE_INDEX){ //挂账理由或转账日期
        if ([self.account_pay isEqualToString:@"对公转账"]) {
            
            [self.view endEditing:YES];
            
            //预回款日期
            XYDatePicker *datePicker = [XYDatePicker datePicker];
            datePicker.delegate = self;
            [datePicker show];
            
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case PHONE_TABLE_INDEX:
        {
            self.account_num = textField.text;
            break;
        }
        case ACCOUNT_COST_TABLE_INDEX:
        {
            self.account_cost = textField.text;
            break;
        }
        case ACCOUNT_REASON_TABLE_INDEX:
        {
            self.account_reason = textField.text;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            self.client_name = textField.text;
            break;
        }
        default:
            break;
    }
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    self.company_num = entity.num;
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:COMPANY_TABLE_INDEX inSection:0],\
                                         [NSIndexPath indexPathForRow:COMPANY_NUM_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - ContactViewControllerDelegate

- (void)contactViewController:(ContactViewController *)vc didSelectClient:(ContactEntity *)entity
{
    self.client_name = entity.name;
    
    if ([self.account_type isEqualToString:@"话费"]) {
        self.account_num = entity.tel;
    }else{
        self.account_num = nil;
    }
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CLIENT_NAME_TABLE_INDEX inSection:0],[NSIndexPath indexPathForRow:PHONE_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.transfer_date = [dateFormatter stringFromDate:datePicker.date];
    
    [_tableView reloadData];
}

- (void)showSIAlertView:(NSArray *)arr andWithDict:(NSMutableDictionary *)dic{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"下级执行人" andMessage:@""];
    
    for (int i = 0; i < arr.count; i++) {
        
        [alertView addButtonWithTitle:[arr[i] objectForKey:@"name"]
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  NSLog(@"Button1 Clicked:%@",[arr[i] objectForKey:@"name"]);
                                  
                                  [dic setObject:[arr[i] objectForKey:@"user_id"] forKey:@"next_processor"];
                                  
                                  [self goSumbitData:dic];
                              }];
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler", alertView);
        };
        
    }
    [alertView addButtonWithTitle:@"取   消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    [alertView show];
    
}

- (void)goSumbitData:(NSMutableDictionary *)dict{
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }

    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);

    }];
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
