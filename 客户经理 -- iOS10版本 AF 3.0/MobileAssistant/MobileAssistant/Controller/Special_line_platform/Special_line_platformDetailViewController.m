//
//  Special_line_platformDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/7.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Special_line_platformDetailViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "ThreeLabelsTableViewCell.h"
#import "BtnTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "M_Order_Demand_DetailEntity.h"
#import "ImagesBrowserViewController.h"
#import "M_process_infoEntity.h"
#import "MBProgressHUD.h"

@interface Special_line_platformDetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    LineTwoLabelTableViewCell *cell;
    UserEntity *userEntity;
    NSMutableArray *process_infoArr;
    NSMutableArray *form_infoArr;
    NSMutableArray *All_form_infoArr;
    NSDictionary *contentDic;
    UIButton *submitBtn;
    NSArray *imagesNameArr;

}
@end

@implementation Special_line_platformDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"专线平台工单详情";
    process_infoArr = [NSMutableArray array];
    form_infoArr = [NSMutableArray array];
    All_form_infoArr = [NSMutableArray array];
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDate];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDate{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{
                          @"method":@"m_order_detail",
                          @"user_id":userEntity.user_id,
                          @"order_id":self.order_id,
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            contentDic = [entity objectForKey:@"content"];
            
            NSMutableArray *form_infoARR = [contentDic objectForKey:@"form_info"];
            
            NSMutableArray *process_infoARR = [contentDic objectForKey:@"process_info"];
            
            NSMutableArray *select_user_list = [contentDic objectForKey:@"select_user_list"];
            
            for (NSDictionary *attributes in form_infoARR) {
                
                M_Order_Demand_DetailEntity *entity = [[M_Order_Demand_DetailEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                
                if ([entity.cur_data_state intValue] == 0) {
                    
                    [form_infoArr addObject:entity];
                    
                }
//                if ([entity.name isEqualToString:@"company_num"]) {
//
//                    groupId = entity.cur_data_info;
//                }
                
                [All_form_infoArr addObject:entity];
            }
            
            for (NSDictionary *attributes in process_infoARR) {
                
                M_process_infoEntity *entity = [[M_process_infoEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                
                [process_infoArr addObject:entity];
            }
            
            if ([[contentDic objectForKey:@"opreator"] count] > 0) {
                
                
                if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-4"]) {
                    
                    //接收
                    
                    submitBtn = [self setNaviRightBtnWithTitle:[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_name"]];
                    
                }
                
                [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self.tableView reloadData];
            
        }else{
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
    }];
    
}

- (void)submitBtnClicked:(UIButton *)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"m_order_accept",@"method",
                                self.order_id,@"order_id",
                                userEntity.user_id,@"user_id",
                                @"-1",@"next_processor_id",
                                @"自动分配",@"next_processor_name",
                                nil];
    
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"接受成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
            }];
            
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"接受失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
            }];
            
        }
        
        isDone = YES;
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        isDone = YES;
        
        [HUD hide:YES];
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (form_infoArr.count > 0) {

            if ([contentDic objectForKey:@"opreator"] > 0) {

                return form_infoArr.count + 1;

            }else{

                return form_infoArr.count + 1;

            }
        }else{

            return form_infoArr.count;

        }

        
    }else{
        return [process_infoArr count] + 1;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                                .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 26;
        
    }else{
        
        return 44;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
    static NSString *identifier2 = @"BtnTableViewCell";
    static NSString *identifier3 = @"ThreeLabelsTableViewCell";

    if (indexPath.section == 0) { //详情
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row < form_infoArr.count) {
            
            M_Order_Demand_DetailEntity *entity = [form_infoArr objectAtIndex:indexPath.row];
            if ([entity.type_id isEqualToString:@"3"]) {
                
                BtnTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if (!cell1) {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
                    
                    [cell1.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                cell1.btn.tag = indexPath.row;
                
                cell1.titleLbl.text = entity.title;
                
                if ([entity.cur_data_state intValue] == 0) {
                    
                    NSString *names = entity.cur_data_info;
                    
                    if (names.length > 0) {
                        imagesNameArr = [names componentsSeparatedByString:@";"];
                        if (imagesNameArr.count > 0) {
                            [cell1.btn setTitle:@"查看" forState:UIControlStateNormal];
                        }else{
                            [cell1.btn setTitle:@"暂无" forState:UIControlStateNormal];
                        }
                    }else{
                        [cell1.btn setTitle:@"暂无" forState:UIControlStateNormal];
                    }
                    
                    
                }else{
                    [cell1.btn setTitle:@"暂无" forState:UIControlStateNormal];
                }
                
                
                return cell1;
            }else{
                
                cell.titLabel.text = entity.title;
                
                if ([entity.cur_data_state intValue] == 0) {
                    cell.subTitleLbl.text = entity.cur_data_info;
                }else{
                    
                }
                
                return cell;
                
            }
            
        }else if (indexPath.row == form_infoArr.count) {
            
            cell.titLabel.text = @"状态";
            
            M_process_infoEntity *entity = process_infoArr[0];
            
            cell.subTitleLbl.text = entity.cur_state_name;
            
            return cell;
            
        }else{

            return nil;

        }
        
    }else{
        ThreeLabelsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell1) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell1.leftLbl.text = @"状态";
            cell1.middleLbl.text = @"受理人";
            cell1.rightLbl.text = @"时间";
        }else{
            
            M_process_infoEntity *entity = process_infoArr[indexPath.row - 1];
            
            cell1.leftLbl.text = entity.state_name;
            cell1.middleLbl.text = entity.user_name;
            cell1.rightLbl.text = entity.time;
        }
        
        return cell1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 处理记录";
    }
    
    return title;
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    if (imagesNameArr.count > 0) {
        
        ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
        vc.imagesNameArray = imagesNameArr;
        vc.type = @"1";//新订单需求
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
