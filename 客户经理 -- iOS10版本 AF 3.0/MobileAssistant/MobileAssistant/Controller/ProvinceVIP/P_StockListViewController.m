//
//  P_StockListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_StockListViewController.h"
#import "P_StockSubmitViewController.h"
#import "P_StockDetailViewController.h"

@interface P_StockListViewController ()

@end

@implementation P_StockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退库列表";
    
    self.typeId = @"4";
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{
    P_StockSubmitViewController *vc = [[P_StockSubmitViewController alloc] init];
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
        userType == ROLE_THREE) { //客户经理已提交 -> 三级经理审批
        
        return YES;
    }else if (state == PROCESS_STATE_three_manager_through &&
              [userInfo.user_id isEqualToString:model.next_processor]){ //指定二级经理审批
        return YES;
    } else if(state == PROCESS_STATE_two_manager_through &&
              (userType == ROLE_RETREAT || userType == ROLE_COMMON)){ //二级经理审批 -> 营销接收
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
    
    P_StockDetailViewController *vc = [[P_StockDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
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
