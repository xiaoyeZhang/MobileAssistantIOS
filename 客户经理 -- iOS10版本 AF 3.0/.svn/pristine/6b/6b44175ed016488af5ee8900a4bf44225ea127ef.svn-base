//
//  P_SpecialSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_SpecialSubmitViewController.h"
#import "TxtFieldTableViewCell.h"
#import "CompEntity.h"
#import "UIActionSheet+Block.h"
#import "UIAlertView+Blocks.h"
#import "CustomerViewController.h"
#import "ContactViewController.h"
#import "WebViewViewController.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define SPECIAL_GRADE_TABLE_INDEX 2 //特号等级
#define SPECIAL_DESC_TABLE_INDEX 3//特号描述
#define COMPANY_TABLE_INDEX 4 //集团单位
#define COMPANY_NUM_TABLE_INDEX 5 //集团编号
#define CLIENT_NAME_TABLE_INDEX 6 //机主姓名
#define JOB_TABLE_INDEX 7 //职务
#define BASE_AMOUNT_TABLE_INDEX 8 //保底金额
#define BASE_TIME_TABLE_INDEX 9 //保底时间
#define MONEY_TABLE_INDEX 10 //需缴费用
#define REASON_TABLE_INDEX 11 //申请事由
#define NEXT_TABLE_INDEX 12 //下级执行人

@interface P_SpecialSubmitViewController ()<UITextFieldDelegate,
                                            CustomerViewControllerDelegate,
                                            ContactViewControllerDelegate>

///特号等级
@property(nonatomic, copy) NSString *num_grade;

///特号描述
@property(nonatomic, copy) NSString *num_desc;

///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///客户姓名
@property(nonatomic, copy) NSString *clientName;

///职务
@property(nonatomic, copy) NSString *job;

///需交费用
@property(nonatomic, copy) NSString *money;

///申请事由
@property(nonatomic, copy) NSString *reason;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

///保底金额
@property(nonatomic, copy) NSString *base_amount;

///保底时间
@property(nonatomic, copy) NSString *base_time;

///下级执行人
@property(nonatomic, copy) NSString *next_Name;

@end

