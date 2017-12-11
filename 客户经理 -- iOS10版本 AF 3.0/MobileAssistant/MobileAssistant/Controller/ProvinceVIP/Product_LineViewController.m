

//
//  Product_LineViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Product_LineViewController.h"
#import "ProductLineSubmitViewController.h"
#import "ProductLineDetailViewController.h"

@interface Product_LineViewController ()

@end

@implementation Product_LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专线/ims故障处理列表";
    
    self.typeId = @"11";
    [self getBusinessListWithPage:self.currentPage];
}

- (void)addBtnClicked:(id)sender
{
    ProductLineSubmitViewController *vc = [[ProductLineSubmitViewController alloc] init];
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
    
    if ([model.type_id isEqualToString:@"19"]) {
        
        if (state == PROCESS_GRC_THROUGH &&
            userType == ROLE_CUSTOMER) { //客户经理已提交 ->
            
            return YES;
            
        }else if (state == PROCESS_STATE_manager_submit && [self.specialConfig rangeOfString:[NSString stringWithFormat:@"%d",state]].location != NSNotFound){ //三级经理审批通过 -> 二级经理审批
            
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
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@",model.create_time,arr[1]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    ProductLineDetailViewController *vc = [[ProductLineDetailViewController alloc] initWithNibName:@"P_BusinessDetailBaseViewController" bundle:nil];
    vc.bListModel = model;
    vc.model_id = self.typeId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
