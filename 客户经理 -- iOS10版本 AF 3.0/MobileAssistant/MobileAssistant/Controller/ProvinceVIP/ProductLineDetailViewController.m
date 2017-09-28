//
//  ProductLineDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "ProductLineDetailViewController.h"

@interface ProductLineDetailViewController ()

//解决
@property (copy, nonatomic) NSString *solve;
//满意
@property (copy, nonatomic) NSString *satisfied;
//意见
@property (copy, nonatomic) NSString *opinion;

@end

@implementation ProductLineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专线/ims故障处理详情";
    self.solve = @"是";
    self.satisfied = @"是";
    
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"工单编号",      @"list":@"num",                    @"type":@"Label"},
                   @{@"title":@"客户经理",      @"list":@"user_name",              @"type":@"Label"},
                   @{@"title":@"申请部门",      @"list":@"dep_name",               @"type":@"Label"},
                   @{@"title":@"故障描述",      @"detail":@"fault_description",    @"type":@"Label"},
                   @{@"title":@"集团单位",      @"detail":@"company_name",         @"type":@"Label"},
                   @{@"title":@"集团编号",      @"detail":@"company_num",          @"type":@"Label"},
                   @{@"title":@"地       址",  @"detail":@"company_address",       @"type":@"Label"},
                   @{@"title":@"客户姓名",      @"detail":@"client_name",          @"type":@"Label"},
                   @{@"title":@"客户电话",      @"detail":@"client_tel",          @"type":@"Label"},
                   @{@"title":@"状       态",   @"process":@"state",              @"type":@"Label"},nil];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [self.bListModel.state intValue];
    
    if (state == PROCESS_STATE_manager_submit &&
        ([userInfo.type_id intValue] == ROLE_TWO|[userInfo.type_id intValue] == ROLE_COMMON)) { //客户经理已提交 -> 客响中心审核
        
        NSArray *array = @[@{@"title":@"处理意见",@"type":@"Input",@"placeholder":@"请输入处理意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客响中心已审核
            self.submitState = PROCESS_GRC_THROUGH;
        }
        
        [self addSubmitBtn];
    }
    
    if (state == PROCESS_GRC_THROUGH &&
        ([userInfo.type_id intValue] == ROLE_CUSTOMER)) {
        
        NSArray *array = @[@{@"title":@"是否解决",@"type":@"Check"},
                           @{@"title":@"是否满意",@"type":@"Check"},
                           @{@"title":@"客户意见",@"type":@"Input",@"placeholder":@"请输入客户意见"}];
        
        [detailMuArr addObjectsFromArray:array];
        
        if (!self.submitState) { //客户经理已回访
            self.submitState = RETURN_VISIT;
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
    if (self.submitState == 26) {
        if (self.opinion.length == 0) {
            ALERT_ERR_MSG(@"请填写客户意见");
            isDone = YES;
            return;
        }
    }
    NSString *solve;
    NSString *satisfied;
    
    if ([self.solve isEqualToString:@"是"]) {
        solve = @"已解决";
    }else if([self.solve isEqualToString:@"否"]){
        solve = @"未解决";
    }
    if ([self.satisfied isEqualToString:@"是"]) {
        satisfied = @"满意";
    }else if ([self.satisfied isEqualToString:@"否"]){
        satisfied = @"不满意";
    }
    if (self.submitState == 26) {
        self.submitDesc = [NSString stringWithFormat:@"%@;%@;%@",solve,satisfied,self.opinion];
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
    if (cell.indexPath.row == 10) { 
        if (selectedIndex == 1) {
            self.solve = @"是";
        }else{
            self.solve = @"否";
        }
    }else if (cell.indexPath.row == 11){
        if (selectedIndex == 1) {
            self.satisfied = @"是";
        }else{
            self.satisfied = @"否";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.submitState == 26) {
        if (textField.tag == 12) {
            self.opinion = textField.text;
        }
        
    }
    if (textField.tag == 10) {
        self.submitDesc = textField.text;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
