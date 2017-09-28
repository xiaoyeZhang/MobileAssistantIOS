//
//  P_StockDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_StockDetailViewController.h"
#import "P_StockSubmitViewController.h"

@interface P_StockDetailViewController ()

@property(nonatomic,copy) NSString *stock_num;///退库数量

@end

@implementation P_StockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"终端退库详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"退库原因",@"detail":@"refund_reason",@"type":@"Label"},
                   @{@"title":@"备      注",@"detail":@"refund_remarks",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
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
    
    if (state >= PROCESS_STATE_retired_library) { //已办卡 添加办理号码到详情
        [detailMuArr insertObject:@{@"title":@"退库数量",@"process":@"remark",@"type":@"Label"} atIndex:detailMuArr.count-1];
    }
    
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
             ([userInfo.type_id intValue] == ROLE_RETREAT |[userInfo.type_id intValue] == ROLE_COMMON)){ //二级经理审批 -> 营销接收
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入退库的处理意见"},
                           @{@"title":@"退库数量",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认退库
            self.submitState = PROCESS_STATE_retired_library;
        }
        
        [self addSubmitBtnWithTitle:@"退库"];
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
    if (section == 1) {
        NSArray *arr = [self.detailDict[@"refund_info"] componentsSeparatedByString:@";"];
        
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
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"需求机型";
            cell.middleLbl.text = @"数量";
            cell.rightLbl.text = @"颜色";
        }else{
            NSArray *deviceArr = [self.detailDict[@"refund_info"] componentsSeparatedByString:@";"];
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
        return @"> 申请机型列表";
    }else{
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.submitState == PROCESS_STATE_retired_library) {
        TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
            if ([cell.titleLbl.text isEqualToString:@"退库数量:"]) {
                self.stock_num = textField.text;
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
        if(state == PROCESS_STATE_manager_submit &&
           [userInfo.type_id intValue] == ROLE_THREE){ //三级经理审批
            
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
                  ([userInfo.type_id intValue] == ROLE_RETREAT| [userInfo.type_id intValue] == ROLE_COMMON)){ //二级经理审批 -> 营销接收
            
//            self.submitState = PROCESS_STATE_retired_library;
            if (self.submitState == PROCESS_STATE_reject) {
                [detailMuArr addObject:@{@"title":@"退库数量",@"type":@"Input"}];
                
                self.submitState = PROCESS_STATE_retired_library;
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }else{
                self.submitState = PROCESS_STATE_retired_library;
            }
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        if(state == PROCESS_STATE_manager_submit &&
           [userInfo.type_id intValue] == ROLE_THREE){ //三级经理审批
            
            [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
        }else if(state == PROCESS_STATE_two_manager_through &&
                 ([userInfo.type_id intValue] == ROLE_RETREAT| [userInfo.type_id intValue] == ROLE_COMMON)){ //二级经理审批 -> 营销接收
            
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
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    
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
    
    
    if (state == PROCESS_STATE_manager_submit &&
        [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
        
        if ((!self.next_processor_id || [self.next_processor_id isEqualToString:@"-1"]) &&
            (self.submitState != PROCESS_STATE_reject)) {
            ALERT_ERR_MSG(@"请选择审核的二级经理");
            isDone = YES;
            return;
        }
    }
    
    if (state == PROCESS_STATE_two_manager_through) { //终端接收
        if (self.stock_num.length == 0 && self.submitState != PROCESS_STATE_reject) {
            ALERT_ERR_MSG(@"请输入退库数量");
            isDone = YES;
            return;
        }
        
        NSString *devicesStr = self.detailDict[@"refund_info"];
        NSArray *array = [devicesStr componentsSeparatedByString:@";"];
        
        int count = 0;
        if ([array count] > 0) {
            for (NSString *device in array) {
                NSArray *dev = [device componentsSeparatedByString:@","];
                if (dev.count == 3) {
                    count += [dev[1] intValue];
                }
            }
        }
        
        if ([self.stock_num intValue] > count) {
            ALERT_ERR_MSG(@"退库数量不能大于机型的数量的总和");
            isDone = YES;
            return;
        }
    }
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"",
                           @"remark":self.stock_num?self.stock_num:@""};
    
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
            
            
            P_StockSubmitViewController *vc = [[P_StockSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
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
