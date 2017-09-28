//
//  P_RefundDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_RefundDetailViewController.h"
#import "P_RefundSubmitViewController.h"
#import "ImagesBrowserViewController.h"

@interface P_RefundDetailViewController ()

@end

@implementation P_RefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退款流程";

}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"时       间",          @"detail":@"refund_time",        @"type":@"Label"},
                   @{@"title":@"客户名称",      @"detail":@"customer_name",       @"type":@"Label"},
                   @{@"title":@"金       额",         @"detail":@"refund_amount",       @"type":@"Label"},
                   @{@"title":@"退款原因",      @"detail":@"refund_reason",       @"type":@"Label"},
                   @{@"title":@"附件上传",      @"list":@"picname",               @"type":@"Btn"},
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
        ([userInfo.type_id intValue] == ROLE_THREE|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 三级经理审核
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input",@"placeholder":@"请输入审核意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客响中心已审核
            self.submitState = PROCESS_STATE_three_manager_through;
        }
        
        [self addSubmitBtn];
    }
    
    if (state == PROCESS_STATE_three_manager_through &&
        ([userInfo.type_id intValue] == ROLE_TWO)) {
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input",@"placeholder":@"请输入审核意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客户经理已回访
            self.submitState = PROCESS_STATE_two_manager_through;
        }
        
        [self addSubmitBtn];
    }
    
    if (state == PROCESS_STATE_two_manager_through &&
        ([userInfo.type_id intValue] == ROLE_COMMON)) {
        
        NSArray *array = @[@{@"title":@"审       核",@"type":@"Check"},
                           @{@"title":@"审核意见",@"type":@"Input",@"placeholder":@"请输入审核意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //财务部审核归档
            self.submitState = RETURN_REFUND;
        }
        
        [self addSubmitBtn];
    }
    
    [_tableView reloadData];
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
            
            self.submitState = PROCESS_STATE_two_manager_through;
            
        }else if (state == PROCESS_STATE_two_manager_through &&
                  (type == ROLE_COMMON)){
            
            self.submitState = RETURN_REFUND;
        }
    
    }else{
        self.submitState = PROCESS_STATE_reject;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.submitDesc = textField.text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
    
}

- (void)editBtnClicked:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([self.bListModel.state intValue] == PROCESS_STATE_reject) { //被驳回
        
        if ([userInfo.user_id isEqualToString:self.bListModel.create_id] &&
            [userInfo.type_id intValue] == ROLE_CUSTOMER) { //提交客户经理重新编辑
            
            
            P_RefundSubmitViewController *vc = [[P_RefundSubmitViewController alloc] init];
            vc.detailDict = self.detailDict;
            vc.bListModel = self.bListModel;
            if (self.bListModel.picname.length > 0) {
                NSString *names = [self.bListModel.picname substringFromIndex:1];
                if (names.length > 0) {
                    vc.uploadImagesArr = [names componentsSeparatedByString:@","];
                }
                
            }
            vc.typeNum = @"1";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
