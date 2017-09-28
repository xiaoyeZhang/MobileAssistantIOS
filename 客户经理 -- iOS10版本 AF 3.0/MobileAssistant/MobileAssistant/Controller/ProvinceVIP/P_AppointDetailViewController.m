//
//  P_AppointDetailViewController.m
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_AppointDetailViewController.h"
#import "CommonService.h"
#import "BusinessDetailModel.h"
#import "BusinessProcessModel.h"
#import "MJExtension.h"
#import "TwoLablesTableViewCell.h"
#import "ThreeLabelsTableViewCell.h"
#import "StringHelper.h"
#import "UserEntity.h"
#import "CheckBoxTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "UIAlertView+Blocks.h"
#import "P_APPointViewController.h"

@interface P_AppointDetailViewController ()<CheckBoxTableViewCellDelegate,
                                            UITextFieldDelegate>
{
    NSMutableArray *processMuArr;
}
@property(nonatomic, strong) BusinessDetailModel *detailModel;

///审核状态
@property(nonatomic, assign) int submitState;

///处理意见
@property(nonatomic, copy) NSString *submitDesc;

@end

@implementation P_AppointDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"预约拜访详情";
    
    super.model = NSStringFromClass([self class]);
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.submitState = PROCESS_STATE_comprehensive_through;//默认审核通过
    
    processMuArr = [[NSMutableArray alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self getBusinessDetailWithGroup:group];
    [self getBusinessProcessWithGroup:group];
    
    //任务组完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
            UserEntity *userInfo = [UserEntity sharedInstance];
            if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
                [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
                
                [self addEditBtn]; //添加编辑按钮
            }
            
            [_tableView reloadData];
            
            return;
        }
        
        
        // 刷新表格
        [_tableView reloadData];
    });
    

    UserEntity *userInfo = [UserEntity sharedInstance];
    if ([self.bListModel.state intValue] == PROCESS_STATE_manager_submit&&
        ([userInfo.type_id intValue] == ROLE_VISIT|[userInfo.type_id intValue] == ROLE_COMMON)) { //综合审批
        [self addSubmitBtn];
    }
}

#pragma mark - ButtonMethod

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSubmitBtn
{
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEditBtn
{
    UIButton *recieveBtn = [self setNaviRightBtnWithTitle:@"编辑"];
    [recieveBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    if ([self.bListModel.state intValue] == PROCESS_STATE_manager_submit&&
        ([userInfo.type_id intValue] == ROLE_VISIT|[userInfo.type_id intValue] == ROLE_COMMON)) { //综合审批
        
        
        [self.view endEditing:YES];
        
        if (self.submitState == PROCESS_STATE_reject &&
            self.submitDesc.length == 0) {
            ALERT_ERR_MSG(@"请输入驳回理由");
            isDone = YES;
            return;
        }
        
        NSDictionary *dict = @{@"state":@(self.submitState),
                               @"business_id":self.bListModel.business_id,
                               @"user_id":userInfo.user_id,
                               @"method":@"change_state",
                               @"next_processor":@"-1",
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
        
    }else{
        isDone = YES;
    }
}

//驳回后重新编辑
- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_APPointViewController *vc = [[P_APPointViewController alloc] init];
            vc.detailModel = self.detailModel;
            vc.bListModel = self.bListModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -

- (void)getBusinessDetailWithGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
    
    NSDictionary *dict = @{@"business_id":self.bListModel.business_id,
                           @"method":@"business_detail"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            self.detailModel = [BusinessDetailModel objectWithKeyValues:entity[@"content"]];
        }
        
        dispatch_group_leave(group);
        
    } Failed:^(int errorCode, NSString *message) {
        
        dispatch_group_leave(group);
    }];
}

