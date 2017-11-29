//
//  P_BusinessDetailBaseViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/6.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BusinessDetailBaseViewController.h"
#import "iToast.h"

@interface P_BusinessDetailBaseViewController ()
{
    TwoLablesTableViewCell *cell5;
}
//解决
@property (copy, nonatomic) NSString *solve;
//满意
@property (copy, nonatomic) NSString *satisfied;

@end

@implementation P_BusinessDetailBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    super.model = NSStringFromClass([self class]);
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    processMuArr = [[NSMutableArray alloc] init];
    
    self.next_processor_id = @"-1";
    self.isCheckBoxUnPass = NO; //默认通过
    self.CheckBoxFile = @"1";
    [self initData];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self getBusinessDetailWithGroup:group];
    [self getBusinessProcessWithGroup:group];
    
    //任务组完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 刷新表格
//        [_tableView reloadData];
        [self reloadSubmitData];
    });
}

#pragma mark - UIButtonMethod

- (void)addSubmitBtn
{
    [self addSubmitBtnWithTitle:@"提交"];
}

- (void)addSubmitBtnWithTitle:(NSString *)title
{
    [self addSubmitBtnWithTitle:title action:@selector(submitBtnClicked:)];
}

- (void)addSubmitBtnWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:title];
    [submitBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEditBtn
{
    UIButton *recieveBtn = [self setNaviRightBtnWithTitle:@"编辑"];
    [recieveBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ButtonMethod

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender
{

}

- (void)editBtnClicked:(id)sender
{

}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    
}

#pragma mark -

- (void)initData
{
//    detailMuArr = [[NSMutableArray alloc] initWithObjects:@{@"title":@"编号:",@"list":@"create_time"},
//                   @{@"title":@"特号等级:",@"detail":@"special_level"},
//                   @{@"title":@"特号描述:",@"detail":@"special_info"},
//                   @{@"title":@"集团单位:",@"detail":@"company_name"},
//                   @{@"title":@"集团编号:",@"detail":@"company_num"},
//                   @{@"title":@"机主姓名:",@"detail":@"client_name"},
//                   @{@"title":@"机主职务:",@"detail":@"job"},
//                   @{@"title":@"需缴费用:",@"detail":@"special_cost"},
//                   @{@"title":@"申请事由:",@"detail":@"special_reason"},
//                   @{@"title":@"客户经理:",@"list":@"user_name"},
//                   @{@"title":@"申请部门:",@"list":@"dep_name"},
//                   @{@"title":@"状态:",@"process":@"state"},nil];
}

- (void)reloadSubmitData
{
    
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
            self.detailDict = entity[@"content"];
            
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
                           @"method":@"business_process_new"/*@"business_process"*/};
    
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGSize size = [cell5.subTitleLbl sizeThatFits:CGSizeMake(cell5.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 26;
        
    }else{
        
         return 44;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [detailMuArr count];
    }else{
        return [processMuArr count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"TxtFieldTableViewCell";
    static NSString *identifier3 = @"ThreeLabelsTableViewCell";
    static NSString *identifier4 = @"CheckBoxTableViewCell";
    static NSString *identifier5 = @"BtnTableViewCell";
    static NSString *identifier6 = @"ThreeCheckBoxTableViewCell";
    
    if (indexPath.section == 0) { //详情
        
        NSDictionary *dict = detailMuArr[indexPath.row];
        
        NSString *title = dict[@"title"];
        
        NSString *type = dict[@"type"]; //类型

        if ([type isEqualToString:@"Label"]) { //普通标签
            cell5 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell5) {
                cell5 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell5.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell5.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
            
            
            NSString *detailKey = @"";
            
            if ([[dict allKeys] containsObject:@"list"]) {
                detailKey = dict[@"list"];
                
                cell5.subTitleLbl.text = [self.bListModel valueForKey:detailKey];
            }else if ([[dict allKeys] containsObject:@"detail"]){
                detailKey = dict[@"detail"];
                
                cell5.subTitleLbl.text = self.detailDict[detailKey];
            }else if ([[dict allKeys] containsObject:@"process"]){
                detailKey = dict[@"process"];
                
                if (processMuArr.count > 0) {
                    BusinessProcessModel *processModel = processMuArr[0];
                    
                    if ([processModel.state intValue] == 99 || [processModel.state intValue] == 100) {
                        processModel = processMuArr[1];
                    }
                    
                    if ([detailKey isEqualToString:@"state"]) {
                        cell5.subTitleLbl.text = [StringHelper getBusinessStateString:[processModel valueForKey:detailKey]];
                    }else{
                        if ([detailKey isEqualToString:@"remark"]) {
                            for (BusinessProcessModel *model in processMuArr) {
                                if (model.remark && model.remark.length > 0) {
                                    processModel = model;
                                    
                                    break;
                                }
                            }
                        }
                        
                        cell5.subTitleLbl.text = [processModel valueForKey:detailKey];
                    }
                }else{
                    cell5.subTitleLbl.text = nil;
                }
            }else if ([[dict allKeys] containsObject:@"user"]){
                detailKey = dict[@"user"];
                
                cell5.subTitleLbl.text = [[UserEntity sharedInstance] valueForKey:detailKey];
            }else if ([[dict allKeys] containsObject:@"custom"]){
                detailKey = dict[@"custom"];
                
                cell5.subTitleLbl.text = detailKey;
            }
            return cell5;
        }else if([type isEqualToString:@"Check"]){
            CheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
            ThreeCheckBoxTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier6];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil] firstObject];
                cell.delegate = self;
            }
            cell.indexPath = indexPath;
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier6 owner:nil options:nil] firstObject];
                cell2.delegate = self;
            }
            
            if ([[self.detailDict objectForKey:@"order_type"] isEqualToString:@"赠送礼品"]|[[self.detailDict objectForKey:@"order_type"] isEqualToString:@"业务"]){
                cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                UserEntity *userInfo = [UserEntity sharedInstance];
                int userType = [userInfo.type_id intValue];
                if (userType == ROLE_THREE |
                    userType == ROLE_TWO) {
                    [cell setSelectDataWithArray:@[@"通过",@"不通过"]];
                }else{
                    

                    [cell setSelectDataWithArray:@[@"是",@"否"]];
                    
                }
                if (!self.isCheckBoxUnPass) {
                    [cell setSelectBtnIndex:1];
                }else{
                    [cell setSelectBtnIndex:2];
                }
                
                return cell;
            }else{
                
                cell2.titleLbl.text = [NSString stringWithFormat:@"%@:",title];;
                UserEntity *userInfo = [UserEntity sharedInstance];
                
                int state = [self.bListModel.state intValue];
                int userType = [userInfo.type_id intValue];
                if (userType == ROLE_THREE |
                    userType == ROLE_TWO) {
                    cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                    [cell setSelectDataWithArray:@[@"通过",@"不通过"]];
                    if (!self.isCheckBoxUnPass) {
                        [cell setSelectBtnIndex:1];
                    }else{
                        [cell setSelectBtnIndex:2];
                    }
                    
                    return cell;
                }else if(state == PROCESS_STATE_two_manager_through && [self.bListModel.type_id isEqualToString:@"15"] && userInfo.type_id.intValue == ROLE_COMMON){
                
                    [cell2 setSelectDataWithArray:@[@"是",@"否",@"归档"]];
                    
                    if ([self.CheckBoxFile isEqualToString:@"1"]) {
                        [cell2 setSelectBtnIndex:1];
                    }else if ([self.CheckBoxFile isEqualToString:@"2"]){
                        [cell2 setSelectBtnIndex:2];
                    }else if ([self.CheckBoxFile isEqualToString:@"3"]){
                        [cell2 setSelectBtnIndex:3];
                    }
                    
                    return cell2;
                }else if(state == PROCESS_STATE_marketing_through && ( [self.bListModel.type_id isEqualToString:@"1"] ||[self.bListModel.type_id isEqualToString:@"2"] ) && userInfo.type_id.intValue == ROLE_COMMON){
                  //特号办理  -- 处理
                    
                    cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                    [cell setSelectDataWithArray:@[@"挂单",@"办卡"]];
                    if (!self.isCheckBoxUnPass) {
                        [cell setSelectBtnIndex:1];
                    }else{
                        [cell setSelectBtnIndex:2];
                    }
                    
                    return cell;
                }else{
                    
                    cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
                    [cell setSelectDataWithArray:@[@"是",@"否"]];
                    if (!self.isCheckBoxUnPass) {
                        [cell setSelectBtnIndex:1];
                    }else{
                        [cell setSelectBtnIndex:2];
                    }
                    
                    return cell;
                }
                
            }
            
            
        }else if([type isEqualToString:@"Input"] |
                 [type isEqualToString:@"Select"] |
                 [type isEqualToString:@"DateSelect"]|
                 [type isEqualToString:@"AddDevice"]){
            TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier2
                                                     owner:nil
                                                   options:nil] firstObject];
                cell.txtField.delegate = self;
            }
            
            cell.indexPath = indexPath;
            cell.txtField.tag = indexPath.row;
            
            cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
            
            NSString *placeholder1 = dict[@"placeholder"];
            NSString *placeholder = nil;
            if (!placeholder1) {
                placeholder = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            if ([type isEqualToString:@"Input"]) {
                if (placeholder1) {
                    cell.txtField.placeholder = placeholder1;
                }else{
                    cell.txtField.placeholder = [NSString stringWithFormat:@"请输入%@",placeholder];
                }
                cell.txtField.text = self.submitDesc;
                cell.isNeedSelect = NO;
                cell.downArrowImageView.hidden = YES;
                
                NSString *keyboardType = dict[@"keyboardType"];
                if ([keyboardType isEqualToString:@"number"]) {
//                    cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
                }else{
                    cell.txtField.keyboardType = UIKeyboardTypeDefault;
                }
                
            }else if([type isEqualToString:@"Select"]){
                cell.txtField.placeholder = [NSString stringWithFormat:@"请选择%@",placeholder];
                cell.txtField.text = self.selectedUserModel.name;
                cell.isNeedSelect = YES;
                cell.downArrowImageView.hidden = NO;
            }else if ([type isEqualToString:@"DateSelect"]){
                cell.txtField.placeholder = [NSString stringWithFormat:@"请选择%@",placeholder];
                cell.isNeedSelect = YES;
                cell.downArrowImageView.hidden = YES;
            }else if ([type isEqualToString:@"AddDevice"]){
                cell.txtField.placeholder = [NSString stringWithFormat:@"请输入%@",placeholder];
                cell.txtField.text = nil;
                cell.isNeedSelect = YES;
                cell.downArrowImageView.hidden = YES;
            }
            
            return cell;
        }else if([type isEqualToString:@"Btn"]){
            BtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier5];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier5 owner:nil options:nil] firstObject];
                
                [cell.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell.btn.tag = indexPath.row;
            
            cell.titleLbl.text = [NSString stringWithFormat:@"%@:",title]; ;
            
            if (self.bListModel.picname.length > 0 || (![[self.detailDict objectForKey:@"recorded_image"] isEqualToString:@""] && self.detailDict.count > 0)) {
                NSString *names;
                if ([[self.detailDict allKeys] containsObject:@"recorded_image"] && ![[self.detailDict objectForKey:@"recorded_image"] isEqualToString:@""]) {
                    
                    names = [[self.detailDict objectForKey:@"recorded_image"] substringFromIndex:1];
                             
                }else if(self.bListModel.picname.length > 0){
                    
                    names = [self.bListModel.picname substringFromIndex:1];
                    
                }else{
                    
                }
                
                if (names.length > 0) {
                    NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
                    if (imagesNameArr.count > 0) {
                        [cell.btn setTitle:@"查看" forState:UIControlStateNormal];
                    }else{
                        [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                    }
                }else{
                    [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                }
            }else{
                [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
            }
            
            return cell;
            
        }else {
            DebugLog(@"不该有的类型:%@ title=%@",type,title);
            return nil;
        }
    }else{
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"状态";
            cell.middleLbl.text = @"受理人";
            cell.rightLbl.text = @"时间";
        }else{
            
            BusinessProcessModel *model = processMuArr[indexPath.row-1];

            if ([model.state intValue] == 99) {
                NSArray *arr = [model.user_name componentsSeparatedByString:@","];
                if ([arr count] == 2) {
                    cell.leftLbl.text = [NSString stringWithFormat:@"%@待处理",[StringHelper getUserType:[arr[0] intValue]]];
                    cell.middleLbl.text = arr[1];
                    cell.rightLbl.text = model.time;
                }
            }else if ([model.state intValue] == 100) {
                NSArray *arr = [model.user_name componentsSeparatedByString:@","];
                if ([arr count] == 2) {
                    cell.leftLbl.text = [NSString stringWithFormat:@"行业总监审核待处理"];
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
    if (section == [tableView numberOfSections]-1) {
        title = @"> 处理记录";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [tableView numberOfSections]-1) {
        if (indexPath.row == 0) {
            
        }else{
            BusinessProcessModel *model = processMuArr[indexPath.row-1];
            if ([model.state intValue] != 99 && model.info.length > 0 && ![model.info isEqualToString:@"-1"]) {
                
                iToast *toast = [iToast makeText:model.info];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:3000];
                [toast show:iToastTypeNotice];
            }
        }
       
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
//    TxtFieldTableViewCell *cell = nil;
//    if (IOS7_OR_LATER) {
//        cell = (TxtFieldTableViewCell *)[[[textField superview] superview] superview];
//    }else{
//        cell = (TxtFieldTableViewCell *)[[textField superview] superview];
//    }
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (cell.isNeedSelect) {
            
            NSDictionary *dict = detailMuArr[textField.tag];
            NSString *type = dict[@"type"]; //类型
            
            if ([type isEqualToString:@"Select"]) {
                P_UserListViewController *vc = [[P_UserListViewController alloc] init];
                vc.type_id = @"2";
                vc.dep_id = userInfo.dep_id;
                vc.delegate = self;
                if ([dict[@"model_id"] isEqualToString:@"9"]) {
                    vc.type_id = @"25";
                    vc.model_id = @"9";
                }
                [self.navigationController pushViewController:vc animated:YES];
            }else if([type isEqualToString:@"DateSelect"]){
                [textField resignFirstResponder];
                XYDatePicker *datePicker = [XYDatePicker datePicker];
                datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                datePicker.delegate = self;
                [datePicker show];
            }/*else if ([type isEqualToString:@"AddDevice"]){
                P_AddDevicesViewController *vc = [[P_AddDevicesViewController alloc] init];
                vc.device_info = self.detailDict[@"order_info"];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }*/
            
        }
        
        return !cell.isNeedSelect;
    }
    
    return YES;
}

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
    if (selectedIndex == 1) {
        self.isCheckBoxUnPass = NO;

    }else{
        self.isCheckBoxUnPass = YES;

    }
}

- (void)ThreecheckBoxTableViewCell:(ThreeCheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    if (selectedIndex == 1) {
        self.CheckBoxFile = @"1";
    }else if(selectedIndex == 2){
        self.CheckBoxFile = @"2";
    }else{
        self.CheckBoxFile = @"3";
    }
}

#pragma mark - UserListViewControllerDelegate

- (void)userListViewController:(P_UserListViewController *)vc didSelectUser:(UserListModel *)model
{
    self.selectedUserModel = model;
    self.next_processor_id = model.user_id;
    
    [_tableView reloadData];
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
