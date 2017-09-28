//
//  P_APPointViewController.m
//  MobileAssistant
//
//  Created by xy on 15/9/29.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_APPointViewController.h"
#import "TxtFieldTableViewCell.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Block.h"
#import "XYDatePicker.h"
#import "CustomerViewController.h"
#import "ContactViewController.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define LEADER_TABLE_INDEX 2 //预约领导
//#define LEADER_PHONE_TABLE_INDEX 2 //领导电话索引
#define COMPANY_TABLE_INDEX 3 //集团单位
#define COMPANY_NUM_TABLE_INDEX 4 //集团编号
#define CLIENT_NAME_TABLE_INDEX 5 //客户姓名
#define JOB_TABLE_INDEX 6 //职务
#define VISIT_INFO_TABLE_INDEX 7 //拜访说明
#define VISIT_TIME_TABLE_INDEX 8 //预约时间
#define VISIT_REMARK_TABLE_INDEX 9 //备注

@interface P_APPointViewController ()<XYDatePickerDelegate,CustomerViewControllerDelegate,ContactViewControllerDelegate>

///预约领导
@property(nonatomic, copy) NSString *appointmentLeader;

/////领导电话
//@property(nonatomic, copy) NSString *leaderPhone;

///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///客户姓名
@property(nonatomic, copy) NSString *clientName;

///职务
@property(nonatomic, copy) NSString *job;

///拜访说明
@property(nonatomic, copy) NSString *visitDesc;

///预约时间
@property(nonatomic, copy) NSString *visitTime;

///备注
@property(nonatomic, copy) NSString *visitRemarks;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@end

