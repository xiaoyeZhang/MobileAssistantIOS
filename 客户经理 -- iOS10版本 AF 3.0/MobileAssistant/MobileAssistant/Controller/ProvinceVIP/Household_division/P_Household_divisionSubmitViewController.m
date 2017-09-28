//
//  P_Household_divisionSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_Household_divisionSubmitViewController.h"
#import "UIActionSheet+Block.h"
#import "P_Household_divisionViewController.h"

@interface P_Household_divisionSubmitViewController ()<UITextFieldDelegate>

///业务类型
@property(nonatomic, copy) NSString *Service_type;

///机主姓名
@property(nonatomic, copy) NSString *master_name;

///业务描述
@property(nonatomic, copy) NSString *Service_description;

///备注
@property(nonatomic, copy) NSString *remaks;

@property(nonatomic, copy) NSString *type_id;

@property (copy, nonatomic) NSString *business_id;
@end

@implementation P_Household_divisionSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分合户";
    
    self.type_id = @"21";
    
    if (self.detailDict) {
        self.Service_type = self.detailDict[@"Service_type"];
        self.master_name = self.detailDict[@"master_name"];
        self.Service_description = self.detailDict[@"Service_description"];
        self.remaks = self.detailDict[@"refund_remarks"];
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
    if(self.Service_type.length == 0){
        msg = @"请选择业务类型";
    }else if (self.master_name.length == 0){
        msg = @"请填写机主姓名";
    }else if (self.Service_description.length == 0){
        msg = @"请填写业务描述";
    }else if (self.remaks.length == 0){
        msg = @"请填写备注";
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
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@",self.master_name,self.Service_type] forKey:@"title"];
    
    [dict setObject:self.Service_type forKey:@"Service_type"];
    
    [dict setObject:self.master_name forKey:@"master_name"];
    
    [dict setObject:self.Service_description forKey:@"Service_description"];
    
    [dict setObject:self.remaks forKey:@"refund_remarks"];

    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"title":[NSString stringWithFormat:@"%@,%@",self.master_name,self.Service_type],
//                           @"type_id":self.type_id,
//                           @"Service_type":self.Service_type,
//                           @"master_name":self.master_name,
//                           @"Service_description":self.Service_description,
//                           @"refund_remarks":self.remaks,
//                           @"business_id":self.bListModel?self.bListModel.business_id:@"",};
    
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
//                if ([self.typeNum isEqualToString:@"1"]) {
//                    P_Household_divisionViewController *vc = [[P_Household_divisionViewController alloc]init];
//                    for (UIViewController *temp in self.navigationController.viewControllers) {
//                        if ([temp isKindOfClass:[vc class]]) {
//                            [self.navigationController popToViewController:temp animated:YES];
//                        }
//                        
//                    }
//                }else{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//            }];
//
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
    return 6;
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
            cell.titleLbl.text = @"客户经理:";
            cell.txtField.text = userInfo.name;
            
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"申请部门:";
            cell.txtField.text = userInfo.dep_name;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"业务类型:";
            cell.txtField.placeholder = @"请选择业务类型";
            cell.txtField.text = self.Service_type;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"机主姓名:";
            cell.txtField.text = self.master_name;
            break;
        }
        case 4:
        {
            cell.titleLbl.text = @"业务描述:";
            cell.txtField.text = self.Service_description;
            break;
        }
        case 5:
        {
            cell.titleLbl.text = @"备       注:";
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
    
    if(textField.tag == 0||
       textField.tag == 1){
        
        return NO;
    }else if (textField.tag == 2){
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"业务类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"分户",@"合户"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.Service_type = @"分户";
                             }else if(buttonIndex == 1){
                                 self.Service_type = @"合户";
                             }
                             
                          [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                                            withRowAnimation:UITableViewRowAnimationFade];
                             
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

        case 2:
        {
            self.Service_type = textField.text;
            break;
        }
        case 3:
        {
            self.master_name = textField.text;
            break;
        }
        case 4:
        {
            self.Service_description = textField.text;
            break;
        }
        case 5:
        {
            self.remaks = textField.text;
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
                if ([self.typeNum isEqualToString:@"1"]) {
                    P_Household_divisionViewController *vc = [[P_Household_divisionViewController alloc]init];
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
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
    }];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
