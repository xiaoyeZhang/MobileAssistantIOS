//
//  P_TerminalListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalListViewController.h"
#import "P_TerminalSubmitViewController.h"
#import "P_TerminalDetailViewController.h"

@interface P_TerminalListViewController ()

@end

@implementation P_TerminalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"终端列表";
    
    self.typeId = @"3";
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    P_TerminalSubmitViewController *vc = [[P_TerminalSubmitViewController alloc] init];
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
    
    
    if (state == PROCESS_STATE_manager_submit &&
        userType == ROLE_THREE) { //客户经理已提交 -> 行业总监审批
        
        return YES;
    }else if (state == PROCESS_STATE_Industry_director &&
              userType == ROLE_THREE) { //行业总监通过 -> 三级经理审批
        return YES;
    }else if (state == PROCESS_STATE_three_manager_through &&
              userType == ROLE_TERMINAL) { //三级经理通过 -> 综合填写到货情况
        return YES;
    }else if(state == PROCESS_STATE_actual_arrival &&
             [userInfo.user_id isEqualToString:model.create_id]){ //综合填写到货情况 -> 客户经理确认
        return YES;
    }else if(state == PROCESS_STATE_manager_confirm &&
             userType == ROLE_TERMINAL){ //客户经理确认 -> 综合部发货
        
        return YES;
    }/*else if(state == PROCESS_STATE_delivery &&
             [userInfo.user_id isEqualToString:model.create_id]){ //综合部发货 -> 客户经理收货
        return YES;
    }*/
    else if (userType == ROLE_COMMON){
        NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
        if (arr.count>3) {
            NSString *config = arr[3];
            NSRange range = [config rangeOfString:model.state];
            if (range.length > 0) { //当通用人员可执行状态包含当前状态
                if (state == PROCESS_STATE_three_manager_through) { 
                    return YES;
                }else if (state == PROCESS_STATE_manager_confirm){
                    return YES;
                }
            }
        }
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
    
    P_TerminalDetailViewController *vc = [[P_TerminalDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
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
