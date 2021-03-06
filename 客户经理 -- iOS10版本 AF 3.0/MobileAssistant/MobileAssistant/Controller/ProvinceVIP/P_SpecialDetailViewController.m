//
//  P_SpecialDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/6.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_SpecialDetailViewController.h"
#import "P_SpecialSubmitViewController.h"
#import "P_pic_ulrViewController.h"

@interface P_SpecialDetailViewController ()

@property(nonatomic, copy) NSString *make_card_num; //办理号码
@property(nonatomic, copy) NSString *Have_Guadan; //挂单理由
@end

@implementation P_SpecialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    super.model = NSStringFromClass([self class]);
    
    self.title = @"特号详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:@{@"title":@"编       号",@"list":@"num",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"机主姓名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"机主职务",@"detail":@"job",@"type":@"Label"},
                   @{@"title":@"特号等级",@"detail":@"special_level",@"type":@"Label"},
                   @{@"title":@"特号描述",@"detail":@"special_info",@"type":@"Label"},
                   @{@"title":@"保底金额",@"detail":@"base_amount",@"type":@"Label"},
                   @{@"title":@"保底时间",@"detail":@"base_time",@"type":@"Label"},
                   @{@"title":@"需缴费用",@"detail":@"special_cost",@"type":@"Label"},
                   @{@"title":@"申请事由",@"detail":@"special_reason",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},
                   @{@"title":@"图       片",@"detail":@"state",@"type":@"Btn"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int level = [self.detailDict[@"special_level"] intValue];
    NSString *levelStr = self.detailDict[@"special_level"];
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
    
    if (state >= PROCESS_STATE_card_done && state != PROCESS_STATE_Have_Guadan) { //已办卡 添加办理号码到详情
        [detailMuArr insertObject:@{@"title":@"办理号码",@"process":@"remark",@"type":@"Label"} atIndex:detailMuArr.count-1];
    }
    
    if (level == 2 | level == 3 | [levelStr isEqualToString:@"二级特号"] | [levelStr isEqualToString:@"三级特号"]) { //2~3级特号
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
                  [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理通过 -> 二级经理审批
            NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                               @{@"title":@"审核意见",@"type":@"Input"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认二级经理通过
                self.submitState = PROCESS_STATE_two_manager_through;
            }
            
            [self addSubmitBtn];
        }else if(state == PROCESS_STATE_two_manager_through &&
                 ([userInfo.type_id intValue] == ROLE_SPECIAL)){ //二级经理通过 -> 营销特号人员
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入贵阳公司是否放号的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认特号通过
                self.submitState = PROCESS_STATE_marketing_through;
            }
            
            [self addSubmitBtn];
        }else if(state == PROCESS_STATE_marketing_through &&
                 [userInfo.type_id intValue] == ROLE_CARD_1){ //营销特号 -> 营销办卡
            
//            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input",@"keyboardType":@"number"},
//                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
            NSArray *array = @[@{@"title":@"处       理",@"type":@"Check"},
                               @{@"title":@"办理号码",@"type":@"Input",@"keyboardType":@"number"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认办卡通过
                self.submitState = PROCESS_STATE_card_done;
            }
            
            [self addSubmitBtnWithTitle:@"办卡"];
        }else if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>0) {
                NSString *config = arr[0];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length > 0) { //当通用人员可执行状态包含当前状态
                    if (state == PROCESS_STATE_two_manager_through) {
                        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入贵阳公司是否放号的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认特号通过
                            self.submitState = PROCESS_STATE_marketing_through;
                        }
                        
                        [self addSubmitBtn];
                    }else if(state == PROCESS_STATE_marketing_through){
//                        NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
//                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];

                        NSArray *array = @[@{@"title":@"处       理",@"type":@"Check"},
                                           @{@"title":@"挂单原因",@"type":@"Input",@"placeholder":@"请输入挂单原因"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认挂单通过
                            self.submitState = PROCESS_STATE_Have_Guadan;
                        }
                        [self addSubmitBtn];
//                        [self addSubmitBtnWithTitle:@"办卡"];
                    }else if(state == PROCESS_STATE_Have_Guadan){
                        NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认办卡通过
                            self.submitState = PROCESS_STATE_card_done;
                        }
                        [self addSubmitBtnWithTitle:@"办卡"];
                    }
                }else if(state == PROCESS_STATE_Have_Guadan && [userInfo.type_id intValue] == ROLE_COMMON){
                    NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
                                       @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                    
                    [detailMuArr addObjectsFromArray:array];
                    
                    if (!self.submitState) { //默认办卡通过
                        self.submitState = PROCESS_STATE_card_done;
                    }
                    [self addSubmitBtnWithTitle:@"办卡"];
                }
            }
        }
    }else if (level == 4 | level == 5 | [levelStr isEqualToString:@"四级特号"] | [levelStr isEqualToString:@"五级特号"]){
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
                  [userInfo.type_id intValue] == ROLE_SPECIAL) { //三级经理通过 -> 营销特号人员
            NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入贵阳公司是否放号的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认特号通过
                self.submitState = PROCESS_STATE_marketing_through;
            }
            
            [self addSubmitBtn];
        }else if(state == PROCESS_STATE_marketing_through &&
                 [userInfo.type_id intValue] == ROLE_CARD_1){ //营销特号 -> 营销办卡
            
            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
                               @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
            
            [detailMuArr addObjectsFromArray:array];
            
            if (!self.submitState) { //默认办卡通过
                self.submitState = PROCESS_STATE_card_done;
            }
            
            [self addSubmitBtnWithTitle:@"办卡"];
        }else if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>0) {
                NSString *config = arr[1];
                NSRange range = [config rangeOfString:self.bListModel.state];
                if (range.length > 0) { //当通用人员可执行状态包含当前状态
                    if (state == PROCESS_STATE_three_manager_through) {
                        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入贵阳公司是否放号的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认特号通过
                            self.submitState = PROCESS_STATE_marketing_through;
                        }
                        
                        [self addSubmitBtn];
                    }else if(state == PROCESS_STATE_marketing_through){
//                        NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
//                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];

                        NSArray *array = @[@{@"title":@"处       理",@"type":@"Check"},
                                           @{@"title":@"挂单原因",@"type":@"Input",@"placeholder":@"请输入挂单原因"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认挂单通过
                            self.submitState = PROCESS_STATE_Have_Guadan;
                        }
                        [self addSubmitBtn];
//                        [self addSubmitBtnWithTitle:@"办卡"];
                    }else if(state == PROCESS_STATE_Have_Guadan){
                        NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
                                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                        
                        if (!self.submitState) { //默认办卡通过
                            self.submitState = PROCESS_STATE_card_done;
                        }
                        [self addSubmitBtnWithTitle:@"办卡"];
                    }
                }else if(state == PROCESS_STATE_Have_Guadan && [userInfo.type_id intValue] == ROLE_COMMON){
                    NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},
                                       @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                    
                    [detailMuArr addObjectsFromArray:array];
                    
                    if (!self.submitState) { //默认办卡通过
                        self.submitState = PROCESS_STATE_card_done;
                    }
                    [self addSubmitBtnWithTitle:@"办卡"];
                }
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell isMemberOfClass:[TwoLablesTableViewCell class]]){
        TwoLablesTableViewCell *labelCell = (TwoLablesTableViewCell *)cell;
        if ([labelCell.titleLbl.text isEqualToString:@"特号等级:"]) {
            if ([labelCell.subTitleLbl.text isEqualToString:@"2"]) {
                labelCell.subTitleLbl.text = @"二级特号";
            }else if([labelCell.subTitleLbl.text isEqualToString:@"3"]){
                labelCell.subTitleLbl.text = @"三级特号";
            }else if([labelCell.subTitleLbl.text isEqualToString:@"4"]){
                labelCell.subTitleLbl.text = @"四级特号";
            }else if([labelCell.subTitleLbl.text isEqualToString:@"5"]){
                labelCell.subTitleLbl.text = @"五级特号";
            }
        }
    }else  if ([cell isMemberOfClass:[BtnTableViewCell class]]){
        
        BtnTableViewCell *btnlCell = (BtnTableViewCell *)cell;

        if(![[self.detailDict objectForKey:@"pic_url"] isEqualToString:@""] && self.detailDict.count > 0){
            
      
            NSString *names = [self.detailDict objectForKey:@"pic_url"];
  
            if (names.length > 0) {
                
                [btnlCell.btn setTitle:@"查看" forState:UIControlStateNormal];
            
            }else{
                
                [btnlCell.btn setTitle:@"暂无" forState:UIControlStateNormal];
            
            }
        }
    
    }

    return cell;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    if (self.submitState == PROCESS_STATE_card_done) { //办卡人员办卡
        
        TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
            if ([cell.titleLbl.text isEqualToString:@"办理号码:"]) {
                self.make_card_num = textField.text;
            }else if ([cell.titleLbl.text isEqualToString:@"处理意见:"]){
                self.submitDesc = textField.text;
            }
        }
    }else if (self.submitState == PROCESS_STATE_Have_Guadan) { //办卡人员挂单
        
        TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
            if ([cell.titleLbl.text isEqualToString:@"挂单原因:"]){
                self.Have_Guadan = textField.text;
                self.submitDesc = _Have_Guadan;
            }
        }
    }
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int level = [self.detailDict[@"special_level"] intValue];
    NSString *levelStr = self.detailDict[@"special_level"];
    int state = [self.bListModel.state intValue];
    
    if (selectedIndex == 1) {
        if (level == 2 | level == 3| [levelStr isEqualToString:@"二级特号"] | [levelStr isEqualToString:@"三级特号"]) { //2~3级特号
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                if (self.submitState == PROCESS_STATE_reject) {
                    [detailMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                    
//                    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:detailMuArr.count-1 inSection:0]]
//                                      withRowAnimation:UITableViewRowAnimationNone];
                    self.submitState = PROCESS_STATE_three_manager_through;
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    self.submitState = PROCESS_STATE_three_manager_through;
                }
            }else if (state == PROCESS_STATE_three_manager_through &&
                      [userInfo.user_id isEqualToString:self.bListModel.next_processor]) { //三级经理通过 -> 二级经理审批
                
                self.submitState = PROCESS_STATE_two_manager_through;
            }else if(state == PROCESS_STATE_two_manager_through &&
                     [userInfo.type_id intValue] == ROLE_SPECIAL){ //二级经理通过 -> 营销特号人员
                
                self.submitState = PROCESS_STATE_marketing_through;
            }else if(state == PROCESS_STATE_marketing_through &&
                     [userInfo.type_id intValue] == ROLE_CARD){ //营销特号 -> 营销办卡
                
                self.submitState = PROCESS_STATE_card_done;
            }else if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
                
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>0) {
                    NSString *config = arr[0];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if (state == PROCESS_STATE_two_manager_through) {
                            
                            self.submitState = PROCESS_STATE_marketing_through;
                            
                        }else if(state == PROCESS_STATE_marketing_through){
                            
                            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},                                                                                          @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                            
                            [detailMuArr removeObjectsInArray:array];
                            
                            [detailMuArr addObject:@{@"title":@"挂单原因",@"type":@"Input",@"placeholder":@"请输入挂单原因"}];
                            
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                      withRowAnimation:UITableViewRowAnimationNone];
                            
                            self.submitState = PROCESS_STATE_Have_Guadan;
                            
                        }
                    }
                }
            }
        }else if (level == 4 | level == 5 | [levelStr isEqualToString:@"四级特号"] | [levelStr isEqualToString:@"五级特号"]){ //4~5级特号
            if (state == PROCESS_STATE_manager_submit &&
                [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                self.submitState = PROCESS_STATE_three_manager_through;
            }else if (state == PROCESS_STATE_three_manager_through &&
                      [userInfo.type_id intValue] == ROLE_SPECIAL) { //三级经理通过 -> 营销特号人员
                
                self.submitState = PROCESS_STATE_marketing_through;
                
            }else if(state == PROCESS_STATE_marketing_through &&
                     [userInfo.type_id intValue] == ROLE_CARD){ //营销特号 -> 营销办卡
                
                
                self.submitState = PROCESS_STATE_card_done;
            }else if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
                
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>0) {
                    NSString *config = arr[1];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if (state == PROCESS_STATE_three_manager_through) {
                            
                            self.submitState = PROCESS_STATE_marketing_through;
                            
                        }else if(state == PROCESS_STATE_marketing_through){
                            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},                                                                                          @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                            
                            [detailMuArr removeObjectsInArray:array];
                            
                            [detailMuArr addObject:@{@"title":@"挂单原因",@"type":@"Input",@"placeholder":@"请输入挂单原因"}];
                            
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                      withRowAnimation:UITableViewRowAnimationNone];
                            
                            self.submitState = PROCESS_STATE_Have_Guadan;
                            
                        }
                    }
                }
            }
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        
        if (level == 2 | level == 3| [levelStr isEqualToString:@"二级特号"] | [levelStr isEqualToString:@"三级特号"]) { //2~3级特号
            if (state == PROCESS_STATE_manager_submit &&
                 [userInfo.type_id intValue] == ROLE_THREE) { //三级经理不通过
                
                [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                
//                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:detailMuArr.count-1 inSection:0]]
//                                  withRowAnimation:UITableViewRowAnimationNone];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
            }else if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
                
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>0) {
                    NSString *config = arr[0];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if(state == PROCESS_STATE_marketing_through){
                            
                            self.submitState = PROCESS_STATE_card_done;
                            
                            [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                            
                            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},                                                                                          @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                            [detailMuArr addObjectsFromArray:array];
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                      withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                }
            }
            
        }else if(level == 4 | level == 5 | [levelStr isEqualToString:@"四级特号"] | [levelStr isEqualToString:@"五级特号"]){
            if ([userInfo.type_id intValue] == ROLE_COMMON){ //通用人员
                
                NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
                if (arr.count>0) {
                    NSString *config = arr[1];
                    NSRange range = [config rangeOfString:self.bListModel.state];
                    if (range.length > 0) { //当通用人员可执行状态包含当前状态
                        if(state == PROCESS_STATE_marketing_through){
                            
                            self.submitState = PROCESS_STATE_card_done;
                            
                            [detailMuArr removeObjectAtIndex:detailMuArr.count-1];
                            
                            NSArray *array = @[@{@"title":@"办理号码",@"type":@"Input"},                                                                                          @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入支撑人员确认放号并办卡的处理意见"}];
                            [detailMuArr addObjectsFromArray:array];
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                      withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                }
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
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int level = [self.detailDict[@"special_level"] intValue];
    NSString *levelStr = self.detailDict[@"special_level"];
    int state = [self.bListModel.state intValue];
    
    if (self.submitState == PROCESS_STATE_reject &&
        self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写驳回理由");
        isDone = YES;
        return;
    }
    
//    if (self.isCheckBoxUnPass && self.submitDesc.length == 0) {
//        ALERT_ERR_MSG(@"请填写驳回理由");
//        isDone = YES;
//        return;
//    }
    
    if (level == 2 | level == 3 | [levelStr isEqualToString:@"二级特号"] | [levelStr isEqualToString:@"三级特号"]) { //2~3级特号
        if (state == PROCESS_STATE_manager_submit &&
            [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
        
            if ((!self.next_processor_id || [self.next_processor_id isEqualToString:@"-1"]) &&
                (self.submitState != PROCESS_STATE_reject)) {
                ALERT_ERR_MSG(@"请选择审核的二级经理");
                isDone = YES;
                return;
            }
        }else{
            self.next_processor_id = @"-1";
        }
    }else{
        self.next_processor_id = @"-1";
    }
    
    if(state == PROCESS_STATE_marketing_through || state == PROCESS_STATE_Have_Guadan){

        if ([userInfo.type_id intValue] == ROLE_CARD_1) {
            if (self.make_card_num.length == 0 && self.submitState != PROCESS_STATE_reject) {
                
                ALERT_ERR_MSG(@"请填写办理号码");
                isDone = YES;
                return;
            }
            
            if (self.make_card_num.length != 11) {
                ALERT_ERR_MSG(@"请输入正确的手机号码");
                isDone = YES;
                return;
            }
        }else if ([userInfo.type_id intValue] == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>0) {
                NSString *config1 = arr[0];
                NSRange range1 = [config1 rangeOfString:self.bListModel.state];
                if (range1.length > 0) { //当通用人员可执行状态包含当前状态
                    if (self.make_card_num.length == 0 && self.submitState == PROCESS_STATE_card_done) {
                        
                        ALERT_ERR_MSG(@"请填写办理号码");
                        isDone = YES;
                        return;
                    }

                    if (self.make_card_num.length != 11 && self.submitState == PROCESS_STATE_card_done) {
                        ALERT_ERR_MSG(@"请输入正确的手机号码");
                        isDone = YES;
                        return;
                    }
                    if(self.submitState == PROCESS_STATE_Have_Guadan && self.Have_Guadan.length ==0){
                        ALERT_ERR_MSG(@"请输入挂单原因");
                        isDone = YES;
                        return;
                    }
                }else{
                    if (self.make_card_num.length == 0 && self.submitState == PROCESS_STATE_card_done) {
                        
                        ALERT_ERR_MSG(@"请填写办理号码");
                        isDone = YES;
                        return;
                    }
                    
                    if (self.make_card_num.length != 11 && self.submitState == PROCESS_STATE_card_done) {
                        ALERT_ERR_MSG(@"请输入正确的手机号码");
                        isDone = YES;
                        return;
                    }
                }
                
                NSString *config2 = arr[1];
                NSRange range2 = [config2 rangeOfString:self.bListModel.state];
                if (range2.length > 0) { //当通用人员可执行状态包含当前状态
                    if (self.make_card_num.length == 0 && self.submitState == PROCESS_STATE_card_done) {
                        
                        ALERT_ERR_MSG(@"请填写办理号码");
                        isDone = YES;
                        return;
                    }
                    
                    if (self.make_card_num.length != 11 && self.submitState == PROCESS_STATE_card_done) {
                        ALERT_ERR_MSG(@"请输入正确的手机号码");
                        isDone = YES;
                        return;
                    }
                    if(self.submitState == PROCESS_STATE_Have_Guadan && self.Have_Guadan.length ==0){
                        ALERT_ERR_MSG(@"请输入挂单原因");
                        isDone = YES;
                        return;
                    }
                }else{
                    if (self.make_card_num.length == 0 && self.submitState == PROCESS_STATE_card_done) {
                        
                        ALERT_ERR_MSG(@"请填写办理号码");
                        isDone = YES;
                        return;
                    }
                    
                    if (self.make_card_num.length != 11 && self.submitState == PROCESS_STATE_card_done) {
                        ALERT_ERR_MSG(@"请输入正确的手机号码");
                        isDone = YES;
                        return;
                    }
                }
            }
        }
    }
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"",
                           @"remark":self.make_card_num?self.make_card_num:@""};
    
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

//驳回后客户经理重新编辑
- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_SpecialSubmitViewController *vc = [[P_SpecialSubmitViewController alloc] initWithNibName:@"P_TerminalSubmitViewController" bundle:nil];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
}


- (void)btnTableViewCellBtnClicked:(id)sender
{
    
    if(![[self.detailDict objectForKey:@"pic_url"] isEqualToString:@""] && self.detailDict.count > 0){
        
        
        NSString *names = [self.detailDict objectForKey:@"pic_url"];
        
        P_pic_ulrViewController *vc = [[P_pic_ulrViewController alloc] init];
        vc.pic_url = names;
        
        [self.navigationController pushViewController:vc animated:YES];

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
