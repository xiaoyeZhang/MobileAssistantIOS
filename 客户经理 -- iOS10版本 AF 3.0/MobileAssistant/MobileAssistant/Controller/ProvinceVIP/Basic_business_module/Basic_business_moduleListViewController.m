//
//  Basic_business_moduleListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Basic_business_moduleListViewController.h"
#import "Basic_business_moduleSubmitViewController.h"
#import "Basic_business_moduleDetailViewController.h"

@interface Basic_business_moduleListViewController ()

@end

@implementation Basic_business_moduleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基础业务受理";
    
    self.typeId = @"16";
    [self getBusinessListWithPage:self.currentPage];
    
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    Basic_business_moduleSubmitViewController *vc = [[Basic_business_moduleSubmitViewController alloc] init];
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
    
    if ([model.type_id isEqualToString:@"24"]) { //
         if (state == PROCESS_STATE_manager_submit &&
                  userType == ROLE_THREE && [userInfo.user_id isEqualToString:model.next_processor]) { //客户经理已提交 -> 三级经理审核审批
            return YES;
        }else if(state == PROCESS_STATE_three_manager_through &&
                 userType == ROLE_TWO && [userInfo.user_id isEqualToString:model.next_processor]){ //三级经理审核通过 -> 二级经理审核审批
            return YES;
        }else if(state == PROCESS_STATE_two_manager_through &&
                 userType == ROLE_COMMON && [userInfo.user_id isEqualToString:model.next_processor]){ //二级经理审核通过 -> 营销支撑组组长审批
            return YES;
        }else if(state == PROCESS_STATE_GROUP_LEADER_through &&
                 userType == ROLE_COMMON && [userInfo.user_id isEqualToString:model.next_processor]){ //营销支撑组组长审核通过 -> 营销支撑组审批
            return YES;
        }else if(state == PROCESS_STATE_marketing_through &&
                 userType == ROLE_CUSTOMER){ //营销支撑组审核通过 -> 客户经理归档
            return YES;
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
    
    Basic_business_moduleDetailViewController *vc = [[Basic_business_moduleDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
    vc.specialConfigStr = self.specialConfigStr;
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
