//
//  Basic_business_moduleDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Basic_business_moduleDetailViewController.h"
#import "Basic_business_moduleSubmitViewController.h"
#import "ImagesBrowserViewController.h"

@interface Basic_business_moduleDetailViewController ()

@end

@implementation Basic_business_moduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基础业务受理详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                    @{@"title":@"工单编号",@"detail":@"num",@"type":@"Label"},
                    @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                    @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                    @{@"title":@"基础业务类型",@"detail":@"basic_business_type",@"type":@"Label"},
                    @{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Label"},
                    @{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Label"},
                    @{@"title":@"客户参加活动时间",@"detail":@"activity_time",@"type":@"Label"},
                    @{@"title":@"业务需求说明",@"detail":@"business_info",@"type":@"Label"},
                    @{@"title":@"备注",@"detail":@"remarks",@"type":@"Label"},
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
            
            Basic_business_moduleSubmitViewController *vc = [[Basic_business_moduleSubmitViewController alloc] init];
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
    
    if ([self.detailDict[@"basic_business_type"] isEqualToString:@"活动延期"]) {
        
        [detailMuArr removeObject:@{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Label"}];
        [detailMuArr removeObject:@{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Label"}];
        
        [detailMuArr insertObject:@{@"title":@"大活动名称",@"detail":@"big_activity_name",@"type":@"Label"} atIndex:4];
        [detailMuArr insertObject:@{@"title":@"大活动ID",@"detail":@"big_activity_id",@"type":@"Label"} atIndex:5];
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
              userType == ROLE_THREE && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //客户经理审批通过 -> 三级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认营销支撑组经理通过
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_three_manager_through &&
              userType == ROLE_TWO && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理审核通过 -> 二级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认三级经理通过
            self.submitState = PROCESS_STATE_two_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_two_manager_through &&
              userType == ROLE_COMMON && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //二级经理审核通过 -> 营销支撑组组长审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //营销支撑组组长审批通过
            self.submitState = PROCESS_STATE_GROUP_LEADER_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_GROUP_LEADER_through &&
              userType == ROLE_COMMON && [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //营销支撑组组长审核通过 -> 营销支撑组审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}
                           ];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //营销支撑组审批通过
            self.submitState = PROCESS_STATE_marketing_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_marketing_through &&
              userType == ROLE_CUSTOMER ) { //营营销支撑组审核通过 -> 客户经理归档
        
        NSArray *array = @[@{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
//        if (!self.submitState) { //客户经理已归档
            self.submitState = PROCESS_STATE_library_File;
//        }
        
        [self addSubmitBtn];
    }
    
    [_tableView reloadData];
}

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
                  userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
            self.submitState = PROCESS_STATE_three_manager_through;
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  userType == ROLE_TWO) { //三级经理审核通过 -> 二级经理审批
            
            self.submitState = PROCESS_STATE_two_manager_through;
            
        }else if (state == PROCESS_STATE_two_manager_through &&
                  userType == ROLE_COMMON) { //二级经理审核通过 -> 营销支撑组组长审核
            
            self.submitState = PROCESS_STATE_GROUP_LEADER_through;
            
        }else if (state == PROCESS_STATE_GROUP_LEADER_through &&
                  userType == ROLE_COMMON) { //营销支撑组组长审核通过 -> 营销支撑组审批
            
            self.submitState = PROCESS_STATE_marketing_through;
            
        }
    }else{
        
        self.submitState = PROCESS_STATE_reject;
        
        if ((state == PROCESS_STATE_GROUP_LEADER_through && userType == ROLE_COMMON)|| (state == PROCESS_STATE_marketing_through && userType == ROLE_CUSTOMER ) ) {
            
            
        }else{
            
            [detailMuArr removeObjectAtIndex:detailMuArr.count-2];
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
        }
        
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
    
    if (self.submitState != PROCESS_STATE_marketing_through && self.submitState != PROCESS_STATE_library_File) {
        
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
