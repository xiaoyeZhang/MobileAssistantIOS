//
//  P_CardSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_CardSubmitViewController.h"
#import "UIActionSheet+Block.h"


@interface P_CardSubmitViewController ()<UITextFieldDelegate>

///办卡类型 普号开卡(不显示办理号码)、补/换卡
@property(nonatomic, copy) NSString *card_type;

///机主姓名
@property(nonatomic, copy) NSString *client_name;

///办理号码 普号开卡不显示
@property(nonatomic, copy) NSString *card_num;

///业务描述
@property(nonatomic, copy) NSString *card_info;

///备注
@property(nonatomic, copy) NSString *card_remarks;

@end

@implementation P_CardSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"办卡";
    self.card_type = @"普号开卡";
    
    if (self.detailDict) {
        self.card_type = self.detailDict[@"card_type"];
        self.client_name = self.detailDict[@"client_name"];
        self.card_info = self.detailDict[@"card_info"];
        self.card_remarks = self.detailDict[@"card_remarks"];
        self.card_num = self.detailDict[@"card_num"];
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
    if(self.client_name.length == 0){
        msg = @"请填写机主姓名";
    }else if (self.card_num.length == 0){
        if (![self.card_type isEqualToString:@"普号开卡"]) {
            msg = @"请填写办理号码";
        }else if (self.card_info.length == 0){
            msg = @"请填写业务描述";
        }else if (self.card_remarks.length == 0){
            msg = @"请填写备注";
        }
    }else if (self.card_info.length == 0){
        msg = @"请填写业务描述";
    }else if (self.card_remarks.length == 0){
        msg = @"请填写备注";
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    self.card_info = [self.card_info stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    
    [dict setObject:userInfo.user_id forKey:@"create_id"];
    
    [dict setObject:[self.card_type isEqualToString:@"普号开卡"]?@"10":@"11" forKey:@"type_id"];
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@",self.client_name,self.card_type] forKey:@"title"];
    
    [dict setObject:self.client_name forKey:@"client_name"];
    
    [dict setObject:self.card_num?self.card_num:@"" forKey:@"card_num"];
    
    [dict setObject:self.card_info forKey:@"card_info"];
    
    [dict setObject:self.card_remarks forKey:@"card_remarks"];
    
    [dict setObject:self.card_type forKey:@"card_type"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
//    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"type_id":[self.card_type isEqualToString:@"普号开卡"]?@"10":@"11",
//                           @"title":/*self.card_type*/[NSString stringWithFormat:@"%@,%@",self.client_name,self.card_type],
//                           @"client_name":self.client_name,
//                           @"card_num":self.card_num?self.card_num:@"",
//                           @"card_info":self.card_info,
//                           @"card_remarks":self.card_remarks,
//                           @"card_type":self.card_type,
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
    if ([self.card_type isEqualToString:@"普号开卡"]) {
        return 6;
    }else{
        return 7;
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
            cell.titleLbl.text = @"办卡类型";
            cell.txtField.text = self.card_type;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"机主姓名";
            cell.txtField.text = self.client_name;
            break;
        }
        case 4:
        {
            if ([self.card_type isEqualToString:@"普号开卡"]) {
                cell.titleLbl.text = @"业务描述";
                cell.txtField.text = self.card_info;
            }else{
                cell.titleLbl.text = @"办理号码";
                cell.txtField.text = self.card_num;
            }
            break;
        }
        case 5:
        {
            if ([self.card_type isEqualToString:@"普号开卡"]) {
                cell.titleLbl.text = @"备       注";
                cell.txtField.text = self.card_remarks;
            }else{
                cell.titleLbl.text = @"业务描述";
                cell.txtField.text = self.card_info;
            }
            break;
        }
        case 6:
        {
            if ([self.card_type isEqualToString:@"普号开卡"]) {
                cell.titleLbl.text = nil;
                cell.txtField.text = nil;
            }else{
                cell.titleLbl.text = @"备       注";
                cell.txtField.text = self.card_remarks;
            }

            break;
        }
        default:
            break;
    }
    
    if (indexPath.row == 4) {
        if (![self.card_type isEqualToString:@"普号开卡"]) {
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
        }
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
    
    if (textField.tag == 0 |
        textField.tag == 1 ){
        return NO;
    }else if(textField.tag == 2){ //办卡类型
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"办卡类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"普号开卡",@"补/换卡"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                             
                                 if (buttonIndex == 0) {
                                     self.card_type = @"普号开卡";
                                 }else if(buttonIndex == 1){
                                     self.card_type = @"补/换卡";
                                 }
                                
                                 [_tableView reloadData];
                             }
                             
                         }];
        
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
        case 3: //机主姓名
        {
            self.client_name = textField.text;
            break;
        }
        case 4:
        {
            if ([self.card_type isEqualToString:@"普号开卡"]) {
                self.card_info = textField.text;
            }else{
                self.card_num = textField.text;
            }
            break;
        }
        case 5:
        {
            if ([self.card_type isEqualToString:@"普号开卡"]) {
                self.card_remarks = textField.text;
            }else{
                self.card_info = textField.text;
            }
            break;
        }
        case 6:
        {
            if (![self.card_type isEqualToString:@"普号开卡"]) {
                self.card_remarks = textField.text;
            }
            break;
        }
        default:
            break;
    }
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
