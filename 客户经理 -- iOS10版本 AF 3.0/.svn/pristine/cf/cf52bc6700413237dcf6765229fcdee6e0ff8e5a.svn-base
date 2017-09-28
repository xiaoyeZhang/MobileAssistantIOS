//
//  P_MarketingDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/3.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "P_MarketingDetailViewController.h"
#import "P_MarketingSubmitViewController.h"

@interface P_MarketingDetailViewController ()

@end

@implementation P_MarketingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销活动更改详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",     @"list":@"num",                  @"type":@"Label"},
                   @{@"title":@"客户经理",     @"list":@"user_name",            @"type":@"Label"},
                   @{@"title":@"申请部门",     @"list":@"dep_name",             @"type":@"Label"},
                   @{@"title":@"活动名称及ID", @"detail":@"activity_name",      @"type":@"Label"},
                   @{@"title":@"单位名称",     @"detail":@"company_name",       @"type":@"Label"},
                   @{@"title":@"集团编号",     @"detail":@"company_num",        @"type":@"Label"},
                   @{@"title":@"客户姓名",     @"detail":@"client_name",        @"type":@"Label"},
                   @{@"title":@"手 机 号",     @"detail":@"tel_num",            @"type":@"Label"},
                   @{@"title":@"参加时间",     @"detail":@"take_time",          @"type":@"Label"},
                   @{@"title":@"投诉原因",     @"detail":@"complaint_reason",   @"type":@"Label"},
                   @{@"title":@"更改方式",     @"detail":@"change_mode",        @"type":@"Label"},
                   @{@"title":@"状       态", @"process":@"state",             @"type":@"Label"},
                   nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    if (state == PROCESS_STATE_manager_submit && [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"},
                           @{@"title":@"审核领导",@"type":@"Select"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认三级经理通过
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_three_manager_through &&
              [userInfo.user_id isEqualToString:self.bListModel.next_processor]){ //指定二级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认二级经理通过
            self.submitState = PROCESS_STATE_two_manager_through;
        }
        
        [self addSubmitBtn];
    } else if(state == PROCESS_STATE_two_manager_through && [userInfo.user_id isEqualToString:self.bListModel.next_processor]){ //二级经理审批 -> 综合处理
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认处理
            self.submitState = PROCESS_STATE_marketing_through;
        }
        
        [self addSubmitBtnWithTitle:@"处理"];
    }

    if(state == PROCESS_STATE_two_manager_through && ([userInfo.type_id intValue] == ROLE_COMMON || [userInfo.type_id intValue] == ROLE_REPAIR)){ //二级经理审批 -> 综合处理
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认处理
            self.submitState = PROCESS_STATE_marketing_through;
        }
        
        [self addSubmitBtnWithTitle:@"处理"];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    
    if (selectedIndex == 1) {
    
                if (state == PROCESS_STATE_manager_submit &&
                    [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                    
                    if (self.submitState == PROCESS_STATE_reject) {
                         [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                        
                        self.submitState = PROCESS_STATE_three_manager_through;
                        
                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                  withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        self.submitState = PROCESS_STATE_three_manager_through;
                    }
                    
                }else if (state == PROCESS_STATE_two_manager_through &&
                          ([userInfo.type_id intValue] == ROLE_COMMON || [userInfo.type_id intValue] == ROLE_REPAIR)){ //指定二级经理审批
                    
                    self.submitState = PROCESS_STATE_two_manager_through;
                    
                }
        }else{
            
            self.submitState = PROCESS_STATE_reject;
            
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                self.submitState = PROCESS_STATE_reject;
                
                [detailMuArr removeObject:@{@"title":@"审核领导",@"type":@"Select"}];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }else if(state == PROCESS_STATE_three_manager_through && ([userInfo.type_id intValue] == ROLE_THREE| [userInfo.type_id intValue] == ROLE_COMMON)){
                
                self.submitState = PROCESS_STATE_reject;
            }else if(state == PROCESS_STATE_two_manager_through && ([userInfo.type_id intValue] == ROLE_TWO| [userInfo.type_id intValue] == ROLE_COMMON)){
                
                self.submitState = PROCESS_STATE_reject;
            }
        }
    
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    if (self.submitState == PROCESS_STATE_filled_out_confirm) {
//        self.return_money_date = dateStr;
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//        if (self.submitState == PROCESS_STATE_filled_out_confirm) {
//    
//            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                      withRowAnimation:UITableViewRowAnimationNone];
//        }else{
            [super textFieldDidEndEditing:textField];
//        }
    
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
        ALERT_ERR_MSG(@"请填写审核理由");
        
        return;
    }
    
    if (self.isCheckBoxUnPass && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写审核理由");
        
        return;
    }
    
    if (([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0) && (self.submitState == PROCESS_STATE_three_manager_through)) {
        ALERT_ERR_MSG(@"请选择审核领导");
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
   
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"",};

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
            
            
            P_MarketingSubmitViewController *vc = [[P_MarketingSubmitViewController alloc] init];
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
