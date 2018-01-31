//
//  P_TerminalStockSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalStockSubmitViewController.h"
//#import "P_TerminalStockLViewController.h"

@interface P_TerminalStockSubmitViewController ()//<TerminalStockLViewControllerDelegate>

@end

@implementation P_TerminalStockSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端出库";
    
//    if (!self.bListModel) {
//        P_TerminalStockLViewController *vc = [[P_TerminalStockLViewController alloc] init];
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:NO];
//    }
    
    [self getDetaiWithBusinessId:self.bListModel.business_id];
}

#pragma mark -

- (void)backBtnClicked:(id)sender
{
    if (sender) {
        [super backBtnClicked:sender];
    }else{
        NSArray *vcArr = self.navigationController.viewControllers;
        
        [self.navigationController popToViewController:vcArr[vcArr.count-3] animated:YES];
    }
}

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    //    [self uploadImagesWithIndex:0 withBusinessId:@"322"];
    //
    //    return;
    
    NSString *msg = nil;
    if(self.company.length == 0){
        msg = @"请选择终端订货工单";//@"请选择集团单位";
    }/*else if (self.order_time.length == 0){
        msg = @"请选择到货时间";
    }else if (self.order_info.length == 0){
        msg = @"请输入机型";
    }*/
    
    if ([self.order_type isEqualToString:@"赠送机"]|
        [self.order_type isEqualToString:@"赠送礼品"]|
        [self.order_type isEqualToString:@"集团关键联系人保底购机活动"]|
        [self.order_type isEqualToString:@"业务"]|
        [self.order_type containsString:@"重要客户（AB类）新业务体验营销活动"]) {
        
        if (self.client_name.length == 0) {
            msg = @"请输入客户姓名";
        }else if (self.phone_num.length == 0) {
            msg = @"请输入电话号码";
        }
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
    
    [dict setObject:([self.order_type isEqualToString:@"赠送礼品"]|[self.order_type isEqualToString:@"业务"])?@"17":@"15" forKey:@"type_id"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:self.company forKey:@"title"];
    
    [dict setObject:self.order_type forKey:@"order_type"];
    
    [dict setObject:self.order_info forKey:@"order_info"];
    
    [dict setObject:self.order_time forKey:@"order_time"];
    
    [dict setObject:self.bListModel.num forKey:@"order_num"];
    
    [dict setObject:self.client_name?self.client_name:@"" forKey:@"client_name"];
    
    [dict setObject:self.phone_num?self.phone_num:@"" forKey:@"client_tel"];
    
    [dict setObject:self.remarks?self.remarks:@"" forKey:@"remarks"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
    if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"] || [self.order_type containsString:@"重要客户（AB类）新业务体验营销活动"]){
        
        [dict setObject:self.minimum_guarantee_amount forKey:@"minimum_guarantee_amount"];
        [dict setObject:self.rigid_amount forKey:@"rigid_amount"];
        
    }
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"type_id":([self.order_type isEqualToString:@"赠送礼品"]|[self.order_type isEqualToString:@"业务"])?@"17":@"15",
//                           @"company_name":self.company,
//                           @"company_num":self.company_num,
//                           @"title":self.company,
//                           @"order_type":self.order_type,
//                           @"order_info":self.order_info,
//                           @"order_time":self.order_time,
//                           @"order_num":self.bListModel.num,
//                           @"client_name":self.client_name?self.client_name:@"",
//                           @"client_tel":self.phone_num?self.phone_num:@"",
//                           @"remarks":self.remarks?self.remarks:@"",
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
////                [self.navigationController popViewControllerAnimated:YES];
//                [self backBtnClicked:nil];
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

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
    if (section == 0) {
//        if (self.isShowSelectStock) {
//            rows = 1;
//        }else{
            if (!self.isEditIn) {
//                if (![self.order_type isEqualToString:@"赠送机"]&
//                    ![self.order_type isEqualToString:@"赠送礼品"]) {
//                    rows += 1;
//                }
            }else{
//                rows -= 1;
            }
//        }
    }else{
        
    }
//    if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"]){
//        
//            return <#expression#>
//    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"TxtFieldTableViewCell";
//    
//    
//    if (self.isShowSelectStock) {
//        TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
//            cell.txtField.delegate = self;
//        }
//        
//        cell.titleLbl.text = @"终端订货";
//        cell.txtField.placeholder = @"请选择终端订货工单";
//        
//        return cell;
//    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.section==0 && indexPath.row == 0) {
            TxtFieldTableViewCell *txtCell = (TxtFieldTableViewCell *)cell;
            txtCell.titleLbl.text = @"订货工号";
            txtCell.txtField.text = self.bListModel.num;
        }
    
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        TxtFieldTableViewCell *txtCell = (TxtFieldTableViewCell *)cell;
        if ([txtCell.titleLbl.text isEqualToString:@"机       型"]) {
            txtCell.titleLbl.text = @"出库机型";
        }
    }
    
        return cell;
//    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (self.isShowSelectStock) {
//        P_TerminalStockLViewController *vc = [[P_TerminalStockLViewController alloc] init];
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return NO;
//    }else{
    
        if (textField.tag == [_tableView numberOfRowsInSection:0]-1){

            if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"] || [self.order_type containsString:@"重要客户（AB类）新业务体验营销活动"]){
                
                return NO;
            }
            
            return [super textFieldShouldBeginEditing:textField];
        }else if (textField.tag >= [_tableView numberOfRowsInSection:0]-2) {
            return [super textFieldShouldBeginEditing:textField];
//            return YES;
        }
//    }
    
    return NO;
}

//#pragma mark - TerminalStockLViewControllerDelegate
//
//- (void)terminalStockLViewController:(P_TerminalStockLViewController *)vc
//                      didSelectModel:(BusinessListModel *)model
//{
////    self.isShowSelectStock = NO;
//    self.bListModel = model;
//    [self getDetaiWithBusinessId:model.business_id];
//}
//
//- (void)terminalStockLViewControllerDidCancel:(P_TerminalStockLViewController *)vc
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - 获取详情

- (void)getDetaiWithBusinessId:(NSString *)businessId
{
    NSDictionary *dict = @{@"business_id":businessId,
                           @"method":@"business_detail"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            NSDictionary *dict = entity[@"content"];
            self.isFromTerminalStock = YES;
            
            self.company = dict[@"company_name"];
            self.company_num = dict[@"company_num"];
            self.order_type = dict[@"order_type"];
            self.order_time = dict[@"order_time"];
            self.order_info = dict[@"order_info"];
            self.client_name = dict[@"client_name"];
            self.phone_num = dict[@"client_tel"];
            self.remarks = dict[@"remarks"];
            
            if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"] || [self.order_type containsString:@"重要客户（AB类）新业务体验营销活动"]){
                self.isFromTerminalStock = NO;
                self.minimum_guarantee_amount = dict[@"minimum_guarantee_amount"];
                self.rigid_amount = dict[@"rigid_amount"];
            }
            
            [_tableView reloadData];
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
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
                //                [self.navigationController popViewControllerAnimated:YES];
                [self backBtnClicked:nil];
                
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
