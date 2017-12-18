//
//  P_BillListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BillListViewController.h"
#import "P_BillSubmitViewController.h"
#import "P_BillDetailViewController.h"

@interface P_BillListViewController ()

@end

@implementation P_BillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发票列表";
    
    self.typeId = @"8";
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    P_BillSubmitViewController *vc = [[P_BillSubmitViewController alloc] init];
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
    
    
    if ([model.type_id isEqualToString:@"12"]) {
        if (state == PROCESS_STATE_manager_submit &&
            (userType == ROLE_BILL || userType == ROLE_THREE)) { //客户经理已提交 -> 三级进入确认
            
            return YES;
        }else if (state == PROCESS_STATE_three_manager_through &&
                  (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合确认 ->填写回款日期和金额
            
            return YES;
        }
        else if (state == RETURN_THROUGH &&
                  (userType == ROLE_BILL || userType == ROLE_TWO)){ //财务人员审核通过
            
            return YES;
        }
        else if (state == PROCESS_STATE_two_manager_through &&
                  (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合确认 ->填写回款日期和金额
            
            return YES;
        }else if (state == PROCESS_STATE_Invoice &&
                  [userInfo.user_id isEqualToString:model.create_id]){ //综合确认 ->填写回款日期和金额
            
            return YES;
        }else if (state == PROCESS_STATE_send_Invoice &&
                  (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合确认 ->填写回款日期和金额
            
            return YES;
        }
    }else{
        if ([model.type_id isEqualToString:@"13"]) {
            if (state == PROCESS_STATE_manager_submit &&
                userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                return YES;
            }else if (state == PROCESS_STATE_three_manager_through &&
                      [userInfo.user_id isEqualToString:model.next_processor]){ //指定二级经理审批
                
                return YES;
            }else if(state == PROCESS_STATE_two_manager_through &&
                     (userType == ROLE_BILL || userType == ROLE_COMMON)){ //二级经理审批 -> 综合开票
                
                return YES;
            }else if(state == PROCESS_STATE_Invoice &&
                     [userInfo.user_id isEqualToString:model.create_id]){ //综合开票 -> 客户经理送发票
                
                return YES;
                
            }else if (state == PROCESS_STATE_send_Invoice &&
                      (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合开票 ->填写回款日期和金额
                
                return YES;
            }
//            else if (state == PROCESS_STATE_filled_out_confirm &&
//                      (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合开票 ->填写回款日期和金额
//                
//                return YES;
//            }
        }else{
            if (state == PROCESS_STATE_manager_submit &&
                userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
                
                return YES;
            }else if(state == PROCESS_STATE_three_manager_through &&
                     (userType == ROLE_BILL || userType == ROLE_COMMON)){ //三级经理审批 -> 综合开票
                
                return YES;
            }else if(state == PROCESS_STATE_Invoice &&
                     [userInfo.user_id isEqualToString:model.create_id]){ //综合开票 -> 客户经理送发票
                
                return YES;
                
            }else if (state == PROCESS_STATE_send_Invoice &&
                      (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合开票 ->填写回款日期和金额
                
                return YES;
            }
//            else if (state == PROCESS_STATE_filled_out_confirm &&
//                      (userType == ROLE_BILL || userType == ROLE_COMMON)){ //综合开票 ->填写回款日期和金额
//                
//                return YES;
//            }
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
    
    if (arr.count == 3) {
        
        
        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],\
                           [[StringHelper getBusinessStateString:model.state] isEqualToString:@"营销支撑组审核通过"]?@"财务审核通过":[StringHelper getBusinessStateString:model.state]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@  %@",model.create_time,arr[1],arr[2]]];
    
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(19, 84, 142, 1) range:NSMakeRange(model.create_time.length, str.length - model.create_time.length)];
        
        
        cell.textLabel.text = title;
        cell.detailTextLabel.attributedText = str;
    }else if (arr.count == 2){

        NSString *title = [NSString stringWithFormat:@"%@(%@)",arr[0],\
                           [[StringHelper getBusinessStateString:model.state] isEqualToString:@"营销支撑组审核通过"]?@"财务审核通过":[StringHelper getBusinessStateString:model.state]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %@ ",model.create_time,arr[1]]];
        
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
    
    P_BillDetailViewController *vc = [[P_BillDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
