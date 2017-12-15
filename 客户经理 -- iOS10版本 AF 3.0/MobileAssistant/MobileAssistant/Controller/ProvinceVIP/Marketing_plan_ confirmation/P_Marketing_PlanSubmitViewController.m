//
//  P_Marketing_PlanSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/5.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "P_Marketing_PlanSubmitViewController.h"
#import "CustomerViewController.h"
#import "TxtFieldTableViewCell.h"
#import "CompEntity.h"
#import "UIActionSheet+Block.h"
#import "UIAlertView+Blocks.h"
#import "XYDatePicker.h"
#import "P_AddPhotoViewController.h"
#import "AFNetworking.h"
#import "P_Marketing_PlanListViewController.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define COMPANY_TABLE_INDEX 2 //集团单位
#define COMPANY_NUM_TABLE_INDEX 3//集团编号
#define ACTIVITY_NAME_INDEX 4 //活动名称
#define LENGTH_ACTIVITY_INDEX 5 //活动时长
#define ACTIVITY_TIME_INDEX 6 //活动生效时间
#define ACTIVITY_TABLE_INDEX 7 // 活动盈利情况
#define MARKET_SCHEME_TYPE_INDEX 8 //营销方案类型
#define LEVEL_ACTIVITY_INDEX 9 //活动档次（话费，终端，其他）每月统付金额  level_of_activity
#define BOTTOM_ACTIVITY_INDEX 10 //活动档次（话费，终端，其他）保底消费  bottom_consumption
#define FEE_ACTIVITY_INDEX 11 //活动档次（话费，终端，其他）获得话费  fee_of_payment
#define MEBER_TYPE_INDEX 12 //集团成员类型   10
#define SUBSIDY_RATE_INDEX 13 //综合补贴率   11
#define VISIT_REMARK_TABLE_INDEX 14 //备注   12
#define ACTIVITY_CHECKPOINT_INDEX 15 //活动检查点   13
#define DURING_SPEECH_INDEX 16 //话费活动期内是否能参加   14
#define TERMINAL_PERIOD_INDEX 17 //终端活动期内是否能参加   15
#define SET_GUARANTEE_INDEX 18 //是否设置保底   16
#define ACTIVITY_ADMISS_TIME_INDEX 19 //活动受理时间   17
#define UPLOAD_TABLE_INDEX 20 //附件上传   18

@interface P_Marketing_PlanSubmitViewController ()<UITextFieldDelegate,CustomerViewControllerDelegate,XYDatePickerDelegate,AddPhotoViewControllerDelegate>{
    
    NSMutableArray *detailMuArr;
    NSMutableDictionary *detailMuDic;
}

///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///活动名称
@property(nonatomic, copy) NSString *activity_name;

///活动时长（月）
@property(nonatomic, copy) NSString *long_time;

///活动生效时间
@property(nonatomic, copy) NSString *activity_time;

///活动盈利情况
@property(nonatomic, copy) NSString *activity_profit;

///营销方案类型
@property(nonatomic, copy) NSString *marketing_scheme_type;

///活动档次（话费，终端，其他） 每月统付金额 level_of_activity
@property(nonatomic, copy) NSString *level_of_activity;

///活动档次（话费，终端，其他） 保底消费 level_of_activity
@property(nonatomic, copy) NSString *bottom_consumption;

///活动档次（话费，终端，其他） 获得话费 level_of_activity
@property(nonatomic, copy) NSString *fee_of_payment;

///集团成员类型
@property(nonatomic, copy) NSString *group_member_type;

///综合补贴率
@property(nonatomic, copy) NSString *comprehensive_subsidy_rate;

///备注
@property(nonatomic, copy) NSString *remarks;

///活动检查点
@property(nonatomic, copy) NSString *activity_checkpoint;

///话费活动期内是否能参加
@property(nonatomic, copy) NSString *during_speech;

///终端活动期内是否能参加
@property(nonatomic, copy) NSString *terminal_period;

///是否设置保底
@property(nonatomic, copy) NSString *set_guarantee;

///活动受理时间
@property(nonatomic, copy) NSString *activity_admiss_time;

///自选营销方案类型
@property(nonatomic, copy) NSString *marketing_scheme_type_fill;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@property(nonatomic, assign) NSInteger timeType;

