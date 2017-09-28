//
//  P_BookDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BookDetailViewController.h"
#import "P_BookSubmitViewController.h"

@interface P_BookDetailViewController ()

@property(nonatomic, copy) NSString *return_money; /*回款金额*/
@property(nonatomic, copy) NSString *return_money_date; /*回款日期*/

@end

@implementation P_BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"缴费台账详情";
    super.model = NSStringFromClass([self class]);
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:@{@"title":@"工单编号",@"list":@"num",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"台账类型",@"detail":@"account_type",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"缴费姓名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"电话号码",@"detail":@"account_num",@"type":@"Label"},
                   @{@"title":@"缴费金额",@"detail":@"account_cost",@"type":@"Label"},
                   @{@"title":@"支付方式",@"detail":@"account_pay",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    NSString *type = self.detailDict[@"account_pay"];
    int userType = [userInfo.type_id intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    if ([type isEqualToString:@"挂账"]) {
        
        [detailMuArr insertObject:@{@"title":@"挂账理由",@"detail":@"account_reason",@"type":@"Label"}
                          atIndex:detailMuArr.count-1];
        
        int cost = [self.detailDict[@"account_cost"] intValue];
        
        if (cost > 3000) {
            
            if (state == PROCESS_STATE_manager_submit &&
                userType == ROLE_THREE) {
                
                NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                                   @{@"title":@"审核意见",@"type":@"Input"},
                                   @{@"title":@"审核领导",@"type":@"Select"}];
                
                [detailMuArr addObjectsFromArray:array];
                
                if (!self.submitState) { //默认三级经理通过
                    self.submitState = PROCESS_STATE_three_manager_through;
                }
                
                [self addSubmitBtn];
            }else if (state == PROCESS_STATE_three_manager_through &&
                      [userInfo.user_id isEqualToString:self.bListModel.next_processor]){
                
                NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                                   @{@"title":@"审核意见",@"type":@"Input"}];
                
                [detailMuArr addObjectsFromArray:array];
                
                if (!self.submitState) { //默认二级经理通过
                    self.submitState = PROCESS_STATE_two_manager_through;
                }
                
                [self addSubmitBtn];
            }else if (state == PROCESS_STATE_two_manager_through &&
                     userType == ROLE_BOOK) { //客户经理已提交 -> 综合审批
            
                NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                   @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
    
                [detailMuArr addObjectsFromArray:array];
    
                if (!self.submitState) { //默认综合确认
                    self.submitState = PROCESS_STATE_marketing_through;
                }
                
                [self addSubmitBtn];
            }else if (state == PROCESS_STATE_marketing_through &&
                     userType == ROLE_BOOK){ //支撑人员填写回款情况
                     
                 NSArray *array = @[@{@"title":@"回款金额",@"type":@"Input"},
                                    @{@"title":@"回款日期",@"type":@"DateSelect"},
                                    @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入回款的处理意见"}];
     
                 [detailMuArr addObjectsFromArray:array];
     
                 if (!self.submitState) { //默认已填写回款情况
                     self.submitState = PROCESS_STATE_payment;
                 }
                 
                 [self addSubmitBtn];
            }else if (userType == ROLE_COMMON){ //通用人员
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>7) {
                    NSString *config = arr[7];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if (state == PROCESS_STATE_two_manager_through) { //综合审批
                            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
                            
                            [detailMuArr addObjectsFromArray:array];
                            
                            if (!self.submitState) { //默认综合确认
                                self.submitState = PROCESS_STATE_marketing_through;
                            }
                            
                            [self addSubmitBtn];
                        }else if (state == PROCESS_STATE_marketing_through){//支撑人员填写回款情况
                        
                            NSArray *array = @[@{@"title":@"回款金额",@"type":@"Input"},
                                               @{@"title":@"回款日期",@"type":@"DateSelect"},
                                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入回款的处理意见"}];
                            
                            [detailMuArr addObjectsFromArray:array];
                            
                            if (!self.submitState) { //默认已填写回款情况
                                self.submitState = PROCESS_STATE_payment;
                            }
                            
                            [self addSubmitBtn];
                        }
                    }
                }
            }

        }else{ // <= 3000
            if (state == PROCESS_STATE_manager_submit &&
                userType == ROLE_THREE) {
                
                NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                                   @{@"title":@"审核意见",@"type":@"Input"}];
                
                [detailMuArr addObjectsFromArray:array];
                
                if (!self.submitState) { //默认三级经理通过
                    self.submitState = PROCESS_STATE_three_manager_through;
                }
                
                [self addSubmitBtn];
            }else if (state == PROCESS_STATE_three_manager_through &&
                      userType == ROLE_BOOK) { //客户经理已提交 -> 综合审批
                
                NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                   @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
                
                [detailMuArr addObjectsFromArray:array];
                
                if (!self.submitState) { //默认综合确认
                    self.submitState = PROCESS_STATE_marketing_through;
                }
                
                [self addSubmitBtn];
            }else if (state == PROCESS_STATE_marketing_through &&
                      userType == ROLE_BOOK){ //支撑人员填写回款情况
                
                NSArray *array = @[@{@"title":@"回款金额",@"type":@"Input"},
                                   @{@"title":@"回款日期",@"type":@"DateSelect"},
                                   @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入回款的处理意见"}];
                
                [detailMuArr addObjectsFromArray:array];
                
                if (!self.submitState) { //默认已填写回款情况
                    self.submitState = PROCESS_STATE_payment;
                }
                
                [self addSubmitBtn];
            }else if(userType == ROLE_COMMON){ //通用人员
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>15) {
                    NSString *config = arr[15];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if (state == PROCESS_STATE_three_manager_through) { //综合审批
                            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
                            
                            [detailMuArr addObjectsFromArray:array];
                            
                            if (!self.submitState) { //默认综合确认
                                self.submitState = PROCESS_STATE_marketing_through;
                            }
                            
                            [self addSubmitBtn];
                        }else if (state == PROCESS_STATE_marketing_through){//支撑人员填写回款情况
                            
                            NSArray *array = @[@{@"title":@"回款金额",@"type":@"Input"},
                                               @{@"title":@"回款日期",@"type":@"DateSelect"},
                                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入回款的处理意见"}];
                            
                            [detailMuArr addObjectsFromArray:array];
                            
                            if (!self.submitState) { //默认已填写回款情况
                                self.submitState = PROCESS_STATE_payment;
                            }
                            
                            [self addSubmitBtn];
                        }
                    }
                }
            }
        }
    }else{
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_BOOK) { //客户经理已提交 -> 综合审批

            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input"}];

            [detailMuArr addObjectsFromArray:array];

            if (!self.submitState) { //默认确认
                self.submitState = PROCESS_STATE_marketing_through;
            }
            
            [self addSubmitBtn];
        }else if(userType == ROLE_COMMON){ //通用人员
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>8) {
                NSString *config = arr[8];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length > 0) { //当通用人员可执行状态包含当前状态
                    if (state == PROCESS_STATE_manager_submit) { //综合审批
                        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认综合确认
                            self.submitState = PROCESS_STATE_marketing_through;
                        }
                        
                        [self addSubmitBtn];
                    }
                }
            }
        }
        
        if ([type isEqualToString:@"对公转账"]) {
            [detailMuArr insertObject:@{@"title":@"转账日期",@"detail":@"transfer_date",@"type":@"Label"}
                              atIndex:detailMuArr.count-1];
        }
    }