@implementation P_APPointViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"公司领导预约拜访";
    
    super.model = NSStringFromClass([self class]);

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.visitRemarks = @"来访";
    
    
    if (self.detailModel) {
        self.appointmentLeader = self.detailModel.leader_name;
//        self.leaderPhone = self.detailModel.leader_tel;
        self.company = self.detailModel.company_name;
        self.company_num = self.detailModel.company_num;
        self.clientName = self.detailModel.client_name;
        self.job = self.detailModel.job;
        self.visitDesc = self.detailModel.visit_info;
        self.visitTime = self.detailModel.visit_time;
        self.visitRemarks = self.detailModel.visit_remarks;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - ButtonMethod

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    
    NSString *msg = nil;
    if (self.appointmentLeader.length == 0) {
        msg = @"预约领导不能为空";
    }else if(self.company.length == 0){
        msg = @"请选择集团单位";
    }else if (self.clientName.length == 0){
        msg = @"请输入客户姓名";
    }else if (self.job.length == 0){
        msg = @"职务不能为空";
    }else if (self.visitDesc.length == 0){
        msg = @"拜访说明不能为空";
    }else if (self.visitTime.length == 0){
        msg = @"请选择预约时间";
    }
    
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":!self.detailModel?@"submit_business":@"update_business",
                           @"type_id":@"3",
                           @"msger_tel":userInfo.tel,
                           @"leader_name":self.appointmentLeader,
//                           @"leader_tel":self.leaderPhone?self.leaderPhone:@"",
                           @"company_name":self.company,
                           @"client_name":self.clientName,
                           @"job":self.job,
                           @"visit_info":self.visitDesc,
                           @"visit_time":self.visitTime,
                           @"visit_remarks":self.visitRemarks,
                           @"company_num":self.company_num,
                           @"create_id":userInfo.user_id,
                           @"title":self.appointmentLeader,
                           @"business_id":self.bListModel?self.bListModel.business_id:@""};//business_id被驳回重新编辑提交时需要
    
    CommonService *service = [[CommonService alloc] init];


    [service getNetWorkData:dict  Successed:^(id entity) {
        
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
        ALERT_ERR_MSG(message);
        isDone = YES;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    switch (indexPath.row) {
        case USER_NAME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"客户经理";
            cell.txtField.placeholder = nil;
            cell.txtField.text = userInfo.name;

            break;
        }
        case USER_DEP_TABLE_INDEX:
        {
            cell.titleLbl.text = @"申请部门";
            cell.txtField.placeholder = nil;
            cell.txtField.text = userInfo.dep_name;
            break;
        }
        case LEADER_TABLE_INDEX:
        {
            cell.titleLbl.text = @"预约领导";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.appointmentLeader;
            break;
        }
//        case LEADER_PHONE_TABLE_INDEX:
//        {
//            cell.titleLbl.text = @"领导电话";
//            cell.txtField.placeholder = @"不知道可不填";
//            cell.txtField.text = self.leaderPhone;
//            break;
//        }
        case COMPANY_TABLE_INDEX:
        {
            cell.titleLbl.text = @"集团单位";
            cell.txtField.placeholder = @"请选择集团名称";
            cell.txtField.text = self.company;
            break;
        }
        case COMPANY_NUM_TABLE_INDEX:
        {
            cell.titleLbl.text = @"集团编号";
            cell.txtField.placeholder = @"选择集团单位后自动生成";
            cell.txtField.text = self.company_num;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"客户姓名";
            cell.txtField.placeholder = nil;//@"请选择客户姓名";
            cell.txtField.text = self.clientName;
            break;
        }
        case JOB_TABLE_INDEX:
        {
            cell.titleLbl.text = @"职       务";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.job;
            break;
        }
        case VISIT_INFO_TABLE_INDEX:
        {
            cell.titleLbl.text = @"拜访说明";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.visitDesc;
            break;
        }
        case VISIT_TIME_TABLE_INDEX:
        {
            cell.titleLbl.text = @"预约时间";
            cell.txtField.placeholder = @"请选择预约时间";
            cell.txtField.text = self.visitTime;
            break;
        }
        case VISIT_REMARK_TABLE_INDEX:
        {
            cell.titleLbl.text = @"备       注";
            cell.txtField.placeholder = nil;
            cell.txtField.text = self.visitRemarks;
            break;
        }
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == USER_NAME_TABLE_INDEX |
        textField.tag == USER_DEP_TABLE_INDEX |
        textField.tag == COMPANY_NUM_TABLE_INDEX){
        return NO;
    }else if(textField.tag == COMPANY_TABLE_INDEX){ //集团单位
        
        [self.view endEditing:YES];
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if (textField.tag == CLIENT_NAME_TABLE_INDEX){ //客户姓名
        
//        [self.view endEditing:YES];
//        
//        ContactViewController *vc = [[ContactViewController alloc] init];
//        vc.compEntity = self.selectedComEntitiy;
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return NO;
        return YES;
    } else if(textField.tag == VISIT_TIME_TABLE_INDEX){//预约时间选择
        
        [self.view endEditing:YES];
        
        //预约时间
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        return NO;
    }else if (textField.tag == VISIT_REMARK_TABLE_INDEX){ //备注
        
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"备注"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"来访",@"拜访"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.visitRemarks = @"来访";
                             }else{
                                 self.visitRemarks = @"拜访";
                             }
                             
                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:VISIT_REMARK_TABLE_INDEX inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationFade];
                             
                         }];
        
        return NO;
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
    switch (textField.tag) {
        case LEADER_TABLE_INDEX:
        {
            self.appointmentLeader = textField.text;
            break;
        }
//        case LEADER_PHONE_TABLE_INDEX:
//        {
//            self.leaderPhone = textField.text;
//            break;
//        }
        case COMPANY_TABLE_INDEX:
        {
            self.company = textField.text;
            break;
        }
        case CLIENT_NAME_TABLE_INDEX:
        {
            self.clientName = textField.text;
            break;
        }
        case JOB_TABLE_INDEX:
        {
            self.job = textField.text;
            break;
        }
        case VISIT_INFO_TABLE_INDEX:
        {
            self.visitDesc = textField.text;
            break;
        }
        default:
            break;
    }
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    self.company_num = entity.num;
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:COMPANY_TABLE_INDEX inSection:0],\
                                         [NSIndexPath indexPathForRow:COMPANY_NUM_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - ContactViewControllerDelegate

- (void)contactViewController:(ContactViewController *)vc didSelectClient:(ContactEntity *)entity
{
    self.clientName = entity.name;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CLIENT_NAME_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-days*24*3600];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.visitTime = dateStr;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:VISIT_TIME_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
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