- (void)getBusinessProcessWithGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
    
    NSDictionary *dict = @{@"business_id":self.bListModel.business_id,
                           @"method":/*@"business_process"*/@"business_process_new"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [processMuArr removeAllObjects];
            
            NSArray *arr = [BusinessProcessModel objectArrayWithKeyValuesArray:entity[@"content"]];
            [processMuArr addObjectsFromArray:arr];
        }
        
        dispatch_group_leave(group);
    } Failed:^(int errorCode, NSString *message) {
        dispatch_group_leave(group);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.detailModel) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        
        UserEntity *userInfo = [UserEntity sharedInstance];
        if ([self.bListModel.state intValue] == PROCESS_STATE_manager_submit&&
            ([userInfo.type_id intValue] == ROLE_VISIT|[userInfo.type_id intValue] == ROLE_COMMON)) {
            rows = 13;
        }else{
            rows = 11;
        }
        
        if ([self.bListModel.state intValue] == PROCESS_STATE_reject) {
            rows += 1; //被驳回时添加驳回理由
        }
        
    }else{
        rows = processMuArr.count + 1;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"ThreeLabelsTableViewCell";
    static NSString *identifier3 = @"CheckBoxTableViewCell";
    static NSString *identifier4 = @"TxtFieldTableViewCell";
    
    if (indexPath.section == 0) {
        
        if ((([self.bListModel.state intValue] == PROCESS_STATE_reject) && (indexPath.row < 12)) |
            (([self.bListModel.state intValue] != PROCESS_STATE_reject) && (indexPath.row < 11))) {
            TwoLablesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.subTitleLbl.text = nil;
            }
            
            BusinessProcessModel *model = [processMuArr firstObject];
            
            
            switch (indexPath.row) {
                case 0:
                    cell.titleLbl.text = @"预约领导:";
                    cell.subTitleLbl.text = self.detailModel.leader_name;
                    break;
//                case 1:
//                    cell.titleLbl.text = @"领导电话:";
//                    cell.subTitleLbl.text = self.detailModel.leader_tel;
//                    break;
                case 1:
                    cell.titleLbl.text = @"集团单位:";
                    cell.subTitleLbl.text = self.detailModel.company_name;
                    break;
                case 2:
                    cell.titleLbl.text = @"集团编号:";
                    cell.subTitleLbl.text = self.detailModel.company_num;
                    break;
                case 3:
                    cell.titleLbl.text = @"客户姓名:";
                    cell.subTitleLbl.text = self.detailModel.client_name;
                    break;
                case 4:
                    cell.titleLbl.text = @"客户职务:";
                    cell.subTitleLbl.text = self.detailModel.job;
                    break;
                case 5:
                    cell.titleLbl.text = @"拜访说明:";
                    cell.subTitleLbl.text = self.detailModel.visit_info;
                    break;
                case 6:
                    cell.titleLbl.text = @"备       注:";
                    cell.subTitleLbl.text = self.detailModel.visit_remarks;
                    break;
                case 7:
                    cell.titleLbl.text = @"客户经理:";
                    cell.subTitleLbl.text = self.detailModel.client_name;
                    break;
                case 8:
                    cell.titleLbl.text = @"经理电话:";
                    cell.subTitleLbl.text = self.detailModel.msger_tel;
                    break;
                case 9:
                {                    
                    cell.titleLbl.text = @"申请部门:";
                    cell.subTitleLbl.text = self.bListModel.dep_name;
                    break;
                }
                case 10:
                {
                    cell.titleLbl.text = @"状       态:";
                    
                    if ([model.state intValue] == 99) {
                        model = processMuArr[1];
                    }
                    
                    NSString *state = [StringHelper getBusinessStateString:model.state];
                    cell.subTitleLbl.text = state;
                    break;
                }
                case 11:
                {
                    cell.titleLbl.text = @"处理意见:";
                    if (processMuArr.count > 0) {
                        cell.subTitleLbl.text = [processMuArr[0] valueForKey:@"info"];
                    }
                    
                    break;
                }
                    
                default:
                    cell.titleLbl.text = nil;
                    cell.subTitleLbl.text = nil;
                    break;
            }
            
            return cell;
        }else if ((([self.bListModel.state intValue] == PROCESS_STATE_reject) && (indexPath.row == 12)) |
                  (([self.bListModel.state intValue] != PROCESS_STATE_reject) && (indexPath.row == 11))){ //审核
            CheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                cell.delegate = self;
            }
            
            cell.titleLbl.text = @"意       见:";
            
            [cell setSelectDataWithArray:@[@"是",@"否"]];
            if (self.submitState > 0) {
                [cell setSelectBtnIndex:1];
            }else{
                [cell setSelectBtnIndex:2];
            }
            
            return cell;
        }else {
            TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier4
                                                      owner:nil
                                                    options:nil] firstObject];
                cell.txtField.delegate = self;
                cell.txtField.placeholder = @"请输入客户经理预约拜访的处理意见";
            }
            
            cell.indexPath = indexPath;
            cell.txtField.tag = indexPath.row;
            
            cell.titleLbl.text = @"处理意见:";
            
            cell.txtField.text = self.submitDesc;
            
            return cell;
        }
        
    }else{
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"状态";
            cell.middleLbl.text = @"受理人";
            cell.rightLbl.text = @"时间";
        }else{
//            BusinessProcessModel *model = processMuArr[indexPath.row-1];
//            
//            cell.leftLbl.text = [StringHelper getBusinessStateString:model.state];
//            cell.middleLbl.text = model.user_name;
//            cell.rightLbl.text = model.time;
            BusinessProcessModel *model = processMuArr[indexPath.row-1];
            
            if ([model.state intValue] == 99) {
                NSArray *arr = [model.user_name componentsSeparatedByString:@","];
                if ([arr count] == 2) {
                    cell.leftLbl.text = [NSString stringWithFormat:@"%@待处理",[StringHelper getUserType:[arr[0] intValue]]];
                    cell.middleLbl.text = arr[1];
                    cell.rightLbl.text = model.time;
                }
            }else{
                cell.leftLbl.text = [StringHelper getBusinessStateString:model.state];
                cell.middleLbl.text = model.user_name;
                cell.rightLbl.text = model.time;
            }
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 1) {
        title = @"> 处理记录";
    }
    
    return title;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (!cell.isNeedSelect) {
            self.submitDesc = textField.text;
        }
    }
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    if ([self.bListModel.state intValue] == PROCESS_STATE_manager_submit&&
        ([userInfo.type_id intValue] == ROLE_VISIT|[userInfo.type_id intValue] == ROLE_COMMON)) {
        
        if (selectedIndex == 1) {
            self.submitState = PROCESS_STATE_comprehensive_through;
        }else{
            self.submitState = PROCESS_STATE_reject;
        }
    }
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the tableView it might be occluding
    keyboardFrame = [_tableView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, _tableView.bounds);
    
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
            _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
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