//        if (state == PROCESS_STATE_manager_submit &&
//            ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 综合审批
//            
//            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
//                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入缴费台账登记的处理意见"}];
//            
//            [detailMuArr addObjectsFromArray:array];
//            
//            if (!self.submitState) { //默认综合确认
//                self.submitState = PROCESS_STATE_marketing_through;
//            }
//            
//            [self addSubmitBtn];
//        }else if (state == PROCESS_STATE_marketing_through &&
//                  [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //客户经理填写
//            
//            NSArray *array = @[@{@"title":@"回款金额",@"type":@"Input"},
//                               @{@"title":@"回款日期",@"type":@"DateSelect"},
//                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入回款的处理意见"}];
//            
//            [detailMuArr addObjectsFromArray:array];
//            
//            if (!self.submitState) { //默认已填写回款情况
//                self.submitState = PROCESS_STATE_payment;
//            }
//            
//            [self addSubmitBtn];
//        }
//    }else{
//        if (state == PROCESS_STATE_manager_submit &&
//            ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 综合审批
//            
//            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
//                               @{@"title":@"处理意见",@"type":@"Input"}];
//            
//            [detailMuArr addObjectsFromArray:array];
//            
//            if (!self.submitState) { //默认确认
//                self.submitState = PROCESS_STATE_marketing_through;
//            }
//            
//            [self addSubmitBtn];
//        }
//    }
    
    if (state >= PROCESS_STATE_payment) {
        
        NSArray *array = nil;
        
        if ([[processMuArr[0] valueForKey:@"state"] intValue] != 99) {
            array = [[processMuArr[0] valueForKey:@"remark"] componentsSeparatedByString:@";"];
        }else{
            array = [[processMuArr[1] valueForKey:@"remark"] componentsSeparatedByString:@";"];
        }
        
        if ([array count] == 2) {
            self.return_money = array[0];
            self.return_money_date = array[1];
            
            [detailMuArr insertObject:@{@"title":@"回款金额",@"custom":self.return_money,@"type":@"Label"} atIndex:detailMuArr.count-1];
            [detailMuArr insertObject:@{@"title":@"回款日期",@"custom":self.return_money_date,@"type":@"Label"} atIndex:detailMuArr.count-1];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        TxtFieldTableViewCell *txtCell = (TxtFieldTableViewCell *)cell;
        if ([txtCell.titleLbl.text isEqualToString:@"回款金额:"]) {
            txtCell.txtField.text = self.return_money;
        }else if ([txtCell.titleLbl.text isEqualToString:@"回款日期:"]){
            txtCell.txtField.text = self.return_money_date;
        }
    }else if([cell isMemberOfClass:[TwoLablesTableViewCell class]]){
        TwoLablesTableViewCell *labelCell = (TwoLablesTableViewCell *)cell;
        if ([labelCell.titleLbl.text isEqualToString:@"回款金额:"]) {
            labelCell.subTitleLbl.text = self.return_money;
        }else if ([labelCell.titleLbl.text isEqualToString:@"回款日期:"]){
            labelCell.subTitleLbl.text = self.return_money_date;
        }else if([labelCell.titleLbl.text isEqualToString:@"电话号码:"]){
            if ([self.detailDict[@"account_type"] isEqualToString:@"统付"] |
                [self.detailDict[@"account_type"] isEqualToString:@"终端"]) {
                labelCell.titleLbl.text = @"缴费账号:";
            }
        }
    }
    
    return cell;
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    NSString *type = self.detailDict[@"account_pay"];
    int userType = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        
        if ([type isEqualToString:@"挂账"]) {
//            if (state == PROCESS_STATE_manager_submit &&
//                ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 综合确认
//                
//                self.submitState = PROCESS_STATE_marketing_through;
//            }
            int cost = [self.detailDict[@"account_cost"] intValue];
            
            if (cost > 3000) {
                
                if (state == PROCESS_STATE_manager_submit &&
                    userType == ROLE_THREE) {
                    
                    if (self.submitState == PROCESS_STATE_reject) {
                        [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                        
                        self.submitState = PROCESS_STATE_three_manager_through;
                        
                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                  withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        self.submitState = PROCESS_STATE_three_manager_through;
                    }
                    
                }else if (state == PROCESS_STATE_three_manager_through &&
                          [userInfo.user_id isEqualToString:self.bListModel.next_processor]){
                    
                    self.submitState = PROCESS_STATE_two_manager_through;
                }else if (state == PROCESS_STATE_two_manager_through &&
                          ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 综合审批

                    self.submitState = PROCESS_STATE_marketing_through;
                }else if (state == PROCESS_STATE_marketing_through &&
                          ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)){ //支撑人员填写回款情况
                    self.submitState = PROCESS_STATE_payment;
                }
                
            }else{
                if (state == PROCESS_STATE_manager_submit &&
                    userType == ROLE_THREE) {
                    
                    self.submitState = PROCESS_STATE_three_manager_through;

                }else if (state == PROCESS_STATE_three_manager_through &&
                          ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 综合审批
                    
                    self.submitState = PROCESS_STATE_marketing_through;

                }else if (state == PROCESS_STATE_marketing_through &&
                          ([userInfo.type_id intValue] == ROLE_BOOK|[userInfo.type_id intValue] == ROLE_COMMON)){ //支撑人员填写回款情况
                    
                    self.submitState = PROCESS_STATE_payment;
                }
            }

        }else{
            self.submitState = PROCESS_STATE_marketing_through;
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        
        int cost = [self.detailDict[@"account_cost"] intValue];
        if (cost > 3000) {
            //三级经理不通过时 不显示审核领导
            if (state == PROCESS_STATE_manager_submit &&
                userType == ROLE_THREE) {
                [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];

    if (self.submitState == PROCESS_STATE_payment) {
        self.return_money_date = dateStr;
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.submitState == PROCESS_STATE_payment) {
        TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
            if ([cell.titleLbl.text isEqualToString:@"回款金额:"]) {
                self.return_money = textField.text;
            }else{
                [super textFieldDidEndEditing:textField];
            }
        }else{
            [super textFieldDidEndEditing:textField];
        }
    }else{
        [super textFieldDidEndEditing:textField];
    }
}


#pragma mark -

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    
    [self.view endEditing:YES];
    
    if (self.submitState == PROCESS_STATE_reject && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        isDone = YES;
        return;
    }
    
    if (self.isCheckBoxUnPass && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        isDone = YES;
        return;
    }
    
    if (self.submitState == PROCESS_STATE_payment &&
        (self.return_money_date.length == 0 ||self.return_money.length==0) ) {
        ALERT_ERR_MSG(@"请填写回款金额或回款日期");
        isDone = YES;
        return;
    }
    
    
    UserEntity *userInfo = [UserEntity sharedInstance];

    if (self.submitState == PROCESS_STATE_three_manager_through)
    {
        int cost = [self.detailDict[@"account_cost"] intValue];
        
        if (cost > 3000) {
        
            if (!self.isCheckBoxUnPass && ([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0)) {
                
                ALERT_ERR_MSG(@"请选择审核的领导");
                isDone = YES;
                return;
            }
            
        }
    }
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"",
                           @"remark":(self.return_money&&self.return_money_date)?[NSString stringWithFormat:@"%@;%@",self.return_money,self.return_money_date]:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    
    [service getNetWorkData:dict Successed:^(id entity) {
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
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
    }];
}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_BookSubmitViewController *vc = [[P_BookSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
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
