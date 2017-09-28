//
//  Houston_querySubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Houston_querySubmitViewController.h"
#import "CustomerViewController.h"
#import "MBProgressHUD.h"
#import "XYDatePicker.h"
#import "UIActionSheet+Block.h"
#import "Houston_queryViewController.h"

@interface Houston_querySubmitViewController ()<XYDatePickerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,
CustomerViewControllerDelegate>
{
     MBProgressHUD *HUD;
}

///备注
@property(nonatomic, copy) NSString *remaks;

///集团单位
@property(nonatomic, copy) NSString *company;

///进账时间
@property(nonatomic, copy) NSString *Houston_time;

///金额
@property(nonatomic, copy) NSString *Houston_money;

@property(nonatomic, copy) NSString *type_id;

@property (copy, nonatomic) NSString *business_id;
@end

@implementation Houston_querySubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"进账查询";
    
    self.type_id = @"22";
    
    if (self.detailDict) {
        self.company = self.detailDict[@"customer_name"];
        self.Houston_time = self.detailDict[@"Houston_time"];
        self.Houston_money = self.detailDict[@"Houston_money"];
        self.remaks = self.detailDict[@"remarks"];
        self.business_id = self.bListModel.business_id;
    }
    
}

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
    }else if (self.Houston_time.length == 0){
        msg = @"请选择时间";
    }else if (self.Houston_money.length == 0){
        msg = @"请填写金额";
    }else if (self.remaks.length == 0){
        msg = @"请填写备注";
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
                           @"create_id":userInfo.user_id,
                           @"title":self.company,
                           @"type_id":self.type_id,
                           @"Houston_money":self.Houston_money,
                           @"customer_name":self.company,
                           @"Houston_time":self.Houston_time,
                           @"remarks":self.remaks,
                           @"recorded_image":@"",
                           @"business_id":self.bListModel?self.bListModel.business_id:@"",
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
     
                if ([self.typeNum isEqualToString:@"1"]) {
                    Houston_queryViewController *vc = [[Houston_queryViewController alloc]init];
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[vc class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                        
                    }
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
        isDone = YES;
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    UserEntity *userInfo = [UserEntity sharedInstance];
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"客户经理";
            cell.txtField.placeholder = nil;
            cell.txtField.text = userInfo.name;
            
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"集团单位";
            cell.txtField.text = self.company;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"进账时间";
            cell.txtField.placeholder = @"请选择时间";
            cell.txtField.text = self.Houston_time;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"金额";
            cell.txtField.text = self.Houston_money;
            break;
        }
        case 4:
        {
            
            cell.titleLbl.text = @"备注";
            cell.txtField.text = self.remaks;
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if(textField.tag == 1){
        [self.view endEditing:YES];
        
        //选择集团
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if(textField.tag == 2){
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            self.company = textField.text;
            break;
        }
        case 2:
        {
            self.Houston_time = textField.text;
            break;
        }
        case 3:
        {
            self.Houston_money = textField.text;
            break;
        }
        case 4:
        {
            self.remaks = textField.text;
            break;
        }
        default:
            break;
    }
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.Houston_time = dateStr;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
