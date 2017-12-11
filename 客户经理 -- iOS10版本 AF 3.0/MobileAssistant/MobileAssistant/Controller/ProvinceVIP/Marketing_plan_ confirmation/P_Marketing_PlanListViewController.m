//
//  P_Marketing_PlanListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/5.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "P_Marketing_PlanListViewController.h"
#import "P_Marketing_PlanSubmitViewController.h"
#import "P_Marketing_PlanDetailViewController.h"

@interface P_Marketing_PlanListViewController ()

@end

@implementation P_Marketing_PlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营销方案确认";
    
    self.typeId = @"15";
    [self getBusinessListWithPage:self.currentPage];
    
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    P_Marketing_PlanSubmitViewController *vc = [[P_Marketing_PlanSubmitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

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
    
    if ([model.type_id isEqualToString:@"23"]) { //
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_COMMON) {
            return  YES;
        }else if (state == PROCESS_STATE_marketing_through &&
                  userType == ROLE_COMMON) { //营销支撑组审核通过 -> 营销支撑组经理审批
            return YES;
        }else if(state == PROCESS_STATE_marketing_manager_through &&
                 userType == ROLE_THREE){ //营销支撑组经理通过 -> 三级经理审批
            return YES;
        }else if(state == PROCESS_STATE_three_manager_through &&
                 userType == ROLE_COMMON){ //三级经理审核通过 -> 营销支撑组审批
            return YES;
        }else if (userType == ROLE_COMMON){ //通用人员
            
        }
    }else{
        
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
    
    BusinessListModel *model = listMuArr[indexPath.row];
    NSArray *arr = [model.title componentsSeparatedByString:@","];
    
    if (arr.count == 2) {
        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],\
                           [StringHelper getBusinessStateString:model.state]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@",model.create_time,arr[1]]];
        
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(19, 84, 142, 1) range:NSMakeRange(model.create_time.length, str.length - model.create_time.length)];
        
        
        cell.textLabel.text = title;
        cell.detailTextLabel.attributedText = str;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    P_Marketing_PlanDetailViewController *vc = [[P_Marketing_PlanDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