@implementation P_SpecialSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"特号办理";
    super.model = NSStringFromClass([self class]);
    self.num_grade = @"二级特号";
    
    if (self.detailDict) {
        self.num_grade = self.detailDict[@"special_level"];
        self.num_desc = self.detailDict[@"special_info"];
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.clientName = self.detailDict[@"client_name"];
        self.job = self.detailDict[@"job"];
        self.money = self.detailDict[@"special_cost"];
        self.reason = self.detailDict[@"special_reason"];
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
    if (self.num_desc.length == 0) {
        msg = @"特号描述不能为空";
    }else if(self.company.length == 0){
        msg = @"请选择集团单位";
    }else if (self.clientName.length == 0){
        msg = @"请选择机主姓名";
    }else if (self.job.length == 0){
        msg = @"职务不能为空";
    }else if (self.money.length == 0){
        msg = @"需缴费用不能为空";
    }else if (self.reason.length == 0){
        msg = @"申请事由不能为空";
    }else if(self.base_amount.length == 0){
        msg = @"请选择保底金额";
    }else if (self.base_time.length == 0){
        msg = @"请选择保底时间";
    }
    
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    if ([self.num_grade isEqualToString:@"二级特号"]) {
        self.num_grade = @"2";
    }
    
    self.num_desc = [self.num_desc stringByReplacingOccurrencesOfString:@"," withString:@" "];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    
    [dict setObject:userInfo.user_id forKey:@"create_id"];
    
    [dict setObject:([self.num_grade intValue]==2|[self.num_grade intValue]==3)?@"1":@"2" forKey:@"type_id"];
    
    [dict setObject:self.num_grade forKey:@"special_level"];
    
    [dict setObject:self.reason forKey:@"special_reason"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.clientName forKey:@"client_name"];
    
    [dict setObject:self.job forKey:@"job"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@",self.company,self.num_desc] forKey:@"title"];
    
    [dict setObject:self.num_desc forKey:@"special_info"];
    
    [dict setObject:self.money forKey:@"special_cost"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
    [dict setObject:self.base_amount forKey:@"base_amount"];
    
    [dict setObject:self.base_time forKey:@"base_time"];
    
    [self get_three_list:[dict objectForKey:@"type_id"] Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:dict];
        }else{
            
            [self goSumbitData:dict];
        }
        isDone = YES;
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 15, 15);
        [btn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(helpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.txtField.rightView = btn;
        cell.txtField.rightViewMode = UITextFieldViewModeAlways;
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
        case SPECIAL_GRADE_TABLE_INDEX:
        {
            cell.titleLbl.text = @"特号等级";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.num_grade;
            if ([self.num_grade isEqualToString:@"2"]) {
                cell.txtField.text = @"二级特号";
            }else if([self.num_grade isEqualToString:@"3"]){
                cell.txtField.text = @"三级特号";
            }else if([self.num_grade isEqualToString:@"4"]){
                cell.txtField.text = @"四级特号";
            }else if([self.num_grade isEqualToString:@"5"]){
                cell.txtField.text = @"五级特号";
            }
            break;
        }
        case SPECIAL_DESC_TABLE_INDEX:
        {
            cell.titleLbl.text = @"特号描述";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.num_desc;
            break;
        }
        case COMPANY_TABLE_INDEX:
        {
            cell.titleLbl.text = @"集团单位";
            cell.txtField.placeholder = @"请选择集团名称";
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
            cell.titleLbl.text = @"机主姓名";
            cell.txtField.placeholder = nil;//@"请选择客户姓名";
            cell.txtField.text = self.clientName;
            break;
        }
        case JOB_TABLE_INDEX:
        {
            cell.titleLbl.text = @"职       务";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.job;
            break;
        }
        case MONEY_TABLE_INDEX:
        {
            cell.titleLbl.text = @"需缴费用";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.money;
            break;
        }
        case REASON_TABLE_INDEX:
        {
            cell.titleLbl.text = @"申请事由";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.reason;
            break;
        }
        case BASE_AMOUNT_TABLE_INDEX:
        {
            cell.titleLbl.text = @"保底金额";
            cell.txtField.placeholder = @"请选择";
            cell.txtField.text = self.base_amount;
            break;
        }
        case BASE_TIME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"保底时间";
            cell.txtField.placeholder = @"请选择";
            cell.txtField.text = self.base_time;
            break;
        }
            
//        case NEXT_TABLE_INDEX:
//        {
//            cell.titleLbl.text = @"下级执行人";
//            cell.txtField.placeholder = @"请选择";
//            cell.txtField.text = self.next_Name;
//            break;
//        }
            
        default:
            break;
    }
    
    if (indexPath.row == MONEY_TABLE_INDEX) {
        cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        cell.txtField.keyboardType = UIKeyboardTypeDefault;
    }
    
    if (indexPath.row == SPECIAL_GRADE_TABLE_INDEX) {
        cell.txtField.rightView.hidden = NO;
    }else{
        cell.txtField.rightView.hidden = YES;
    }
    
    return cell;
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
    }else if (textField.tag == SPECIAL_GRADE_TABLE_INDEX){ //特号等级
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"特号等级"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"二级特号",@"三级特号",@"四级特号",@"五级特号"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.num_grade = @"2";//@"二级特号";
                             }else if(buttonIndex == 1){
                                 self.num_grade = @"3";//@"三级特号";
                             }else if(buttonIndex == 2){
                                 self.num_grade = @"4";//@"四级特号";
                             }else if(buttonIndex == 3){
                                 self.num_grade = @"5";//@"五级特号";
                             }
                             
                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SPECIAL_GRADE_TABLE_INDEX inSection:0]]
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
        
    }else if (textField.tag == CLIENT_NAME_TABLE_INDEX){ //客户姓名
        
//        [self.view endEditing:YES];
//        
//        ContactViewController *vc = [[ContactViewController alloc] init];
//        vc.compEntity = self.selectedComEntitiy;
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return NO;
        
        return YES;
    }else if(textField.tag == BASE_AMOUNT_TABLE_INDEX){
        
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"保底金额"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"0",@"58",@"88",@"108",@"188",@"288",@"388",@"588"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.base_amount = @"0";
                             }else if(buttonIndex == 1){
                                 self.base_amount = @"58";
                             }else if(buttonIndex == 2){
                                 self.base_amount = @"88";
                             }else if(buttonIndex == 3){
                                 self.base_amount = @"108";
                             }else if(buttonIndex == 4){
                                 self.base_amount = @"188";
                             }else if(buttonIndex == 5){
                                 self.base_amount = @"288";
                             }else if(buttonIndex == 6){
                                 self.base_amount = @"388";
                             }else if(buttonIndex == 7){
                                 self.base_amount = @"588";
                             }
                             
                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:BASE_AMOUNT_TABLE_INDEX inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationFade];
                             
                         }];
        
        return NO;
    }else if (textField.tag == BASE_TIME_TABLE_INDEX){
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"保底时间"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"免保底",@"2年",@"终生"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.base_time = @"免保底";
                             }else if(buttonIndex == 1){
                                 self.base_time = @"2年";
                             }else if(buttonIndex == 2){
                                 self.base_time = @"终生";
                             }
                             
                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:BASE_TIME_TABLE_INDEX inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationFade];
                             
                         }];
        
        
        return NO;
    }else if (textField.tag == NEXT_TABLE_INDEX){
        [self.view endEditing:YES];
        
        
        
        
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
        case SPECIAL_DESC_TABLE_INDEX:
        {
            self.num_desc = textField.text;
            break;
        }
        case COMPANY_TABLE_INDEX:
        {
            self.company = textField.text;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            self.clientName = textField.text;
            break;
        }
        case JOB_TABLE_INDEX:
        {
            self.job = textField.text;
            break;
        }
        case MONEY_TABLE_INDEX:
        {
            self.money = textField.text;
            break;
        }
        case REASON_TABLE_INDEX:
        {
            self.reason = textField.text;
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

#pragma mark - helpBtnClicked

- (void)helpBtnClicked:(id)sender
{
    NSString *strUrl = @"http://sw.avatek.com.cn/gzcms/help.html";
    WebViewViewController *vc = [[WebViewViewController alloc]init];
    vc.url = strUrl;
    vc.strTitle = @"特号说明";
    [self.navigationController pushViewController:vc animated:YES];
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
