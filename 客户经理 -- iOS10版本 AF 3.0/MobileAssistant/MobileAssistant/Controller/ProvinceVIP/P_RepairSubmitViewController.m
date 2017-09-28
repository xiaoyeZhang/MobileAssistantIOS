//
//  P_RepairSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_RepairSubmitViewController.h"
#import "CustomerViewController.h"
#import "ContactViewController.h"
#import "CompEntity.h"
#import "UIAlertView+Blocks.h"
#import "CheckBoxTableViewCell.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define COMPANY_TABLE_INDEX 2 //集团单位
#define COMPANY_NUM_TABLE_INDEX 3 //集团编号
#define CLIENT_NAME_TABLE_INDEX 4 //姓名
#define CONTACT_TABLE_INDEX 5 //是否关键联系人
#define REPAIR_NUM_TABLE_INDEX 6 //捆绑号码
#define REPAIR_MODEL_TABLE_INDEX 7 //捆绑机型
#define REPAIR_KIND_TABLE_INDEX 8 //捆绑型号
#define REPAIR_COST_TABLE_INDEX 9 //维修金额

@interface P_RepairSubmitViewController ()<UITextFieldDelegate,
                                           CustomerViewControllerDelegate,
                                           ContactViewControllerDelegate,
                                           CheckBoxTableViewCellDelegate>

///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///姓名
@property(nonatomic, copy) NSString *clientName;

///捆绑号码
@property(nonatomic, copy) NSString *repair_num;

///捆绑机型
@property(nonatomic, copy) NSString *repair_model;

///捆绑型号
@property(nonatomic, copy) NSString *repair_kind;

///维修金额
@property(nonatomic, copy) NSString *repair_cost;


///是否关键联系人
@property(nonatomic, assign) int keyContact;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@end

@implementation P_RepairSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"售后维修";
    
    if (self.detailDict) {
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.clientName = self.detailDict[@"client_name"];
        self.repair_num = self.detailDict[@"repair_num"];
        self.repair_model = self.detailDict[@"repair_model"];
        self.repair_kind = self.detailDict[@"repair_kind"];
        self.repair_cost = self.detailDict[@"repair_cost"];
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
    }else if (self.clientName.length == 0){
        msg = @"请填写客户姓名";
    }else if (self.keyContact==0){
        msg = @"请选择是否为关键联系人";
    }else if (self.repair_num.length == 0){
        msg = @"请填写捆绑号码";
    }else if (self.repair_model.length == 0){
        msg = @"请填写捆绑机型";
    }else if (self.repair_kind.length == 0){
        msg = @"请填写捆绑型号";
    }else if (self.repair_cost.length == 0){
        msg = @"请填写维修金额";
    }else if (self.keyContact == 2){
        msg = @"只有为关键联系人才可以售后维修";
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
    
    [dict setObject:self.clientName forKey:@"client_name"];
    
    [dict setObject:[self.repair_cost intValue]>1000?@"6":@"7" forKey:@"type_id"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:self.company forKey:@"title"];
    
    [dict setObject:self.repair_cost forKey:@"repair_cost"];
    
    [dict setObject:self.repair_model forKey:@"repair_model"];
    
    [dict setObject:self.repair_kind forKey:@"repair_kind"];
    
    [dict setObject:self.repair_num forKey:@"repair_num"];

    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];

    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"client_name":self.clientName,
//                           @"type_id":[self.repair_cost intValue]>1000?@"6":@"7",
//                           @"company_name":self.company,
//                           @"company_num":self.company_num,
//                           @"title":self.company,
//                           @"repair_cost":self.repair_cost,
//                           @"repair_model":self.repair_model,
//                           @"repair_kind":self.repair_kind,
//                           @"repair_num":self.repair_num,
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
    static NSString *identifier1 = @"CheckBoxTableViewCell";
    
    if (indexPath.row != CONTACT_TABLE_INDEX) {
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
                cell.titleLbl.text = @"姓       名";
                cell.txtField.placeholder = nil;//@"请选择";
                cell.txtField.text = self.clientName;
                break;
            }
            case REPAIR_NUM_TABLE_INDEX:
            {
                cell.titleLbl.text = @"捆绑号码";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.repair_num;
                break;
            }
            case REPAIR_MODEL_TABLE_INDEX:
            {
                cell.titleLbl.text = @"捆绑机型";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.repair_model;
                break;
            }
            case REPAIR_KIND_TABLE_INDEX:
            {
                cell.titleLbl.text = @"捆绑型号";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.repair_kind;
                break;
            }
            case REPAIR_COST_TABLE_INDEX:
            {
                cell.titleLbl.text = @"维修金额";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.repair_cost;
            }
            default:
                break;
        }
        
        if (indexPath.row == REPAIR_COST_TABLE_INDEX) {
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            cell.txtField.keyboardType = UIKeyboardTypeDefault;
        }
        
        return cell;
    }else{
        CheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        
        cell.titleLbl.text = @"关键联系人";
        
        return cell;
    }
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
        case REPAIR_NUM_TABLE_INDEX:
        {
            self.repair_num = textField.text;
            break;
        }
        case REPAIR_MODEL_TABLE_INDEX:
        {
            self.repair_model = textField.text;
            break;
        }
        case REPAIR_KIND_TABLE_INDEX:
        {
            self.repair_kind = textField.text;
            break;
        }
        case REPAIR_COST_TABLE_INDEX:
        {
            self.repair_cost = textField.text;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            self.clientName = textField.text;
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
    self.clientName = entity.name;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CLIENT_NAME_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    self.keyContact = selectedIndex;
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
