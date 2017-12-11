//
//  P_TerminalStockDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalStockDetailViewController.h"
#import "P_TerminalStockSubmitViewController.h"

@interface P_TerminalStockDetailViewController ()

@end

@implementation P_TerminalStockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端出库详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",@"detail":@"num",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"订货工号",@"list":@"num",@"type":@"Label"},
                   @{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"电       话",@"detail":@"client_tel",@"type":@"Label"},
                   @{@"title":@"备       注",@"detail":@"remarks",@"type":@"Label"},
                   @{@"title":@"订货类型",@"detail":@"order_type",@"type":@"Label"},
                   @{@"title":@"到货时间",@"detail":@"order_time",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int userType = [userInfo.type_id intValue];
    
    if ([self.detailDict[@"order_type"] isEqualToString:@"集团关键联系人保底购机活动"] || [self.detailDict[@"order_type"] isEqualToString:@"重要客户（AB类）新业务体验营销活动"]){
        
        [detailMuArr addObject:@{@"title":@"保底金额",@"detail":@"minimum_guarantee_amount",@"type":@"Label"}];
        [detailMuArr addObject:@{@"title":@"刚性成本金额",@"detail":@"rigid_amount",@"type":@"Label"}];
    }
    
    if (state == PROCESS_STATE_reject) { //被驳回
        
        [detailMuArr insertObject:@{@"title":@"处理意见",@"process":@"info",@"type":@"Label"} atIndex:detailMuArr.count-1];
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            [self addEditBtn]; //添加编辑按钮
        }
        
        [_tableView reloadData];
        
        return;
    }
    
    
    //订货类型为“赠送礼品”时，二级经理审核通过后，直接到出库节点
    if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
        [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
        if (state == PROCESS_STATE_two_manager_through &&
            userType == ROLE_LIBRARY_3){
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入出库的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认已出库
                self.submitState = PROCESS_STATE_library_end;
            }
            [self addSubmitBtnWithTitle:@"出库"];
            
            
            [_tableView reloadData];
            return;
        }else if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>16) {
                NSString *config = arr[16];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length > 0) {
                    if (state == PROCESS_STATE_two_manager_through) {
                        
                        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入出库的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认已出库
                            self.submitState = PROCESS_STATE_library_end;
                        }
                        [self addSubmitBtnWithTitle:@"出库"];
                        
                        
                        [_tableView reloadData];
                        return;
                    }
                }
            }
            
            [_tableView reloadData];
            return;
        }
    }
    
    if (state == PROCESS_STATE_manager_submit &&
        userType == ROLE_THREE) { //客户经理已提交 -> 行业总监审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认行业总监通过
            self.submitState = PROCESS_STATE_Industry_director;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_Industry_director &&
              userType == ROLE_THREE) { //行业总监审批通过 -> 三级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"},
                           @{@"title":@"审核领导",@"type":@"Select"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认三级经理通过
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_three_manager_through &&
              [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认二级经理通过
            self.submitState = PROCESS_STATE_two_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_two_manager_through &&
              (userType == ROLE_LIBRARY_1 || userType == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length == 0) { //没有执行权限则不加提交
                   
                    [_tableView reloadData];
                    
                    return;
                }
            }
        }
        
//        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
//                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入发送串号的处理意见"}];
        
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入发送串号的处理意见"},
                           @{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认串号已发送至客户经理
            self.submitState = PROCESS_STATE_library_number;
        }
        [self addSubmitBtnWithTitle:@"发送"];
    }else if(state == PROCESS_STATE_library_number &&
             [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //串号已发送至客户经理->已提交客户信息至受理人员（客户经理）
        
//        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
//                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入提交客户信息明细的处理意见"},
//                           @{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
        
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入提交客户信息明细的处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认已提交客户信息至受理人员
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }
        [self addSubmitBtnWithTitle:@"确定"];
    }else if(state == PROCESS_STATE_library_acceptanceing &&
             ((userType == ROLE_LIBRARY_2 || userType == ROLE_COMMON) )){ //营销活动已受理->默认营销活动已受理
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length == 0) { //没有执行权限则不加提交
                    
                    [_tableView reloadData];
                    
                    return;
                }
            }
        }
        
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入营销活动受理的处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认营销活动已受理
            self.submitState = PROCESS_STATE_library_acceptanceed;
        }
        [self addSubmitBtnWithTitle:@"受理"];
    }else if(state == PROCESS_STATE_library_acceptanceed &&
             (userType == ROLE_LIBRARY_3 || userType == ROLE_COMMON)){//默认营销活动已受理->已出库
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length == 0) { //没有执行权限则不加提交
                    
                    [_tableView reloadData];
                    
                    return;
                }
            }
        }
        
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入出库的处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认已出库
            self.submitState = PROCESS_STATE_library_end;
        }
        [self addSubmitBtnWithTitle:@"出库"];
    }else if (state == PROCESS_STATE_library_end &&
              [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
        
        NSArray *array = @[@{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入领货的处理意见"}];
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认已领货
            self.submitState = PROCESS_STATE_library_picking;
        }
        [self addSubmitBtn];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) { //申请机型
        
        NSArray *arr = [self.detailDict[@"order_info"] componentsSeparatedByString:@";"];
        
        NSInteger rows = [arr count]>0?[arr count]+1:0;
        
        return rows;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *lablesIdentifier = @"ThreeLabelsTableViewCell";
    
    if (indexPath.section == 1) {
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lablesIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:lablesIdentifier owner:nil options:nil] firstObject];
            cell.leftLbl.text = nil;
            cell.middleLbl.text = nil;
            cell.rightLbl.text = nil;
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"需求机型";
            cell.middleLbl.text = @"数量";
            cell.rightLbl.text = @"颜色";
            
            if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                cell.leftLbl.text = @"业务名称";
            }
        }else{
            NSArray *deviceArr = [self.detailDict[@"order_info"] componentsSeparatedByString:@";"];
            NSString *deviceStr = deviceArr[indexPath.row-1];
            
            NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
            if (infoArr.count >= 3) {
                cell.leftLbl.text = infoArr[0];
                cell.middleLbl.text = infoArr[1];
                cell.rightLbl.text = infoArr[2];
            }
        }
        
        return cell;
        
        
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITabelViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
            [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
            return @"> 申请业务列表";
        }
        
        return @"> 申请机型列表";
    } else{
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

#pragma mark -

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    BOOL rs = [super textFieldShouldBeginEditing:textField];
//    
//    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
//    
//    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
//        if (cell.isNeedSelect) {
//            
//            NSDictionary *dict = detailMuArr[textField.tag];
//            NSString *type = dict[@"type"]; //类型
//            
//            if ([type isEqualToString:@"AddDevice"]){
//                P_AddDevicesViewController *vc = [[P_AddDevicesViewController alloc] init];
//                vc.device_info = self.detailDict[@"order_info"];
//                vc.delegate = self;
//                [self.navigationController pushViewController:vc animated:YES];
//                
//                return NO;
//            }
//        }
//    }
//    
//    return rs;
//}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int type = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        
        if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
            [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
            if (state == PROCESS_STATE_two_manager_through &&
                (type == ROLE_LIBRARY_3 || type == ROLE_COMMON)){
            
                self.submitState = PROCESS_STATE_library_end;
                
                return;
            }
        }
        
        
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
//            self.submitState = PROCESS_STATE_three_manager_through;
            if (self.submitState == PROCESS_STATE_reject) {
                [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                
                self.submitState = PROCESS_STATE_three_manager_through;
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }else{
                self.submitState = PROCESS_STATE_three_manager_through;
            }
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            self.submitState = PROCESS_STATE_two_manager_through;
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_LIBRARY_1|| type == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
            
            
//            self.submitState = PROCESS_STATE_library_number;
            
            if (self.submitState == PROCESS_STATE_reject) {

                self.submitState = PROCESS_STATE_library_number;
                
                if (![self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                    ![self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                    [detailMuArr addObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }
            }else{
                self.submitState = PROCESS_STATE_library_number;
            }
            
        }else if(state == PROCESS_STATE_library_number&&
                 [self.bListModel.create_id isEqualToString:userInfo.user_id]){

//            if (self.submitState == PROCESS_STATE_two_manager_through) {
//                [detailMuArr addObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
//                
//                self.submitState = PROCESS_STATE_library_acceptanceing;
//                
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                          withRowAnimation:UITableViewRowAnimationNone];
//            }else{
//                self.submitState = PROCESS_STATE_library_acceptanceing;
//            }
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }else if(state == PROCESS_STATE_library_acceptanceing &&
                 (type == ROLE_LIBRARY_2|| type == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
            self.submitState = PROCESS_STATE_library_acceptanceed;
        }else if(state == PROCESS_STATE_library_acceptanceed &&
                 (type == ROLE_LIBRARY_3|| type == ROLE_COMMON)){//默认营销活动已受理->已出库
            
            self.submitState = PROCESS_STATE_library_end;
        }else if (state == PROCESS_STATE_library_end &&
                  [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
            self.submitState = PROCESS_STATE_library_picking;
        }
    }else{
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            self.submitState = PROCESS_STATE_reject;
            
            
            //删除审核领导
            [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            self.submitState = PROCESS_STATE_reject;
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_LIBRARY_1|| type == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_reject;
            
            
            if (![self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                ![self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                //删除活动受理人
                [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }
        }else if (state == PROCESS_STATE_library_number &&
                  [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //串号已发送至客户经理->客户经理确认
            self.submitState = PROCESS_STATE_two_manager_through;
            
        } else if(state == PROCESS_STATE_library_acceptanceing &&
                 (type == ROLE_LIBRARY_2|| type == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
            self.submitState = PROCESS_STATE_library_number;
        }else if(state == PROCESS_STATE_library_acceptanceed &&
                 (type == ROLE_LIBRARY_3|| type == ROLE_COMMON)){//默认营销活动已受理->已出库 驳回返回串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }else if (state == PROCESS_STATE_library_end &&
             [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }
    }
}

#pragma mark - 

- (void)ThreecheckBoxTableViewCell:(ThreeCheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex

{
    [super ThreecheckBoxTableViewCell:cell checkDidChanged:selectedIndex];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int type = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        
        if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
            [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
            if (state == PROCESS_STATE_two_manager_through &&
                (type == ROLE_LIBRARY_3 || type == ROLE_COMMON)){
                
                self.submitState = PROCESS_STATE_library_end;
                
                return;
            }
        }
        
        
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            //            self.submitState = PROCESS_STATE_three_manager_through;
            if (self.submitState == PROCESS_STATE_reject) {
                [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                
                self.submitState = PROCESS_STATE_three_manager_through;
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }else{
                self.submitState = PROCESS_STATE_three_manager_through;
            }
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            self.submitState = PROCESS_STATE_two_manager_through;
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_LIBRARY_1|| type == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
            
            
            //            self.submitState = PROCESS_STATE_library_number;
            
            if (self.submitState == PROCESS_STATE_reject | self.submitState == PROCESS_STATE_library_File) {
                
                self.submitState = PROCESS_STATE_library_number;
                
                if (![self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                    ![self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                    
                    [detailMuArr addObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }
            }else{
                self.submitState = PROCESS_STATE_library_number;
                
            }
            
        }else if(state == PROCESS_STATE_library_number&&
                 [self.bListModel.create_id isEqualToString:userInfo.user_id]){
            
            //            if (self.submitState == PROCESS_STATE_two_manager_through) {
            //                [detailMuArr addObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
            //
            //                self.submitState = PROCESS_STATE_library_acceptanceing;
            //
            //                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
            //                          withRowAnimation:UITableViewRowAnimationNone];
            //            }else{
            //                self.submitState = PROCESS_STATE_library_acceptanceing;
            //            }
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }else if(state == PROCESS_STATE_library_acceptanceing &&
                 (type == ROLE_LIBRARY_2|| type == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
            self.submitState = PROCESS_STATE_library_acceptanceed;
        }else if(state == PROCESS_STATE_library_acceptanceed &&
                 (type == ROLE_LIBRARY_3|| type == ROLE_COMMON)){//默认营销活动已受理->已出库
            
            self.submitState = PROCESS_STATE_library_end;
        }else if (state == PROCESS_STATE_library_end &&
                  [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
            self.submitState = PROCESS_STATE_library_picking;
        }
    }else if (selectedIndex == 2){
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            self.submitState = PROCESS_STATE_reject;
            
            
            //删除审核领导
            [detailMuArr removeObject:@{@"title":@"审核领导",@"type":@"Select"}];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            self.submitState = PROCESS_STATE_reject;
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_LIBRARY_1|| type == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_reject;
            
            
            if (![self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                ![self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                //删除活动受理人
                [detailMuArr removeObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }
        }else if (state == PROCESS_STATE_library_number &&
                  [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //串号已发送至客户经理->客户经理确认
            self.submitState = PROCESS_STATE_two_manager_through;
            
        } else if(state == PROCESS_STATE_library_acceptanceing &&
                  (type == ROLE_LIBRARY_2|| type == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
            self.submitState = PROCESS_STATE_library_number;
        }else if(state == PROCESS_STATE_library_acceptanceed &&
                 (type == ROLE_LIBRARY_3|| type == ROLE_COMMON)){//默认营销活动已受理->已出库 驳回返回串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }else if (state == PROCESS_STATE_library_end &&
                  [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }
    }else if(selectedIndex == 3){
        
        
        if (state == PROCESS_STATE_manager_submit &&
            type == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            self.submitState = PROCESS_STATE_reject;
            
            
            //删除审核领导
            [detailMuArr removeObject:@{@"title":@"审核领导",@"type":@"Select"}];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [self.bListModel.next_processor isEqualToString:userInfo.user_id]){
            self.submitState = PROCESS_STATE_reject;
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_LIBRARY_1|| type == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_library_File;
            
            
            if (![self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                ![self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                //删除活动受理人
                [detailMuArr removeObject:@{@"title":@"活动受理人",@"type":@"Select",@"model_id":@"9"}];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }
        }else if (state == PROCESS_STATE_library_number &&
                  [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //串号已发送至客户经理->客户经理确认
            self.submitState = PROCESS_STATE_two_manager_through;
            
        } else if(state == PROCESS_STATE_library_acceptanceing &&
                  (type == ROLE_LIBRARY_2|| type == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
            self.submitState = PROCESS_STATE_library_number;
        }else if(state == PROCESS_STATE_library_acceptanceed &&
                 (type == ROLE_LIBRARY_3|| type == ROLE_COMMON)){//默认营销活动已受理->已出库 驳回返回串号已发送至客户经理
            
            self.submitState = PROCESS_STATE_library_acceptanceing;
        }else if (state == PROCESS_STATE_library_end &&
                  [self.bListModel.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
            self.submitState = PROCESS_STATE_library_acceptanceing;
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
    
    if (self.isCheckBoxUnPass && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        isDone = YES;
        return;
    }
    
    if (([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0) && (self.submitState == PROCESS_STATE_three_manager_through || self.submitState == PROCESS_STATE_manager_submit) && (self.submitState != PROCESS_STATE_reject)) {
        ALERT_ERR_MSG(@"请选择审核领导");
        isDone = YES;
        return;
    }
    
//    if (([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0) && self.submitState == PROCESS_STATE_library_acceptanceing && !self.isCheckBoxUnPass) {
//        
//        ALERT_ERR_MSG(@"请选择活动受理人");
//        
//        return;
//    }
    if (([self.next_processor_id isEqualToString:@"-1"] || self.next_processor_id.length == 0) && self.submitState == PROCESS_STATE_library_number && !self.isCheckBoxUnPass) {

        ALERT_ERR_MSG(@"请选择活动受理人");
        isDone = YES;
        return;
    }
    
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id?self.next_processor_id:@"",
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
        ALERT_ERR_MSG(@"网络连接失败");
        isDone = YES;
    }];
}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_TerminalStockSubmitViewController *vc = [[P_TerminalStockSubmitViewController alloc] initWithNibName:@"P_TerminalSubmitViewController" bundle:nil];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            vc.isEditIn = YES;
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
