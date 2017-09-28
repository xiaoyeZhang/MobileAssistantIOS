//
//  P_Household_divisionViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_Household_divisionViewController.h"
#import "P_Household_divisionSubmitViewController.h"
#import "P_Household_divisionDetaukViewController.h"

@interface P_Household_divisionViewController ()

@end

@implementation P_Household_divisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分合户";
    
    self.typeId = @"13";
    [self getBusinessListWithPage:self.currentPage];
    
}

- (void)addBtnClicked:(id)sender
{
    P_Household_divisionSubmitViewController *vc = [[P_Household_divisionSubmitViewController alloc] init];
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
    
    if ([model.type_id isEqualToString:@"21"]) {
        
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_THREE) { //客户经理已提交 ->
            
            return YES;
            
        }else if (state == PROCESS_STATE_three_manager_through && userType == ROLE_COMMON){ //三级经理审批通过 -> 营销支撑人员审批
            
            return YES;
        }else if (state == PROCESS_STATE_marketing_through && userType == ROLE_CUSTOMER){ //销支撑人员审批 -> 客户经理处理
            
            return YES;
        }

        
    }else{
        
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
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@       %@",model.create_time,arr[1]]];
        
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(19, 84, 142, 1) range:NSMakeRange(model.create_time.length, str.length - model.create_time.length)];
        
        
        cell.textLabel.text = title;
        cell.detailTextLabel.attributedText = str;
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    P_Household_divisionDetaukViewController *vc = [[P_Household_divisionDetaukViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    
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
