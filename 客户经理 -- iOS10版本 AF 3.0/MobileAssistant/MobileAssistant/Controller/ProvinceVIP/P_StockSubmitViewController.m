//
//  P_StockSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_StockSubmitViewController.h"
#import "ThreeLabelsTableViewCell.h"
#import "CustomerViewController.h"
#import "UIActionSheet+Block.h"
#import "UIAlertView+Blocks.h"
#import "P_AddDevicesViewController.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define COMPANY_TABLE_INDEX 2 //集团单位
#define COMPANY_NUM_TABLE_INDEX 3 //集团编号
#define REFUND_REASON_TABLE_INDEX 4 //退库原因
#define REFUND_REMAEKS_TABLE_INDEX 5 //订货类型
#define DEVICE_TYPE_TABLE_INDEX 6 //机型

@interface P_StockSubmitViewController ()<UITextFieldDelegate,
                                          CustomerViewControllerDelegate,
                                          AddDevicesViewControllerDelegate>

///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///退库原因
@property(nonatomic, copy) NSString *refund_reason;

///备注
@property(nonatomic, copy) NSString *refund_remarks;

///机型
@property(nonatomic, copy) NSString *refund_info;

@end

@implementation P_StockSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"终端退库";
    
    if (self.detailDict) {
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.refund_reason = self.detailDict[@"refund_reason"];
        self.refund_remarks = self.detailDict[@"refund_remarks"];
        self.refund_info = self.detailDict[@"refund_info"];
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
    }else if (self.refund_reason.length == 0){
        msg = @"退库原因不能为空";
    }else if (self.refund_remarks.length == 0){
        msg = @"备注不能为空";
    }else if (self.refund_info.length == 0){
        msg = @"退库的机型不能为空";
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
    
    [dict setObject:@"5" forKey:@"type_id"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:self.company forKey:@"title"];
    
    [dict setObject:self.refund_info forKey:@"refund_info"];
    
    [dict setObject:self.refund_reason forKey:@"refund_reason"];
    
    [dict setObject:self.refund_remarks forKey:@"refund_remarks"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"type_id":@"5",
//                           @"company_name":self.company,
//                           @"company_num":self.company_num,
//                           @"title":self.company,
//                           @"refund_info":self.refund_info,
//                           @"refund_reason":self.refund_reason,
//                           @"refund_remarks":self.refund_remarks,
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        rows = 7;
    }else{
        NSArray *arr = [self.refund_info componentsSeparatedByString:@";"];
        
        rows = [arr count]>0?[arr count]+1:0;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    static NSString *identifier1 = @"ThreeLabelsTableViewCell";
    
    if (indexPath.section == 0) {
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
            case COMPANY_TABLE_INDEX:
            {
                cell.titleLbl.text = @"集团单位";
                cell.txtField.placeholder = @"请选择集团单位";
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
            case REFUND_REASON_TABLE_INDEX:
            {
                cell.titleLbl.text = @"退库原因";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.refund_reason;
                break;
            }
            case REFUND_REMAEKS_TABLE_INDEX:
            {
                cell.titleLbl.text = @"备       注";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.refund_remarks;
                break;
            }
            case DEVICE_TYPE_TABLE_INDEX:
            {
                cell.titleLbl.text = @"机       型";
                cell.txtField.placeholder = @"请输入机型";
                cell.txtField.text = nil;
                break;
            }
            default:
                break;
        }
        
        return cell;
    }else{
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"需求机型";
            cell.middleLbl.text = @"数量";
            cell.rightLbl.text = @"颜色";
        }else{
            NSArray *deviceArr = [self.refund_info componentsSeparatedByString:@";"];
            NSString *deviceStr = deviceArr[indexPath.row-1];
            
            NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
            if (infoArr.count >= 3) {
                cell.leftLbl.text = infoArr[0];
                cell.middleLbl.text = infoArr[1];
                cell.rightLbl.text = infoArr[2];
            }
        }
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 1 && self.refund_info) {
        title = @"机型列表";
    }
    
    return title;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == USER_NAME_TABLE_INDEX |
        textField.tag == USER_DEP_TABLE_INDEX |
        textField.tag == COMPANY_NUM_TABLE_INDEX){
        return NO;
    }else if(textField.tag == COMPANY_TABLE_INDEX){ //集团单位
        
        [self.view endEditing:YES];
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if (textField.tag == DEVICE_TYPE_TABLE_INDEX){ //机型
        
        P_AddDevicesViewController *vc = [[P_AddDevicesViewController alloc] init];
        vc.device_info = self.refund_info;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
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
        case REFUND_REASON_TABLE_INDEX:
        {
            self.refund_reason = textField.text;
            break;
        }
        case REFUND_REMAEKS_TABLE_INDEX:
        {
            self.refund_remarks = textField.text;
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
    
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:COMPANY_TABLE_INDEX inSection:0],\
                                         [NSIndexPath indexPathForRow:COMPANY_NUM_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - AddDevicesViewControllerDelegate

- (void)addDevicesViewController:(P_AddDevicesViewController *)vc addDevicesInfo:(NSString *)info
{
    self.refund_info = info;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
              withRowAnimation:UITableViewRowAnimationNone];
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
