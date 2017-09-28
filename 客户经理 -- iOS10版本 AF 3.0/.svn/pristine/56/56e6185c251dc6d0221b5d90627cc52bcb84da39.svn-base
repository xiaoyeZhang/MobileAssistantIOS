//
//  P_SpecialListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_SpecialListViewController.h"
#import "P_SpecialSubmitViewController.h"
#import "P_SpecialDetailViewController.h"

@interface P_SpecialListViewController ()

@end

@implementation P_SpecialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    super.model = NSStringFromClass([self class]);
    
    self.title = @"特号列表";
    
    self.typeId = @"1";
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    P_SpecialSubmitViewController *vc = [[P_SpecialSubmitViewController alloc] init];
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
    
    
//    if ([model.type_id isEqualToString:@"1"]) { //2、3级特号
//        if (state == PROCESS_STATE_manager_submit &&
//            userType == ROLE_THREE) {
//            return  YES;
//        }else if (state == PROCESS_STATE_three_manager_through &&
//                  [userInfo.user_id isEqualToString:model.next_processor]) { //三级经理通过 -> 二级经理审批
//            return YES;
//        }else if(state == PROCESS_STATE_two_manager_through &&
//                 userType == ROLE_SPECIAL){ //二级经理通过 -> 营销特号人员
//            return YES;
//        }else if(state == PROCESS_STATE_marketing_through &&
//                 userType == ROLE_CARD_1){ //特号人员确认 -> 办卡人员
//            return YES;
//        }
//    }else{
//        if (state == PROCESS_STATE_manager_submit &&
//            userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
//            
//            return YES;
//        }else if (state == PROCESS_STATE_three_manager_through &&
//                  userType == ROLE_SPECIAL) { //三级经理通过 -> 营销特号人员
//            return YES;
//        }else if(state == PROCESS_STATE_marketing_through &&
//                 userType == ROLE_CARD_1){ //营销特号 -> 营销办卡
//            
//            return YES;
//        }
//    }
    
    if ([model.type_id isEqualToString:@"1"]) { //2、3级特号
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_THREE) {
            return  YES;
        }else if (state == PROCESS_STATE_three_manager_through &&
                  [userInfo.user_id isEqualToString:model.next_processor]) { //三级经理通过 -> 二级经理审批
            return YES;
        }else if(state == PROCESS_STATE_two_manager_through &&
                 userType == ROLE_SPECIAL){ //二级经理通过 -> 营销特号人员
            return YES;
        }else if(state == PROCESS_STATE_marketing_through &&
                 userType == ROLE_CARD_1){ //特号人员确认 -> 办卡人员
            return YES;
        }else if (userType == ROLE_COMMON){ //通用人员
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>0) {
                NSString *config = arr[0];
                NSRange range = [config rangeOfString:model.state];
                if (range.length > 0) { //当通用人员可执行状态包含当前状态
                    return YES;
                }else if (state == PROCESS_STATE_Have_Guadan){
                    return YES;
                }else{
                    
                }
            }
        }
    }else{
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
            
            return YES;
        }else if (state == PROCESS_STATE_three_manager_through &&
                  userType == ROLE_SPECIAL) { //三级经理通过 -> 营销特号人员
            return YES;
        }else if(state == PROCESS_STATE_marketing_through &&
                 userType == ROLE_CARD_1){ //营销特号 -> 营销办卡
            
            return YES;
        }else if (userType == ROLE_COMMON){ //通用人员
            NSArray *arr = [self.specialConfigStr componentsSeparatedByString:@";"];
            if (arr.count>1) {
                NSString *config = arr[1];
                NSRange range = [config rangeOfString:model.state];
                if (range.length > 0) { //当通用人员可执行状态包含当前状态
                    return YES;
                }else if (state == PROCESS_STATE_Have_Guadan){
                    return YES;
                }else{
                    
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
    
    P_SpecialDetailViewController *vc = [[P_SpecialDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
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
