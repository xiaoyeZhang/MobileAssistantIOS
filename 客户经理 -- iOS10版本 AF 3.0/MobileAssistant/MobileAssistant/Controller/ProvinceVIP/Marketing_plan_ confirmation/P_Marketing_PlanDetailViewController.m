//
//  P_Marketing_PlanDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/5.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "P_Marketing_PlanDetailViewController.h"
#import "ImagesBrowserViewController.h"
#import "P_Marketing_PlanSubmitViewController.h"

@interface P_Marketing_PlanDetailViewController ()

@end

@implementation P_Marketing_PlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"营销方案确认详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",@"detail":@"num",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"活动名称",@"detail":@"activity_name",@"type":@"Label"},
                   @{@"title":@"活动时长(月)",@"detail":@"long_time",@"type":@"Label"},
                   @{@"title":@"活动生效时间",@"detail":@"activity_time",@"type":@"Label"},
                   @{@"title":@"活动盈利情况",@"detail":@"activity_profit",@"type":@"Label"},
                   @{@"title":@"营销方案类型",@"detail":@"marketing_scheme_type",@"type":@"Label"},
                   @{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Label"},
                   @{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Label"},
                   @{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Label"},
                   @{@"title":@"集团成员类型",@"detail":@"group_member_type",@"type":@"Label"},
                   @{@"title":@"综合补贴率",@"detail":@"comprehensive_subsidy_rate",@"type":@"Label"},
                   @{@"title":@"备注",@"detail":@"remarks",@"type":@"Label"},
                   @{@"title":@"活动检查点",@"detail":@"activity_checkpoint",@"type":@"Label"},
                   @{@"title":@"话费活动期内是否能参加",@"detail":@"during_the_period_of_the_speech",@"type":@"Label"},
                   @{@"title":@"终端活动期内是否能参加",@"detail":@"terminal_activity_period",@"type":@"Label"},
                   @{@"title":@"是否设置保底",@"detail":@"whether_to_set_a_guarantee",@"type":@"Label"},
                   @{@"title":@"活动受理时间",@"detail":@"activity_admissibility_time",@"type":@"Label"},
                   @{@"title":@"图       片",@"detail":@"state",@"type":@"Btn"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id]) { //提交客户经理重新编辑
            
            P_Marketing_PlanSubmitViewController *vc = [[P_Marketing_PlanSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            vc.typeNum = @"1";
            if (self.bListModel.picname.length > 0) {
                NSString *names = [self.bListModel.picname substringFromIndex:1];
                if (names.length > 0) {
                    NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
                    
                    vc.uploadImagesArr = imagesNameArr;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
}

- (void)reloadSubmitData
{
    
    if ([self.detailDict[@"marketing_scheme_type"] isEqualToString:@"其他"]) {
        
        [detailMuArr removeObject:@{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Label"}];
        [detailMuArr removeObject:@{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Label"}];
        [detailMuArr removeObject:@{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Label"}];
        
        [detailMuArr insertObject:@{@"title":@"自选营销方案类型",@"detail":@"marketing_scheme_type_fill",@"type":@"Label"} atIndex:8];
    
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int userType = [userInfo.type_id intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id]) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    if (state == PROCESS_STATE_manager_submit &&
        userType == ROLE_COMMON  && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //客户经理已提交 -> 营销支撑组审核
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认营销支撑组审核通过
            self.submitState = PROCESS_STATE_marketing_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_marketing_through &&
              userType == ROLE_COMMON && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //营销支撑组审核审核通过 -> 营销支撑组经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认营销支撑组经理通过
            self.submitState = PROCESS_STATE_marketing_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_marketing_manager_through &&
              userType == ROLE_THREE && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //营销支撑组经理审核通过 -> 三级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认三级经理通过
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_three_manager_through &&
              userType == ROLE_TWO && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理审核通过 -> 营销支撑组审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
//        if (!self.submitState) { //营销支撑组已归档
            self.submitState = PROCESS_STATE_two_manager_through;
//        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_two_manager_through &&
              userType == ROLE_COMMON && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理审核通过 -> 营销支撑组审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        //        if (!self.submitState) { //营销支撑组已归档
        self.submitState = PROCESS_STATE_SELECT_REFUND;
        //        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_SELECT_REFUND &&
              userType == ROLE_COMMON && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理审核通过 -> 营销支撑组审批
        
        NSArray *array = @[@{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        //        if (!self.submitState) { //营销支撑组已归档
        self.submitState = PROCESS_STATE_REFUND;
        //        }
        
        [self addSubmitBtn];
    }
    
    [_tableView reloadData];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    if([cell isMemberOfClass:[TwoLablesTableViewCell class]]){
//        TwoLablesTableViewCell *labelCell = (TwoLablesTableViewCell *)cell;
//        if ([labelCell.titleLbl.text isEqualToString:@"活动档次:"]) {
//            labelCell.titleLbl.text = [NSString stringWithFormat:@"活动档次(%@):",self.detailDict[@"marketing_scheme_type"]];
//        }
//    }
//
//    return cell;
//}
#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    int state = [self.bListModel.state intValue];
    int userType = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {

        [detailMuArr insertObject:@{@"title":@"审核领导",@"type":@"Select"} atIndex:detailMuArr.count-1];

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
        
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_COMMON) { //客户经理已提交 -> 营销支撑组审核

            self.submitState = PROCESS_STATE_marketing_through;
  
        }else if (state == PROCESS_STATE_marketing_through &&
                  userType == ROLE_COMMON) { //营销支撑组审核审核通过 -> 营销支撑组经理审批

            self.submitState = PROCESS_STATE_marketing_manager_through;

        }else if (state == PROCESS_STATE_marketing_manager_through &&
                  userType == ROLE_THREE) { //营销支撑组经理审核通过 -> 三级经理审批

            self.submitState = PROCESS_STATE_three_manager_through;
  
        }else if (state == PROCESS_STATE_three_manager_through &&
                  userType == ROLE_TWO) { //营销支撑组经理审核通过 -> 三级经理审批
            
            self.submitState = PROCESS_STATE_two_manager_through;
            
        }else if (state == PROCESS_STATE_two_manager_through &&
                  userType == ROLE_COMMON) { //营销支撑组经理审核通过 -> 三级经理审批
            
            self.submitState = PROCESS_STATE_SELECT_REFUND;
            
        }
    }else{
        
        self.submitState = PROCESS_STATE_reject;
        
        [detailMuArr removeObjectAtIndex:detailMuArr.count-2];
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
//        if (state == PROCESS_STATE_marketing_through &&
//            userType == ROLE_COMMON){
//
//
//        }
    }
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    if (self.bListModel.picname.length > 0) {
        NSString *names = [self.bListModel.picname substringFromIndex:1];
        if (names.length > 0) {
            NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
            
            ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
            vc.imagesNameArray = imagesNameArr;
            [self.navigationController pushViewController:vc animated:YES];
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
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if (self.submitState == PROCESS_STATE_reject &&
        self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        
        isDone = YES;
        
        return;
    }
    
    if (self.submitState != PROCESS_STATE_REFUND) { //客户经理已提交 -> 三级经理审批

        if ((!self.next_processor_id || [self.next_processor_id isEqualToString:@"-1"]) &&
            (self.submitState != PROCESS_STATE_reject)) {
            ALERT_ERR_MSG(@"请选择下级执行人");
            isDone = YES;
            return;
        }
    }
    
    if (self.isCheckBoxUnPass && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        isDone = YES;
        return;
    }
    
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        isDone = YES;

        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];

        if ([strState isEqualToString:@"1"]) {

//            if (self.submitState == PROCESS_STATE_manager_confirm) {
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提交成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//                }];
//
//                return;
//            }

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];

                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }

    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
        ALERT_ERR_MSG(@"提交失败,网络连接错误!");
    }];
}

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
