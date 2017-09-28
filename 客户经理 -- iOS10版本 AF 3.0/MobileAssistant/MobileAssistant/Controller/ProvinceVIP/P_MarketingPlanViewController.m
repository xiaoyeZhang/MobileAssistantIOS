//
//  P_MarketingPlanViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/3.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "P_MarketingPlanViewController.h"
#import "P_MarketingSubmitViewController.h"
#import "P_MarketingDetailViewController.h"

@interface P_MarketingPlanViewController ()

@end

@implementation P_MarketingPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营销方案更改列表";
    self.typeId = @"10";
    
    [self getBusinessListWithPage:self.currentPage];
}

- (void)addBtnClicked:(id)sender{
    
    P_MarketingSubmitViewController *vc = [[P_MarketingSubmitViewController alloc]init];
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
    
    
    if ([model.type_id isEqualToString:@"18"]) {
        
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
            return YES;
        }else if (state == PROCESS_STATE_three_manager_through &&[userInfo.user_id isEqualToString:model.next_processor]){ //三级经理审批通过 -> 二级经理审批
            
            return YES;
        } else if(state == PROCESS_STATE_two_manager_through &&
                  (userType == ROLE_COMMON || userType == ROLE_SPECIAL)){ //二级经理审批通过 -> 支撑人员审批
            
            return YES;
        }
        
        
    }else{
        if (state == PROCESS_STATE_manager_submit &&
            (userType == ROLE_THREE || userType == ROLE_SPECIAL)) { //客户经理已提交 -> 营销活动更改
            return YES;
        } else if(state == PROCESS_STATE_three_manager_through &&
                  [userInfo.user_id isEqualToString:model.create_id]){ //
            
            return YES;
        } else if(state == PROCESS_STATE_two_manager_through &&
                  [userInfo.user_id isEqualToString:model.create_id]){ //
            
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([self checkIsShowNewTagWithIndex:indexPath.row]){
        cell.badgeCenterOffset = CGPointMake(-15, 20);
        [cell showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeNone];
    }else{
        [cell clearBadge];
    }
    
    BusinessListModel *model = listMuArr[indexPath.row];
    NSArray *arr = [model.title componentsSeparatedByString:@","];
    
    if (arr.count == 2) {
        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],\
                           [StringHelper getBusinessStateString:model.state]];
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@",model.create_time,arr[1]];
    }
    
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    P_MarketingDetailViewController *vc = [[P_MarketingDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

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
