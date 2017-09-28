//
//  P_RepairDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_RepairDetailViewController.h"
#import "P_RepairSubmitViewController.h"

@interface P_RepairDetailViewController ()

@end

@implementation P_RepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"维修单详情";
    super.model = NSStringFromClass([self class]);
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:@{@"title":@"工单编号",@"list":@"num",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"姓      名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"捆绑号码",@"detail":@"repair_num",@"type":@"Label"},
                   @{@"title":@"捆绑机型",@"detail":@"repair_model",@"type":@"Label"},
                   @{@"title":@"捆绑型号",@"detail":@"repair_kind",@"type":@"Label"},
                   @{@"title":@"维修金额",@"detail":@"repair_cost",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int cost = [self.detailDict[@"repair_cost"] intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    
    if (cost > 1000) {
        if (state == PROCESS_STATE_manager_submit &&
            [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
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
        } else if(state == PROCESS_STATE_two_manager_through &&
                  ([userInfo.type_id intValue] == ROLE_REPAIR | [userInfo.type_id intValue] == ROLE_COMMON)){ //二级经理审批 -> 综合处理
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入终端售后维修的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认处理
                self.submitState = PROCESS_STATE_handled;
            }
            
            [self addSubmitBtnWithTitle:@"处理"];
        }

    }else{
        if (state == PROCESS_STATE_manager_submit &&
            [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
            NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                               @{@"title":@"审核意见",@"type":@"Input"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认三级经理通过
                self.submitState = PROCESS_STATE_three_manager_through;
            }
            
            [self addSubmitBtn];
        } else if(state == PROCESS_STATE_three_manager_through &&
                  ([userInfo.type_id intValue] == ROLE_REPAIR| [userInfo.type_id intValue] == ROLE_COMMON)){ //三级经理审批 -> 综合处理
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入终端售后维修的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认处理
                self.submitState = PROCESS_STATE_handled;
            }
            
            [self addSubmitBtnWithTitle:@"处理"];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int cost = [self.detailDict[@"repair_cost"] intValue];
    
    if (selectedIndex == 1) {
        if (cost > 1000) {
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
//                self.submitState = PROCESS_STATE_three_manager_through;
                if (self.submitState == PROCESS_STATE_reject) {
                    [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                    
                    self.submitState = PROCESS_STATE_three_manager_through;
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    self.submitState = PROCESS_STATE_three_manager_through;
                }
                
            }else if (state == PROCESS_STATE_three_manager_through &&
                      [userInfo.user_id isEqualToString:self.bListModel.next_processor]){ //指定二级经理审批
                
                self.submitState = PROCESS_STATE_two_manager_through;
            } else if(state == PROCESS_STATE_two_manager_through &&
                      ([userInfo.type_id intValue] == ROLE_REPAIR| [userInfo.type_id intValue] == ROLE_COMMON)){ //二级经理审批 -> 综合处理
                
                self.submitState = PROCESS_STATE_handled;
            }
            
        }else{
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                self.submitState = PROCESS_STATE_three_manager_through;
            } else if(state == PROCESS_STATE_three_manager_through &&
                      ([userInfo.type_id intValue] == ROLE_REPAIR| [userInfo.type_id intValue] == ROLE_COMMON)){ //三级经理审批 -> 综合处理
                
                self.submitState = PROCESS_STATE_handled;
            }
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        if (cost > 1000) {
            if(state == PROCESS_STATE_manager_submit &&
               [userInfo.type_id intValue] == ROLE_THREE){ //三级经理审批
                
                [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }
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
    
    
    int cost = [self.detailDict[@"repair_cost"] intValue];
    if (cost > 1000 && ([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0) && (self.submitState == PROCESS_STATE_three_manager_through)) {
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
                           @"info":self.submitDesc?self.submitDesc:@""};
    
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
            
            
            P_RepairSubmitViewController *vc = [[P_RepairSubmitViewController alloc] init];
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
