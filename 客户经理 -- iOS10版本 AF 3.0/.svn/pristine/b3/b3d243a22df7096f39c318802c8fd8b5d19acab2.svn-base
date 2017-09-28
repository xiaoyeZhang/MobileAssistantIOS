//
//  P_CardDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_CardDetailViewController.h"
#import "P_CardSubmitViewController.h"

@interface P_CardDetailViewController ()
@property(nonatomic, copy) NSString *make_card_num; ///办理号码
@end

@implementation P_CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"办卡详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:@{@"title":@"工单编号",@"list":@"num",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"办卡类型",@"detail":@"card_type",@"type":@"Label"},
                   @{@"title":@"机主姓名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"业务描述",@"detail":@"card_info",@"type":@"Label"},
                   @{@"title":@"备      注",@"detail":@"card_remarks",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    NSString *type = self.detailDict[@"card_type"];
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    if ([type isEqualToString:@"普号开卡"]) {
        
        //已办理号码
        if (state >= PROCESS_STATE_already_card) {
            [detailMuArr insertObject:@{@"title":@"办理号码",@"detail":@"card_num",@"type":@"Label"} atIndex:detailMuArr.count-1];
//            [detailMuArr insertObject:@{@"title":@"办理号码",@"process":@"remark",@"type":@"Label"} atIndex:detailMuArr.count-1];
        }
        
        if (state == PROCESS_STATE_manager_submit &&
            [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
            NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                               @{@"title":@"审核意见",@"type":@"Input"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认三级经理通过
                self.submitState = PROCESS_STATE_three_manager_through;
            }
            
            [self addSubmitBtn];
        }else if (state == PROCESS_STATE_three_manager_through &&
                  ([userInfo.type_id intValue] == ROLE_CARD|[userInfo.type_id intValue] == ROLE_COMMON)){ //办卡
            
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入办卡的处理意见"},
                               @{@"title":@"办理号码",@"type":@"Input"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) {
                self.submitState = PROCESS_STATE_already_card;
            }
            
            [self addSubmitBtnWithTitle:@"办卡"];
        } else if(state == PROCESS_STATE_already_card &&
                  [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //办卡 -> 客户经理送卡
            
            NSArray *array = @[@{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入送卡的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) {
                self.submitState = PROCESS_STATE_send_card;
            }
            
            [self addSubmitBtnWithTitle:@"送卡"];
        }
        
    }else{
        
        //添加办理号码
        [detailMuArr insertObject:@{@"title":@"办理号码",@"detail":@"card_num",@"type":@"Label"} atIndex:detailMuArr.count-3];
//        [detailMuArr insertObject:@{@"title":@"办理号码",@"process":@"remark",@"type":@"Label"} atIndex:detailMuArr.count-3];
        
        if (state == PROCESS_STATE_manager_submit &&
            ([userInfo.type_id intValue] == ROLE_CARD|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 办卡
            
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入办卡的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) {
                self.submitState = PROCESS_STATE_already_card;
            }
            
            [self addSubmitBtnWithTitle:@"办卡"];
        } else if(state == PROCESS_STATE_already_card &&
                  [userInfo.type_id intValue] == ROLE_CUSTOMER){ //办卡 -> 客户经理送卡
            
            NSArray *array = @[@{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入送卡的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) {
                self.submitState = PROCESS_STATE_send_card;
            }
            
            [self addSubmitBtnWithTitle:@"送卡"];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.submitState == PROCESS_STATE_already_card) {
        TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
            if ([cell.titleLbl.text isEqualToString:@"办理号码:"]) {
                self.make_card_num = textField.text;
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

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    int state = [self.bListModel.state intValue];
    
    if (selectedIndex == 1) {
        NSString *type = self.detailDict[@"card_type"];
        if ([type isEqualToString:@"普号开卡"]) {
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) {
                self.submitState = PROCESS_STATE_three_manager_through;
                
            }if (state == PROCESS_STATE_three_manager_through &&
                 ([userInfo.type_id intValue] == ROLE_CARD|[userInfo.type_id intValue] == ROLE_COMMON)){
//                self.submitState = PROCESS_STATE_already_card;
                
                if (self.submitState == PROCESS_STATE_reject) {
                    [detailMuArr addObject:@{@"title":@"办理号码",@"type":@"Input"}];
                    
                    self.submitState = PROCESS_STATE_already_card;
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    self.submitState = PROCESS_STATE_already_card;
                }
            }
        }else{
            if (state == PROCESS_STATE_manager_submit &&
                ([userInfo.type_id intValue] == ROLE_CARD|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 办卡
                self.submitState = PROCESS_STATE_already_card;
            }
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        if (state == PROCESS_STATE_three_manager_through &&
            ([userInfo.type_id intValue] == ROLE_CARD|[userInfo.type_id intValue] == ROLE_COMMON)){
            
            [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
        }
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
    
    
    int state = [self.bListModel.state intValue];
    NSString *type = self.detailDict[@"card_type"];
    
    if ([type isEqualToString:@"普号开卡"]) {
        if (state == PROCESS_STATE_three_manager_through ) {
            if (self.submitState != PROCESS_STATE_reject && self.make_card_num.length == 0) {
                ALERT_ERR_MSG(@"请输入办理号码");
                isDone = YES;
                return;
            }
            
            if (self.submitState != PROCESS_STATE_reject && self.make_card_num.length != 11 ) {
                ALERT_ERR_MSG(@"请输入正确的手机号码");
                isDone = YES;
                return;
            }
        }
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    
//    NSDictionary *dict = @{@"state":@(self.submitState),
//                           @"business_id":self.bListModel.business_id,
//                           @"user_id":userInfo.user_id,
//                           @"method":@"change_state",
//                           @"next_processor":self.next_processor_id,
//                           @"info":self.submitDesc?self.submitDesc:@"",
//                           @"card_num":([type isEqualToString:@"普号开卡"] &&self.submitState==PROCESS_STATE_already_card)?self.submitDesc:@""};
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                                  @"business_id":self.bListModel.business_id,
                                  @"user_id":userInfo.user_id,
                                  @"method":@"change_state",
                                  @"next_processor":self.next_processor_id,
                                  @"info":self.submitDesc?self.submitDesc:@"",
                                  @"remark":self.make_card_num?self.make_card_num:@""};
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([type isEqualToString:@"普号开卡"] && self.submitState==PROCESS_STATE_already_card) {
        [muDict setObject:self.make_card_num forKey:@"card_num"];
    }
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:muDict Successed:^(id entity) {
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
            
            
            P_CardSubmitViewController *vc = [[P_CardSubmitViewController alloc] init];
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
