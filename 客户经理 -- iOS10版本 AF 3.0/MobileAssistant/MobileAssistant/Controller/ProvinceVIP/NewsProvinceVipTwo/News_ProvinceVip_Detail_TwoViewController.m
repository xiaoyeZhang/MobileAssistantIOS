//
//  News_ProvinceVip_Detail_TwoViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/2.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "News_ProvinceVip_Detail_TwoViewController.h"
#import "TwoLablesTableViewCell.h"
#import "ThreeLabelsTableViewCell.h"
#import "BusinessProcessModel.h"

@interface News_ProvinceVip_Detail_TwoViewController ()
{
    NSString *op_info;
    TwoLablesTableViewCell *cell1;
}
@end

@implementation News_ProvinceVip_Detail_TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titleName;
    
    self.detailMuArr = [NSMutableArray array];
    self.select_listMuArr = [NSMutableArray array];
    self.processMuArr = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self getBusinessDetailWithGroup:group];
    
    //任务组完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [_tableView reloadData];
        
    });
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)getBusinessDetailWithGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"business_id":self.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"new_business_detail"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [self.detailMuArr removeAllObjects];
            [self.select_listMuArr removeAllObjects];
            [self.processMuArr removeAllObjects];

            self.detailMuArr = entity[@"content"][@"form_info"];
            
            NSArray *arr = [BusinessProcessModel objectArrayWithKeyValuesArray:entity[@"content"][@"process_info"]];
            [self.processMuArr addObjectsFromArray:arr];
            
            op_info = entity[@"content"][@"op_info"];
            
            self.select_listMuArr = entity[@"content"][@"select_list"];
            
        }
        
        
        dispatch_group_leave(group);
        
    } Failed:^(int errorCode, NSString *message) {
        
        dispatch_group_leave(group);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 处理记录";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [tableView numberOfSections]-1) {
        if (indexPath.row == 0) {
            
        }else{
            BusinessProcessModel *model = _processMuArr[indexPath.row-1];
            if ([model.state intValue] != 99 && model.info.length > 0 && ![model.info isEqualToString:@"-1"]) {
                
                iToast *toast = [iToast makeText:model.info];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:3000];
                [toast show:iToastTypeNotice];
            }
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 26;

    }else{
    
        return 44;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_detailMuArr count];
    }else{
        return [_processMuArr count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"ThreeLabelsTableViewCell";

    cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) { //详情
         
        NSDictionary *dict = _detailMuArr[indexPath.row];
        
        cell1.titleLbl.text = [NSString stringWithFormat:@"%@:",dict[@"ch_name"]];
        
        cell1.subTitleLbl.text = dict[@"value"];
    
        return cell1;

    }else{
        
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"状态";
            cell.middleLbl.text = @"受理人";
            cell.rightLbl.text = @"时间";
        }else{
        
            BusinessProcessModel *model = _processMuArr[indexPath.row-1];

            cell.leftLbl.text = model.state_name;
            cell.middleLbl.text = model.user_name;
            cell.rightLbl.text = model.time;
        }
        
        return cell;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
