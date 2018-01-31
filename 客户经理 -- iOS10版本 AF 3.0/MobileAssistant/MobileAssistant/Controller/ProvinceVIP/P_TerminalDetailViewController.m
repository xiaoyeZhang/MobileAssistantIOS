//
//  P_TerminalDetailViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalDetailViewController.h"
#import "P_TerminalSubmitViewController.h"
#import "ImagesBrowserViewController.h"

@interface P_TerminalDetailViewController ()

@property(nonatomic, copy) NSString *actualReceived; /*实际到货*/

@end

@implementation P_TerminalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端办理详情";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",@"detail":@"num",@"type":@"Label"},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"Label"},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label"},
                   @{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Label"},
                   @{@"title":@"电       话",@"detail":@"client_tel",@"type":@"Label"},
                   @{@"title":@"备       注",@"detail":@"remarks",@"type":@"Label"},
                   @{@"title":@"订货类型",@"detail":@"order_type",@"type":@"Label"},
                   @{@"title":@"订货合同",@"list":@"picname",@"type":@"Btn"},
                   @{@"title":@"到货时间",@"detail":@"order_time",@"type":@"Label"},
                   @{@"title":@"客户经理",@"list":@"user_name",@"type":@"Label"},
                   @{@"title":@"申请部门",@"list":@"dep_name",@"type":@"Label"},
                   @{@"title":@"状       态",@"process":@"state",@"type":@"Label"},nil];
    
    [_tableView reloadData];
}

//#pragma mark - 获取合同图片
//
//- (void)getTerminalPic
//{
//    NSDictionary *dict = @{@"method":@"getPic",
//                           @"business_id":self.bListModel.business_id};
//    
//    CommonService *service = [[CommonService alloc] init];
//    
//    [service getNetWorkData:dict
//                  Successed:^(id entity) {
//                      
//                      NSString *imagesStr = entity[@"picname"];
//                      if (imagesStr.length > 0) {
//                          imagesStr = [imagesStr substringFromIndex:1];//去掉第一位逗号
//                          
//                          NSArray *imagesArr = [imagesStr componentsSeparatedByString:@","];
//                          
//                      }
//                      
//                  } Failed:^(int errorCode, NSString *message) {
//                      
//                  }];
//}

