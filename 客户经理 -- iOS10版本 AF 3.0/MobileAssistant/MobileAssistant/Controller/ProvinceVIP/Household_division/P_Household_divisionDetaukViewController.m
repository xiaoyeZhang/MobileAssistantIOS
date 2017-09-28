//
//  P_Household_divisionDetaukViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_Household_divisionDetaukViewController.h"
#import "P_Household_divisionSubmitViewController.h"

@interface P_Household_divisionDetaukViewController ()

@end

@implementation P_Household_divisionDetaukViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分合户";

}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",              @"list":@"num",                  @"type":@"Label"},
                   @{@"title":@"客户经理",              @"list":@"user_name",            @"type":@"Label"},
                   @{@"title":@"申请部门",              @"list":@"dep_name",             @"type":@"Label"},
                   @{@"title":@"业务类型",          @"detail":@"Service_type",        @"type":@"Label"},
                   @{@"title":@"机主姓名",      @"detail":@"master_name",       @"type":@"Label"},
                   @{@"title":@"业务描述",         @"detail":@"Service_description",       @"type":@"Label"},
                   @{@"title":@"备       注",  @"detail":@"refund_remarks",      @"type":@"Label"},
                   @{@"title":@"状       态",   @"process":@"state",             @"type":@"Label"},nil];
    
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
    
    if (state == PROCESS_STATE_manager_submit &&
        ([userInfo.type_id intValue] == ROLE_THREE|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 客响中心审核
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审批意见",@"type":@"Input",@"placeholder":@"请输入审批意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客响中心已审核
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }
    
    if (state == PROCESS_STATE_three_manager_through &&
        ([userInfo.type_id intValue] == ROLE_COMMON)) {
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审批意见",@"type":@"Input",@"placeholder":@"请输入审批意见"}];
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客户经理已回访
            self.submitState = PROCESS_STATE_marketing_through;
        }
        
        [self addSubmitBtn];
    }
    
    if (state == PROCESS_STATE_marketing_through &&
        ([userInfo.type_id intValue] == PROCESS_STATE_manager_submit)) {
        
        NSArray *array = @[
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入处理意见"}];
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客户经理已回访
            self.submitState = PROCESS_STATE_manager_VISIT;
        }
        
        [self addSubmitBtn];
    }
    
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}


- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    int state = [self.bListModel.state intValue];
    
    if (state == PROCESS_STATE_manager_submit && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写审核理由");
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":@"-1",
                           @"info":self.submitDesc?self.submitDesc:@"",
                           };
    
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

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int type = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) {
            
            self.submitState = PROCESS_STATE_three_manager_through;
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            
            self.submitState = PROCESS_STATE_marketing_through;
            
        }else if (state == PROCESS_STATE_marketing_through &&
                  (type == ROLE_COMMON)){
            
            self.submitState = PROCESS_STATE_manager_VISIT;
        }
        
    }else{
        self.submitState = PROCESS_STATE_reject;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.submitDesc = textField.text;
}
- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_Household_divisionSubmitViewController *vc = [[P_Household_divisionSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            
            vc.typeNum = @"1";
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