@property (copy, nonatomic) NSString *business_id;

@end

@implementation P_Marketing_PlanSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营销方案确认";
    
    self.marketing_scheme_type = @"";
    
    detailMuDic = [NSMutableDictionary dictionary];
        //    CompanyCheck :选择集团 Text：填写 Label: 只读 Time: 选择时间  imageCheck：上传图片
    //    messageCheck :下拉框
    UserEntity *userInfo = [UserEntity sharedInstance];
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"客户经理",@"detail":@"username",@"type":@"Label",@"placeholder":@"",@"message":@""},
                   @{@"title":@"申请部门",@"detail":@"userdep_name",@"type":@"Label",@"placeholder":@"",@"message":@""},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"CompanyCheck",@"placeholder":@"请选择集团单位名称",@"message":@""},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label",@"placeholder":@"选择集团单位后自动生成",@"message":@""},
                   @{@"title":@"活动名称",@"detail":@"activity_name",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"活动时长(月)",@"detail":@"long_time",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"活动生效时间",@"detail":@"activity_time",@"type":@"Time",@"placeholder":@"请选择活动生效时间",@"message":@""},
                   @{@"title":@"活动盈利情况",@"detail":@"activity_profit",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"营销方案类型",@"detail":@"marketing_scheme_type",@"type":@"messageCheck",@"placeholder":@"请选择营销方案类型",@"message":@[@"话费",@"终端",@"其他"]},
                   @{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"集团成员类型",@"detail":@"group_member_type",@"type":@"messageCheck",@"placeholder":@"请选择集团成员类型",@"message":@[@"普通集团成员",@"集团重要领导及关键联系人"]},
                   @{@"title":@"综合补贴率",@"detail":@"comprehensive_subsidy_rate",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"备注",@"detail":@"remarks",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"活动检查点",@"detail":@"activity_checkpoint",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"话费活动期内是否能参加",@"detail":@"during_the_period_of_the_speech",@"type":@"messageCheck",@"placeholder":@"请选择",@"message":@[@"是",@"否"]},
                   @{@"title":@"终端活动期内是否能参加",@"detail":@"terminal_activity_period",@"type":@"messageCheck",@"placeholder":@"请选择",@"message":@[@"是",@"否"]},
                   @{@"title":@"是否设置保底",@"detail":@"whether_to_set_a_guarantee",@"type":@"messageCheck",@"placeholder":@"请选择",@"message":@[@"是",@"否"]},
                   @{@"title":@"活动受理时间",@"detail":@"activity_admissibility_time",@"type":@"Time",@"placeholder":@"请选择受理时间",@"message":@""},
                   @{@"title":@"上传资料",@"detail":@"image",@"type":@"imageCheck",@"placeholder":@"请上传合同相关资料",@"message":@""},nil];
    
    
    for (NSDictionary *dic in detailMuArr) {
        
        [detailMuDic setObject:@"" forKey:dic[@"detail"]];
        [detailMuDic setObject:@" " forKey:@"image"];
        
        if (self.detailDict) {
            
            self.business_id = self.bListModel.business_id;
            
            if ([dic[@"detail"] isEqualToString:@"username"] || [dic[@"detail"] isEqualToString:@"userdep_name"] || [dic[@"detail"] isEqualToString:@"image"]) {
                
            }else{
                
                [detailMuDic setObject:self.detailDict[dic[@"detail"]] forKey:dic[@"detail"]];

            }
            
        }
        
        [detailMuDic setObject:userInfo.name forKey:@"username"];
        [detailMuDic setObject:userInfo.dep_name forKey:@"userdep_name"];
        
    }
    
    if (self.detailDict) {
        if ([self.detailDict[@"marketing_scheme_type"] isEqualToString:@"其他"]) {

            [detailMuArr removeObject:@{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Text",@"placeholder":@"",@"message":@""}];
            [detailMuArr removeObject:@{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Text",@"placeholder":@"",@"message":@""}];
            [detailMuArr removeObject:@{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Text",@"placeholder":@"",@"message":@""}];
            
            [detailMuArr insertObject:@{@"title":@"自选营销方案类型",@"detail":@"marketing_scheme_type_fill",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:9];
            
            [detailMuDic setObject:self.detailDict[@"marketing_scheme_type_fill"] forKey:@"marketing_scheme_type_fill"];
        }
    }
}

//提交
- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    
    if ([detailMuDic[@"marketing_scheme_type"] isEqualToString:@"其他"]) {
        
        [detailMuDic setObject:@" " forKey:@"level_of_activity"];
        [detailMuDic setObject:@" " forKey:@"bottom_consumption"];
        [detailMuDic setObject:@" " forKey:@"fee_of_payment"];
        
    }else{
        
        [detailMuDic setObject:@" " forKey:@"marketing_scheme_type_fill"];
    }
    
    for (NSString *key in detailMuDic) {

        NSString *str = [detailMuDic objectForKey:key];

        for (NSDictionary *dic in detailMuArr) {

            if ([dic[@"detail"] isEqualToString:key]) {
                if (str.length == 0) {

                    msg = [NSString stringWithFormat:@"%@不能为空",dic[@"title"]];
                    ALERT_ERR_MSG(msg);
                    isDone = YES;
                    return;

                }
            }
        }

    }
    
    if ([detailMuDic[@"group_member_type"] isEqualToString:@"普通集团成员"]) {

        if ([detailMuDic[@"comprehensive_subsidy_rate"] doubleValue] > 50) {
            msg = @"综合补贴率不能超过50%";
        }

    }else if ([detailMuDic[@"group_member_type"] isEqualToString:@"集团重要领导及关键联系人"]){
        if ([detailMuDic[@"comprehensive_subsidy_rate"] doubleValue] > 60) {
            msg = @"综合补贴率不能超过60%";
        }
    }

    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }

    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    
    [detailMuDic setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    [detailMuDic setObject:userInfo.user_id forKey:@"create_id"];
    [detailMuDic setObject:@"23" forKey:@"type_id"];
    [detailMuDic setObject:detailMuDic[@"company_name"] forKey:@"title"];
    [detailMuDic setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];

//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

//    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];

//    [dict setObject:userInfo.user_id forKey:@"create_id"];
    
//    [dict setObject:@"23" forKey:@"type_id"];
    
//    [dict setObject:self.company forKey:@"company_name"];
//
//    [dict setObject:self.company_num forKey:@"company_num"];
//
//    [dict setObject:self.activity_name forKey:@"activity_name"];
//
//    [dict setObject:self.long_time forKey:@"long_time"];
//
//    [dict setObject:self.activity_time forKey:@"activity_time"];
//
//    [dict setObject:self.activity_profit forKey:@"activity_profit"];
//
//    [dict setObject:self.marketing_scheme_type forKey:@"marketing_scheme_type"];
//
//    [dict setObject:self.level_of_activity forKey:@"level_of_activity"];
    
//    [dict setObject:self.company forKey:@"title"];
    
//    [dict setObject:self.group_member_type forKey:@"group_member_type"];
//
//    [dict setObject:self.comprehensive_subsidy_rate forKey:@"comprehensive_subsidy_rate"];
//
//    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    [dict setObject:self.remarks forKey:@"remarks"];
//
//    [dict setObject:self.activity_checkpoint forKey:@"activity_checkpoint"];
//
//    [dict setObject:self.during_speech forKey:@"during_the_period_of_the_speech"];
//
//    [dict setObject:self.terminal_period forKey:@"terminal_activity_period"];
//
//    [dict setObject:self.set_guarantee forKey:@"whether_to_set_a_guarantee"];
//
//    [dict setObject:self.activity_admiss_time forKey:@"activity_admissibility_time"];
//
    [self get_three_list:[detailMuDic objectForKey:@"type_id"] Successed:^(id entity) {

        int state = [entity[@"state"] intValue];

        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:detailMuDic];
        }else{

            [self goSumbitData:detailMuDic];
        }
        isDone = YES;
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return detailMuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
    
    
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    cell.titleLbl.text = dict[@"title"];
    cell.txtField.placeholder = dict[@"placeholder"];
    
    if ([dict[@"detail"] isEqualToString:@"comprehensive_subsidy_rate"]) {
    
        cell.txtField.keyboardType = UIKeyboardTypeDecimalPad;
    
    }else{
        
        cell.txtField.keyboardType = UIKeyboardTypeDefault;

    }
    
    if ([dict[@"type"] isEqualToString:@"imageCheck"]) {
        
        cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
   
    }else{
        
        cell.txtField.text = detailMuDic[dict[@"detail"]];

    }
    return cell;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    //    CompanyCheck :选择集团    Text：填写    Label: 只读   Time: 选择时间    imageCheck：上传图片
    //    messageCheck :下拉框
    if (textField.tag == USER_NAME_TABLE_INDEX |
        textField.tag == USER_DEP_TABLE_INDEX |
        textField.tag == COMPANY_NUM_TABLE_INDEX){
        return NO;
    }
    NSString *type = detailMuArr[textField.tag][@"type"];
    NSString *title = detailMuArr[textField.tag][@"title"];
    NSString *detail = detailMuArr[textField.tag][@"detail"];
    
    if ([type isEqualToString:@"Label"]) {
        return NO;
    }else if ([type isEqualToString:@"Time"]){
        [self.view endEditing:YES];
        //预约时间
         self.timeType = textField.tag;
         XYDatePicker *datePicker = [XYDatePicker datePicker];
         datePicker.delegate = self;
         datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
         [datePicker show];
         return NO;
    }else if ([type isEqualToString:@"CompanyCheck"]){
        [self.view endEditing:YES];
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];

        return NO;
        
    }else if ([type isEqualToString:@"messageCheck"]){
        [self.view endEditing:YES];
        
        NSArray *data_arr = detailMuArr[textField.tag][@"message"];
        
        [UIActionSheet showInView:self.view
                             withTitle:title
                     cancelButtonTitle:@"取消"
                destructiveButtonTitle:nil
                     otherButtonTitles:data_arr
                              tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                  for (int i = 0; i < data_arr.count; i ++ ) {
                                      if (buttonIndex == i) {
                                          [detailMuDic setObject:data_arr[i] forKey:detail];
                                      }
                                  }
                                  
                                  if ([detailMuDic[@"marketing_scheme_type"] isEqualToString:@"其他"]) {
                                      
                                      NSInteger index= [detailMuArr indexOfObject:@{@"title":@"自选营销方案类型",@"detail":@"marketing_scheme_type_fill",@"type":@"Text",@"placeholder":@"",@"message":@""} inRange:NSMakeRange(0, [detailMuArr count] - 1)];
                                      
                                      if(index == NSNotFound)
                                      {
                                          [detailMuArr insertObject:@{@"title":@"自选营销方案类型",@"detail":@"marketing_scheme_type_fill",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:9];

                                      }else{

                                          
                                      }
                                      
                                      [detailMuArr removeObject:@{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                      [detailMuArr removeObject:@{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                      [detailMuArr removeObject:@{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                      
                                      [_tableView reloadData];
                                  
                                  }else if ([detailMuDic[@"marketing_scheme_type"] isEqualToString:@"话费"] || [detailMuDic[@"marketing_scheme_type"] isEqualToString:@"终端"]){
                                      
                                       [detailMuArr removeObject:@{@"title":@"自选营销方案类型",@"detail":@"marketing_scheme_type_fill",@"type":@"Text",@"placeholder":@"",@"message":@""}];
    
                                      NSInteger index= [detailMuArr indexOfObject:@{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Text",@"placeholder":@"",@"message":@""} inRange:NSMakeRange(0, [detailMuArr count] - 1)];
                                      
                                      if(index == NSNotFound)
                                      {
                                          [detailMuArr insertObject:@{@"title":@"每月统付金额",@"detail":@"level_of_activity",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:9];
                                          [detailMuArr insertObject:@{@"title":@"保底消费",@"detail":@"bottom_consumption",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:10];
                                          [detailMuArr insertObject:@{@"title":@"获得话费",@"detail":@"fee_of_payment",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:11];
                                      }
                                      
                                      [_tableView reloadData];

                                  }else{
                                      
                                      [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag inSection:0]]
                                                        withRowAnimation:UITableViewRowAnimationFade];
                                  }

                              }];
     
             return NO;
        
    }else if ([type isEqualToString:@"imageCheck"]){
        [self.view endEditing:YES];
        
        P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
        vc.imagesArr = self.uploadImagesArr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
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
    NSString *type = detailMuArr[textField.tag][@"type"];
    NSString *detail = detailMuArr[textField.tag][@"detail"];
    
    if ([type isEqualToString:@"Text"]) {
        
        [detailMuDic setObject:textField.text forKey:detail];

    }
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    self.company_num = entity.num;
    
    [detailMuDic setObject:entity.name forKey:@"company_name"];
    [detailMuDic setObject:entity.num forKey:@"company_num"];
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:COMPANY_TABLE_INDEX inSection:0],\
                                         [NSIndexPath indexPathForRow:COMPANY_NUM_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    NSString *detail = detailMuArr[_timeType][@"detail"];
    
    [detailMuDic setObject:dateStr forKey:detail];
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_timeType inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
    
//    if (_timeType == ACTIVITY_TIME_INDEX) {
//        self.activity_time = dateStr;
//
//        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ACTIVITY_TIME_INDEX inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    }else if (_timeType == ACTIVITY_ADMISS_TIME_INDEX || _timeType == TERMINAL_PERIOD_INDEX){
//        self.activity_admiss_time = dateStr;
//
//        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_timeType inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    }
    
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    self.uploadImagesArr = imagesArr;
    //    [_tableView reloadData];
//    if ([self.marketing_scheme_type isEqualToString:@"终端"] || [self.marketing_scheme_type isEqualToString:@"话费"] || [self.marketing_scheme_type isEqualToString:@""]) {
//        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:UPLOAD_TABLE_INDEX inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    }else{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:detailMuArr.count-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
//    }

}

- (void)showSIAlertView:(NSArray *)arr andWithDict:(NSMutableDictionary *)dic{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"下级执行人" andMessage:@""];
    
    for (int i = 0; i < arr.count; i++) {
        
        [alertView addButtonWithTitle:[arr[i] objectForKey:@"name"]
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  NSLog(@"Button1 Clicked:%@",[arr[i] objectForKey:@"name"]);
                                  
                                  [dic setObject:[arr[i] objectForKey:@"user_id"] forKey:@"next_processor"];
                                  
                                  [self goSumbitData:dic];
                              }];
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler", alertView);
        };
        
    }
    
    [alertView addButtonWithTitle:@"取   消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    
    [alertView show];
    
}

- (void)goSumbitData:(NSMutableDictionary *)dict{
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            if (self.uploadImagesArr.count != 0) {
                
                for (int i = 0; i < [self.uploadImagesArr count]; i++) {
                    
                    if ([self.typeNum isEqualToString:@"1"]) {
                        if ([self.uploadImagesArr[i] isKindOfClass:[UIImage class]]) {
                            //取出重新上传的图片
                            [self uploadImagesWithIndex:i withBusinessId:self.business_id];
                            
                            break;
                        }
                        //没有提交的图片 则显示提交成功
                        if (i == self.uploadImagesArr.count - 1) {
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]init];
                                for (UIViewController *temp in self.navigationController.viewControllers) {
                                    if ([temp isKindOfClass:[vc class]]) {
                                        [self.navigationController popToViewController:temp animated:YES];
                                    }
                                    
                                }
                                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                            }];
                        }
                        
                    }else{
                        [self uploadImagesWithIndex:0 withBusinessId:entity[@"content"]];
                    }
                    
                }
                
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if ([self.typeNum isEqualToString:@"1"]) {
                        P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
                
            }
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        
        
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
    }];
    
}

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)businessId
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%d",businessId,index];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);
    
    NSDictionary *dict = @{@"method":@"terminal_upload",
                           @"business_id":businessId,
                           @"picname":imageName,
                           @"file":imageData
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    
    [manager POST:BASEURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(self.uploadImagesArr[index],0.5);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",imageName] mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[obj objectForKey:@"state"] intValue]== 1) {
            if (index < self.uploadImagesArr.count-1) {
                
                [self uploadImagesWithIndex:index+1 withBusinessId:businessId];
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if ([self.typeNum isEqualToString:@"1"]) {
                        P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if ([self.typeNum isEqualToString:@"1"]) {
                    P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]init];
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[vc class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                        
                    }
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