#pragma mark -

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    int userType = [userInfo.type_id intValue];
    
    NSString *orderType = self.detailDict[@"order_type"];
    
    if (([orderType isEqualToString:@"赠送机"]|
         [orderType isEqualToString:@"赠送礼品"]|
         [orderType isEqualToString:@"集团关键联系人保底购机活动"]|
         [orderType isEqualToString:@"业务"]|
         [orderType containsString:@"重要客户（AB类）新业务体验营销活动"])) {
        
        //此处无需显示订货合同
        [detailMuArr removeObjectAtIndex:7];
        if ([orderType isEqualToString:@"集团关键联系人保底购机活动"] | [orderType containsString:@"重要客户（AB类）新业务体验营销活动"]) {
            [detailMuArr addObject:@{@"title":@"保底金额",@"detail":@"minimum_guarantee_amount",@"type":@"Label"}];
            [detailMuArr addObject:@{@"title":@"刚性成本金额",@"detail":@"rigid_amount",@"type":@"Label"}];
        }

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
    
    if (state == PROCESS_STATE_manager_submit &&
        userType == ROLE_THREE) { //客户经理已提交 -> 行业总监审核
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核领导",@"type":@"Select"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认行业总监审核通过
            self.submitState = PROCESS_STATE_Industry_director;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_Industry_director &&
              userType == ROLE_THREE) { //行业总监审核 -> 三级经理审批
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认三级经理通过
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }else if (state == PROCESS_STATE_three_manager_through &&
              userType == ROLE_TERMINAL) { //三级经理通过 -> 综合填写到货情况
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"到货机型",@"type":@"AddDevice"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入实际到货情况的处理意见"}];
        
        if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
            [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
            array = @[@{@"title":@"意       见",@"type":@"Check"},
                      @{@"title":@"到货业务",@"type":@"AddDevice"},
                      @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入实际到货情况的处理意见"}];
        }
        
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认已填写实际到货情况
            self.submitState = PROCESS_STATE_actual_arrival;
        }
        
        [self addSubmitBtn];
    }else if(state == PROCESS_STATE_actual_arrival &&
             [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //综合填写到货情况 -> 客户经理确认
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入是否按实际情况出货的处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认客户经理确认
            self.submitState = PROCESS_STATE_manager_confirm;
        }
        
        [self addSubmitBtn];
    }/*else if(state == PROCESS_STATE_manager_confirm &&
             (type == ROLE_TERMINAL | type == ROLE_COMMON)){ //客户经理确认 -> 综合部发货
        
        if (!self.submitState) { //发货
            self.submitState = PROCESS_STATE_delivery;
        }
        
        [self addSubmitBtnWithTitle:@"发货" action:@selector(sendBtnClicked:)];
    }else if(state == PROCESS_STATE_delivery &&
             [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //综合部发货 -> 客户经理收货
        
        if ([[processMuArr[0] valueForKey:@"state"] intValue] != 99) {
            self.actualReceived = [processMuArr[0] valueForKey:@"info"];
        }else{
            self.actualReceived = [processMuArr[1] valueForKey:@"info"];
        }
        
        if (!self.submitState) { //收货
            self.submitState = PROCESS_STATE_delivered;
        }
        
        [self addSubmitBtnWithTitle:@"收货" action:@selector(recieveBtnClicked:)];
    }*/
    else if (state == PROCESS_STATE_manager_confirm &&
             userType == ROLE_TERMINAL){ //客户经理确认->支撑人员确认
        NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                           @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入对确认出货的处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //默认支撑人员确认
            self.submitState = PROCESS_STATE_delivery;
        }
        
        [self addSubmitBtn];
    }else if (userType == ROLE_COMMON){
        NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
        if (arr.count>3) {
            NSString *config = arr[3];
            NSRange range = [config rangeOfString:self.bListModel.state];
            if (range.length > 0) { //当通用人员可执行状态包含当前状态
                if (state == PROCESS_STATE_three_manager_through) { //综合填写到货情况
                    NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                       @{@"title":@"到货机型",@"type":@"AddDevice"},
                                       @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入实际到货情况的处理意见"}];
                    
                    if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                        [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                        array = @[@{@"title":@"意       见",@"type":@"Check"},
                                  @{@"title":@"到货业务",@"type":@"AddDevice"},
                                  @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入实际到货情况的处理意见"}];
                    }
                    
                    
                    [detailMuArr addObjectsFromArray:array];
                    
                    if (!self.submitState) { //默认已填写实际到货情况
                        self.submitState = PROCESS_STATE_actual_arrival;
                    }
                    
                    [self addSubmitBtn];
                }else if (state == PROCESS_STATE_manager_confirm){ //支撑人员确认
                    
                    NSArray *array = @[@{@"title":@"意       见",@"type":@"Check"},
                                       @{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入对确认出货的处理意见"}];
                    
                    [detailMuArr addObjectsFromArray:array];
                    
                    if (!self.submitState) { //默认支撑人员确认
                        self.submitState = PROCESS_STATE_delivery;
                    }
                    
                    [self addSubmitBtn];
                }
            }
        }
    }
    
    //已填写实际到货情况
    if (state >= PROCESS_STATE_actual_arrival) {
//        if ([[processMuArr[0] valueForKey:@"state"] intValue] != 99) {
//            self.actualReceived = [processMuArr[0] valueForKey:@"remark"];
//        }else{
//            self.actualReceived = [processMuArr[1] valueForKey:@"remark"];   
//        }
        for (BusinessProcessModel *model in processMuArr) {
            if (model.remark && model.remark.length > 0) {
                
                self.actualReceived = model.remark;
                break;
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.actualReceived) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) { //申请机型
        
        NSArray *arr = [self.detailDict[@"order_info"] componentsSeparatedByString:@";"];
        
        NSInteger rows = [arr count]>0?[arr count]+1:0;
        
        return rows;
    }else if (section == 2){
        
        if (self.actualReceived) { //实际到货
            NSArray *arr = [self.actualReceived componentsSeparatedByString:@";"];

            NSInteger rows = [arr count]>0?[arr count]+1:0;

            return rows;
        }else{
            return [super tableView:tableView numberOfRowsInSection:section];
        }
        
    } else{
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
            if (infoArr.count == 3 | infoArr.count == 4) {
                cell.leftLbl.text = infoArr[0];
                cell.middleLbl.text = infoArr[1];
                cell.rightLbl.text = infoArr[2];
            }
        }
        
        return cell;
        
        
    }else if(indexPath.section == 2){
        if (self.actualReceived) {
            
            ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lablesIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:lablesIdentifier owner:nil options:nil] firstObject];
                cell.leftLbl.text = nil;
                cell.middleLbl.text = nil;
                cell.rightLbl.text = nil;
                
//                cell.leftLbl.textAlignment = NSTextAlignmentLeft;
//                cell.middleLbl.textAlignment = NSTextAlignmentLeft;
//                cell.rightLbl.textAlignment = NSTextAlignmentLeft;
                
            }
            
            if (indexPath.row == 0) {
   
                    
                cell.leftLbl.text = @"到货机型";
                cell.middleLbl.text = @"数量";
                cell.rightLbl.text = @"颜色";
//                cell.leftLbl.text = @"    到货机型";
//                cell.middleLbl.text = @"    数量";
//                cell.rightLbl.text = @"颜色";
                
                if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                    [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                    cell.leftLbl.text = @"业务名称";
                }
            }else{
                NSString *info = nil;
                if (self.actualReceived) {
                    info = self.actualReceived;
                }else{
                    info = self.detailDict[@"order_info"];
                }
                
                NSArray *deviceArr = [info componentsSeparatedByString:@";"];
                NSString *deviceStr = deviceArr[indexPath.row-1];

                NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
                if (infoArr.count == 3 | infoArr.count == 4) {
                    cell.leftLbl.text = infoArr[0];
                    cell.middleLbl.text = infoArr[1];
                    cell.rightLbl.text = infoArr[2];
//                    
//                    cell.leftLbl.text = [NSString stringWithFormat:@"      %@",infoArr[0]];
//                    cell.middleLbl.text = [NSString stringWithFormat:@"     %@",infoArr[1]];
//                    cell.rightLbl.text = infoArr[2];
                }
//                if(infoArr.count == 4){
//                
////                    cell.leftLbl.textAlignment = NSTextAlignmentLeft;
////                    cell.middleLbl.textAlignment = NSTextAlignmentLeft;
////                    cell.rightLbl.textAlignment = NSTextAlignmentLeft;
////                    
////                    cell.leftLbl.text = [NSString stringWithFormat:@"    %@",infoArr[0]];
////                    cell.middleLbl.text = infoArr[1];
////                    cell.rightLbl.text = infoArr[2];
//                    
//                    UIButton *showNumBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 5, 60, 30)];
//                    
//                    showNumBtn.tag = indexPath.row;
//                    
//                    showNumBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//                    
//                    [showNumBtn setTitle:@"查看串号" forState:UIControlStateNormal];
//                    
//                    [showNumBtn setTitleColor:RGBA(28, 133, 191, 1) forState:UIControlStateNormal];
//                    
//                    [showNumBtn addTarget:self action:@selector(isChickshowNumBtn:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    [cell addSubview:showNumBtn];
//                    
//                }
            }

            return cell;
        }else{
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
        }
    } else{
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
    }else if (section == 2){
        if (self.actualReceived) {
            if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                return @"> 实际到货业务列表";
            }
            
            return @"> 实际到货机型列表";
        }else{
            return [super tableView:tableView titleForHeaderInSection:section];
        }
    } else{
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL rs = [super textFieldShouldBeginEditing:textField];
    
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (cell.isNeedSelect) {
            
            NSDictionary *dict = detailMuArr[textField.tag];
            NSString *type = dict[@"type"]; //类型
            
            if ([type isEqualToString:@"AddDevice"]){
                P_AddDevicesViewController *vc = [[P_AddDevicesViewController alloc] init];
                if (self.actualReceived) {
                    vc.device_info = self.actualReceived;
                }else{
                    vc.device_info = self.detailDict[@"order_info"];
                }
                vc.order_type = self.detailDict[@"order_type"];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
                
                return NO;
            }
        }
    }
    
    return rs;
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    [super checkBoxTableViewCell:cell checkDidChanged:selectedIndex];
    
    UserEntity *userInfo = [UserEntity sharedInstance];

    int state = [self.bListModel.state intValue];
    int userType = [userInfo.type_id intValue];
    
    if (selectedIndex == 1) {
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批

            self.submitState = PROCESS_STATE_Industry_director;
            
        }else if (state == PROCESS_STATE_Industry_director &&
                  userType == ROLE_THREE){
            
            self.submitState = PROCESS_STATE_three_manager_through;
            
        }else if (state == PROCESS_STATE_three_manager_through &&
                  (userType == ROLE_TERMINAL | userType == ROLE_COMMON)){
        
            if (self.submitState == PROCESS_STATE_reject) {
                if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|[self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                    [detailMuArr insertObject:@{@"title":@"到货业务",@"type":@"AddDevice"} atIndex:detailMuArr.count-1];
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [detailMuArr insertObject:@{@"title":@"到货机型",@"type":@"AddDevice"} atIndex:detailMuArr.count-1];
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.submitState = PROCESS_STATE_actual_arrival;
            
        } else if(state == PROCESS_STATE_actual_arrival &&
                 [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //综合填写到货情况 -> 客户经理确认
            
            self.submitState = PROCESS_STATE_manager_confirm;
        }else if (state == PROCESS_STATE_manager_confirm &&
                  (userType == ROLE_TERMINAL | userType == ROLE_COMMON)){ //客户经理确认->支撑人员确认
            self.submitState = PROCESS_STATE_delivery;
        }
    }else{
        self.submitState = PROCESS_STATE_reject;
        
        if (state == PROCESS_STATE_three_manager_through &&
            (userType == ROLE_TERMINAL | userType == ROLE_COMMON)) {
            
            self.actualReceived = nil;
            
            //删除填写到货机型
            [detailMuArr removeObjectAtIndex:detailMuArr.count-2];
            
            [_tableView reloadData];
            
            return;
        }
        
        if (state == PROCESS_STATE_actual_arrival &&
            [userInfo.user_id isEqualToString:self.bListModel.create_id]) {
            self.submitState = PROCESS_STATE_manager_confirm;
        }else if(state == PROCESS_STATE_manager_confirm &&
                 (userType == ROLE_TERMINAL | userType == ROLE_COMMON)){
            self.submitState = PROCESS_STATE_delivery;//终端订货，最后一个节点，支撑人员通过不通过，状态都为”支撑人员已确认“
        }
    }
}

#pragma mark - AddDevicesViewControllerDelegate

- (void)addDevicesViewController:(P_AddDevicesViewController *)vc addDevicesInfo:(NSString *)info
{
    self.actualReceived = info;
    
    [_tableView reloadData];
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
    
    int state = [self.bListModel.state intValue];
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (state == PROCESS_STATE_manager_submit &&
        [userInfo.type_id intValue] == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
        
        if ((!self.next_processor_id || [self.next_processor_id isEqualToString:@"-1"]) &&
            (self.submitState != PROCESS_STATE_reject)) {
            ALERT_ERR_MSG(@"请选择审核的下级经理");
            isDone = YES;
            return;
        }
    }
    
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
    

    if (state == PROCESS_STATE_three_manager_through &&
        ([userInfo.type_id intValue] == ROLE_TERMINAL | [userInfo.type_id intValue]==ROLE_COMMON) && self.submitState != PROCESS_STATE_reject) { //客户支撑组填写实际到货情况
        
        if (self.actualReceived.length == 0) {
            
            if ([self.detailDict[@"order_type"] isEqualToString:@"赠送礼品"]|
                [self.detailDict[@"order_type"] isEqualToString:@"业务"]) {
                ALERT_ERR_MSG(@"请输入实际到货业务");
                isDone = YES;
                return;
            }
            
            ALERT_ERR_MSG(@"请输入实际到货机型");
            isDone = YES;
            return;
        }
    }
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.bListModel.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"-1",
                           @"remark":self.actualReceived?self.actualReceived:@""
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        isDone = YES;
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];

        if ([strState isEqualToString:@"1"]) {
            
            if (self.submitState == PROCESS_STATE_manager_confirm) {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提交成功" message:@"当支撑人员确认出货后请及时添加出库工单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
                
                return;
            }
            
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

//- (void)sendBtnClicked:(id)sender
//{
//    [self.view endEditing:YES];
//    
//    int state = [self.bListModel.state intValue];
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    
//    if(state == PROCESS_STATE_manager_confirm &&
//       ([userInfo.type_id intValue] == ROLE_TERMINAL | [userInfo.type_id intValue]==ROLE_COMMON)){ //综合部发货
//        
//        NSDictionary *dict = @{@"state":@(self.submitState),
//                               @"business_id":self.bListModel.business_id,
//                               @"user_id":userInfo.user_id,
//                               @"method":@"change_state",
//                               @"next_processor":self.next_processor_id,
//                               @"info":self.submitDesc?self.submitDesc:@""};
//        
//        CommonService *service = [[CommonService alloc] init];
//        
//        [service getNetWorkData:dict Successed:^(id entity) {
//            int state = [entity[@"state"] intValue];
//            
//            if (state == 1) {
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//                }];
//            }else{
//                ALERT_ERR_MSG(@"提交失败");
//            }
//        } Failed:^(int errorCode, NSString *message) {
//            
//        }];
//    }
//}
//
//- (void)recieveBtnClicked:(id)sender
//{
//    int state = [self.bListModel.state intValue];
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    
//    if(state == PROCESS_STATE_delivery &&
//       [userInfo.user_id isEqualToString:self.bListModel.create_id]){ //客户经理收货
//        
//        NSDictionary *dict = @{@"state":@(self.submitState),
//                               @"business_id":self.bListModel.business_id,
//                               @"user_id":userInfo.user_id,
//                               @"method":@"change_state",
//                               @"next_processor":self.next_processor_id,
//                               @"info":self.submitDesc?self.submitDesc:@""};
//        
//        CommonService *service = [[CommonService alloc] init];
//        
//        [service getNetWorkData:dict Successed:^(id entity) {
//            int state = [entity[@"state"] intValue];
//            
//            if (state == 1) {
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//                }];
//            }else{
//                ALERT_ERR_MSG(@"提交失败");
//            }
//        } Failed:^(int errorCode, NSString *message) {
//            
//        }];
//    }
//}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_TerminalSubmitViewController *vc = [[P_TerminalSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
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

- (void)isChickshowNumBtn:(UIButton *)sender{
    
    NSString *info = nil;
    if (self.actualReceived) {
        info = self.actualReceived;
    }else{
        info = self.detailDict[@"order_info"];
    }
    
    NSArray *deviceArr = [info componentsSeparatedByString:@";"];
    NSString *deviceStr = deviceArr[sender.tag-1];
    
    NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
    
    ALERT_ERR_MSG(infoArr[3]);
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
