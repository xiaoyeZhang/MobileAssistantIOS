//
//  Houston_queryViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Houston_queryViewController.h"
#import "Houston_querySubmitViewController.h"
#import "HoustonDetailViewController.h"

@interface Houston_queryViewController ()

@end

@implementation Houston_queryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进账查询";
    
    self.typeId = @"14";
    [self getBusinessListWithPage:self.currentPage];
    
}
#pragma mark - ButtonMethod

- (void)addBtnClicked:(id)sender
{

    Houston_querySubmitViewController *vc = [[Houston_querySubmitViewController alloc] init];
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
    
    if ([model.type_id isEqualToString:@"22"]) {
        
        if (state == PROCESS_STATE_manager_submit &&
            userType == ROLE_COMMON) { //客户经理已提交 ->财务人员回复
            
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    HoustonDetailViewController *vc = [[HoustonDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
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
