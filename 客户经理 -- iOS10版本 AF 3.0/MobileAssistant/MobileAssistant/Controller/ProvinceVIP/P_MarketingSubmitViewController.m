//
//  P_MarketingSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/3.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "P_MarketingSubmitViewController.h"
#import "UIActionSheet+Block.h"
#import "CustomerViewController.h"

@interface P_MarketingSubmitViewController ()<UITextFieldDelegate,CustomerViewControllerDelegate>

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@end

@implementation P_MarketingSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"营销方案更改";
    self.type_id = @"18";
    
    if (self.detailDict) {
        self.activity_name = self.detailDict[@"activity_name"];
        self.company_name = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.client_name = self.detailDict[@"client_name"];
        self.tel_num = self.detailDict[@"tel_num"];
        self.take_time = self.detailDict[@"take_time"];
        self.complaint_reason = self.detailDict[@"complaint_reason"];
        self.change_mode = self.detailDict[@"change_mode"];
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
    if(self.activity_name.length == 0){
        msg = @"请填写活动名称及ID";
    }else if (self.company_name.length == 0){
        msg = @"请选择集团名称";
    }else if (self.client_name.length == 0){
        msg = @"请填写客户姓名";
    }else if (self.tel_num.length == 0){
        msg = @"请填写手机号";
    }else if (self.take_time.length == 0){
        msg = @"请选择客户参加活动时间";
    }else if (self.complaint_reason.length == 0){
        msg = @"请填写投诉原因";
    }else if (self.change_mode.length == 0){
        msg = @"请填写更改方式";
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
    
    [dict setObject:self.type_id forKey:@"type_id"];
    
    [dict setObject:self.company_name forKey:@"title"];
    
    [dict setObject:self.activity_name forKey:@"activity_name"];
    
    [dict setObject:self.company_name forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:self.client_name forKey:@"client_name"];
    
    [dict setObject:self.tel_num forKey:@"tel_num"];
    
    [dict setObject:self.take_time forKey:@"take_time"];
    
    [dict setObject:self.complaint_reason forKey:@"complaint_reason"];
    
    [dict setObject:self.change_mode forKey:@"change_mode"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"title":self.company_name,
//                           @"type_id":self.type_id,
//                           @"activity_name":self.activity_name,
//                           @"company_name":self.company_name,
//                           @"company_num":self.company_num,
//                           @"client_name":self.client_name,
//                           @"tel_num":self.tel_num,
//                           @"take_time":self.take_time,
//                           @"complaint_reason":self.complaint_reason,
//                           @"change_mode":self.change_mode,
//                           @"business_id":self.bListModel?self.bListModel.business_id:@""};
    
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
    return 10;
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
        case 0:
        {
            cell.titleLbl.text = @"客户经理";
            cell.txtField.text = userInfo.name;
            
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"申请部门";
            cell.txtField.text = userInfo.dep_name;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"活动名称及ID";
            cell.txtField.text = self.activity_name;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"单位名称";
            cell.txtField.placeholder = @"请选择单位名称";
            cell.txtField.text = self.company_name;
            break;
        }
        case 4:
        {
 
            cell.titleLbl.text = @"集团编号";
            cell.txtField.text = self.company_num;
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"客户姓名";
            cell.txtField.text = self.client_name;
            break;
        }
        case 6:
        {
            cell.titleLbl.text = @"手 机 号";
            cell.txtField.text = self.tel_num;
            break;
        }
        case 7:
        {
            cell.titleLbl.text = @"参加时间";
            cell.txtField.placeholder = @"请选择时间";
            cell.txtField.text = self.take_time;
            break;
        }
        case 8:
        {
            cell.titleLbl.text = @"投诉原因";
            cell.txtField.text = self.complaint_reason;
            break;
        }
        case 9:
        {
            cell.titleLbl.text = @"更改方式";
            cell.txtField.text = self.change_mode;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 |
        textField.tag == 4){
        return NO;
    }else if(textField.tag == 3){ //
        [self.view endEditing:YES];
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if(textField.tag == 7){ //
        [self.view endEditing:YES];
        
        //预约时间
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.take_time = dateStr;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 2:
        {
            self.activity_name = textField.text;
            break;
        }
        case 3:
        {
            self.company_name = textField.text;
            break;
        }
        case 4:
        {
            self.company_num = textField.text;
            break;
        }
        case 5:
        {
            self.client_name = textField.text;
            break;
        }
        case 6:
        {
            self.tel_num = textField.text;
            break;
        }
        case 7:
        {
            self.take_time = textField.text;
            break;
        }
        case 8:
        {
            self.complaint_reason = textField.text;
            break;
        }
        case 9:
        {
            self.change_mode = textField.text;
            break;
        }
        default:
            break;
    }
}

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company_name = entity.name;
    self.company_num = entity.num;
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0],\
                                         [NSIndexPath indexPathForRow:4 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
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
