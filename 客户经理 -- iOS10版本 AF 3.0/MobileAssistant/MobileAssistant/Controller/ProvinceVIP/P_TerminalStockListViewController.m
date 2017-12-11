//
//  P_TerminalStockListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalStockListViewController.h"
#import "P_TerminalStockSubmitViewController.h"
#import "P_TerminalStockDetailViewController.h"
#import "P_TerminalStockLViewController.h"

@interface P_TerminalStockListViewController ()

@end

@implementation P_TerminalStockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"终端出库列表";
    
    self.typeId = @"9";
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
//    P_TerminalStockSubmitViewController *vc = [[P_TerminalStockSubmitViewController alloc] initWithNibName:@"P_TerminalSubmitViewController" bundle:nil];
////    vc.isShowSelectStock = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    P_TerminalStockLViewController *vc = [[P_TerminalStockLViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (BOOL)checkIsShowNewTagWithIndex:(int)index
{
    BusinessListModel *model = listMuArr[index];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int userType = [userInfo.type_id intValue];
    int state = [model.state intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回则提交客户经理显示new tag
        
        if ([userInfo.user_id isEqualToString:model.create_id]) {
            return YES;
        }
    }
    
//    if (state == PROCESS_STATE_manager_submit &&
//        userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
//        
//        return YES;
//    }else if (state == PROCESS_STATE_three_manager_through &&
//              [model.next_processor isEqualToString:userInfo.user_id]){
//        return YES;
//    }else if (state == PROCESS_STATE_two_manager_through &&
//              (userType == ROLE_LIBRARY_1 || userType == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
//        
//        return YES;
//    }else if(state == PROCESS_STATE_library_number &&
//             [model.create_id isEqualToString:userInfo.user_id]){ //串号已发送至客户经理->已提交客户信息至受理人员（客户经理）
//        return YES;
//    }else if(state == PROCESS_STATE_library_acceptanceing &&
//             (userType == ROLE_LIBRARY_2 || userType == ROLE_COMMON)){ //营销活动已受理->默认营销活动已受理
//        
//        return YES;
//    }else if(state == PROCESS_STATE_library_acceptanceed &&
//             (userType == ROLE_LIBRARY_3 || userType == ROLE_COMMON)){//默认营销活动已受理->已出库
//        
//        return YES;
//    }else if (state == PROCESS_STATE_library_end &&
//              [model.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
//        
//        return YES;
//    }
    
    //订货类型为“赠送礼品”时，二级经理审核通过后，直接到出库节点
    if ([model.type_id isEqualToString:@"17"]) {
        if (state == PROCESS_STATE_two_manager_through &&
            userType == ROLE_LIBRARY_3){
            return YES;
        }else if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>16) {
                NSString *config = arr[16];
                NSRange range = [config rangeOfString:model.state];
                if (range.length > 0) {
                    if (state == PROCESS_STATE_two_manager_through) {
                        return YES;
                    }
                }
            }
            
            return NO;
        }
    }
    
    if (state == PROCESS_STATE_manager_submit &&
        userType == ROLE_THREE) { //客户经理已提交 -> 行业总监审批
        
        return YES;
    }else if (state == PROCESS_STATE_Industry_director &&
              [model.next_processor isEqualToString:userInfo.user_id]){
        return YES;
    }else if (state == PROCESS_STATE_three_manager_through &&
              [model.next_processor isEqualToString:userInfo.user_id]){
        return YES;
    }else if (state == PROCESS_STATE_two_manager_through &&
              (userType == ROLE_LIBRARY_1 || userType == ROLE_COMMON)){ //二级经理通过->串号已发送至客户经理
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:model.state];
                if (range.length == 0) { //没有执行权限则提示
                    return NO;
                }
            }
        }
        
        return YES;
    }else if(state == PROCESS_STATE_library_number &&
             [model.create_id isEqualToString:userInfo.user_id]){ //串号已发送至客户经理->已提交客户信息至受理人员（客户经理）
        return YES;
    }else if(state == PROCESS_STATE_library_acceptanceing &&
             ((userType == ROLE_LIBRARY_2 || userType == ROLE_COMMON) )){ //营销活动已受理->默认营销活动已受理
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:model.state];
                if (range.length == 0) { //没有执行权限则提示
                    return NO;
                }
            }
        }
        
        return YES;
    }else if(state == PROCESS_STATE_library_acceptanceed &&
             (userType == ROLE_LIBRARY_3 || userType == ROLE_COMMON)){//默认营销活动已受理->已出库
        
        if (userType == ROLE_COMMON){
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>14) {
                NSString *config = arr[14];
                NSRange range = [config rangeOfString:model.state];
                if (range.length == 0) { //没有执行权限则提示
                    return NO;
                }
            }
        }
        
        return YES;
    }else if (state == PROCESS_STATE_library_end &&
              [model.create_id isEqualToString:userInfo.user_id]){ //已出库->已领货
        
        return YES;
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([self checkIsShowNewTagWithIndex:indexPath.row]) {
        cell.badgeCenterOffset = CGPointMake(-15,20);
        [cell showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeNone];
    }else{
        [cell clearBadge];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    P_TerminalStockDetailViewController *vc = [[P_TerminalStockDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
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
