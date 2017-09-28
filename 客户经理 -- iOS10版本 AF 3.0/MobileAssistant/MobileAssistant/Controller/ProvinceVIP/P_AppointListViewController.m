//
//  P_AppointListViewController.m
//  MobileAssistant
//
//  Created by xy on 15/9/30.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_AppointListViewController.h"
#import "MJRefresh.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "BusinessListModel.h"
#import "MJExtension.h"
#import "StringHelper.h"
#import "P_APPointViewController.h"
#import "P_AppointDetailViewController.h"


@interface P_AppointListViewController ()

@end

@implementation P_AppointListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"预约列表";
    
    self.typeId = @"2";
    [self getBusinessListWithPage:self.currentPage];
}

//添加预约拜访
- (void)addBtnClicked:(id)sender
{
    P_APPointViewController *vc = [[P_APPointViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (BOOL)checkIsShowNewTagWithIndex:(int)index
{
    BusinessListModel *model = listMuArr[index];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    int state = [model.state intValue];
    
    if (state == PROCESS_STATE_reject) { //被驳回则提交客户经理显示new tag
        
        if ([userInfo.user_id isEqualToString:model.create_id]) {
            return YES;
        }
    }
    
    
    if (state == PROCESS_STATE_manager_submit&&
        ([userInfo.type_id intValue] == ROLE_VISIT ||[userInfo.type_id intValue] == ROLE_COMMON)){
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
    
    P_AppointDetailViewController *vc = [[P_AppointDetailViewController alloc] init];
    vc.bListModel = model;
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
