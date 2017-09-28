//
//  SA_Special_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/8/7.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "SA_Special_DetailViewController.h"
#import "MBProgressHUD.h"
#import "UIActionSheet+Block.h"
#import "M_Order_Demand_DetailEntity.h"
#import "M_process_infoEntity.h"
#import "TwoLablesTableViewCell.h"
#import "LineTwoLabelTableViewCell.h"
#import "BtnTableViewCell.h"
#import "ImagesBrowserViewController.h"
#import "ThreeLabelsTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "M_OrderUserViewController.h"
#import "M_Order_Demand_SumiltViewController.h"
#import "Business_BillListViewController.h"
#import "CustomerViewController.h"

@interface SA_Special_DetailViewController ()<MBProgressHUDDelegate,UITextFieldDelegate,CheckBoxTableViewCellDelegate,M_OrderUserViewControllerDelegate>
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
    NSMutableArray *additionalArr;
    
    NSString *submitDesc;//处理意见
    NSString *Y_Or_N;//是否新建账户
    NSString *next_processor_name; //下级执行人
    NSString *next_processor_id;
    
    NSString *select_type;
    NSString *stateStr;
    NSString *groupId;
}


@end

@implementation SA_Special_DetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SET_ACCOUTID_NOTIFY object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SA专用";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccountId:) name:SET_ACCOUTID_NOTIFY object:nil];
    
    process_infoArr = [NSMutableArray array];
    form_infoArr = [NSMutableArray array];
    All_form_infoArr = [NSMutableArray array];
    additionalArr = [NSMutableArray array];
    submitDesc = @"";
    Y_Or_N = @"";
    next_processor_name = @"";
    next_processor_id = @"";
    groupId = @"";
    
    self.isCheckBoxUnPass = NO; //默认通过
    
    userEntity = [UserEntity sharedInstance];
    
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
                if ([entity.name isEqualToString:@"company_num"]) {
                    
                    groupId = entity.cur_data_info;
                }
                
                [All_form_infoArr addObject:entity];
            }
            
            for (NSDictionary *attributes in process_infoARR) {
                
                M_process_infoEntity *entity = [[M_process_infoEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                
                [process_infoArr addObject:entity];
            }
            
            if ([[contentDic objectForKey:@"opreator"] count] > 0) {
                
                if (![[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-2"]) {
                    
                    
                    submitBtn = [self setNaviRightBtnWithTitle:[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_name"]];
                    
                    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_name"] length] >= 4) {
                        
                        submitBtn.frame = CGRectMake(0, 0, 100, 35);
                        
                        submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    }
                    
                    
                    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-3"]) {
                        
                        //催单
                        
                    }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"0"]) {
                        
                        //编辑
                        
                        
                    }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-4"]) {
                        
                        //业务办理
                        
                        
                    }else{
                        
                        
                        stateStr = [[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"];
                        select_type = [[contentDic objectForKey:@"opreator"] objectForKey:@"op1_select_type"];
                        
                        if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op2_id"] isEqualToString:@"-2"]) {
                            
                            //文本框
                            //下级执行人
                            //op1
                            
                        }else{
                            
                            //文本框
                            //单选框
                            //下级执行人
                            
                            submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
                            
                            [additionalArr addObject:@{@"title":@"审      核",@"type":@"4",@"message":@""}];
                            
                        }
                        if([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"0"]){
                            
                        }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"1"]){
                            
                            [additionalArr addObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"0",@"message":@""}];
                            
                        }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"2"]) {
                            //type = 5 :下拉框
                            [additionalArr addObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"5",@"message":@""}];
                            
                        }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
                            //type = 5 :下拉框
                            
                            NSArray *form_nameArr = [[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"] componentsSeparatedByString:@";"];
                            
                            [additionalArr addObject:@{@"title":form_nameArr.firstObject,@"type":@"0",@"message":@""}];
                            
                            [additionalArr addObject:@{@"title":form_nameArr.lastObject,@"type":@"5",@"message":@""}];
                            
                        }else{
                            
                        }
                    }
                    
                }
                
                [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if (select_user_list.count > 0) {
                
                next_processor_name = [select_user_list[0] objectForKey:@"name"];
                
                next_processor_id = [select_user_list[0] objectForKey:@"user_id"];
                
                [additionalArr addObject:@{@"title":@"下级执行人",@"type":@"1",@"message":next_processor_name}];
                
            }else{
                
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
    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-3"]) {
        
        [self urgeBtnClicked:nil];
        
        return;
    }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"-4"]) {
        
        // 业务办理

        [self GetSAdetail];
        
        return;
    }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"] isEqualToString:@"0"]){
        
        M_Order_Demand_SumiltViewController *vc = [[M_Order_Demand_SumiltViewController alloc]init];
        
        vc.form_infoArr =  All_form_infoArr;
        
        vc.order_id = self.order_id;
        
        for (M_Order_Demand_DetailEntity *entity in form_infoArr) {
            
            if ([entity.type_id isEqualToString:@"3"]) {
                if ([entity.cur_data_state intValue] == 0) {
                    
                    NSString *names = entity.cur_data_info;
                    
                    if (names.length > 0) {
                        NSArray *namesArr = [names componentsSeparatedByString:@";"];
                        
                        vc.uploadImagesArr = namesArr;
                        
                    }
                }
            }
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    
    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
        
        NSArray *form_nameArr = [[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"] componentsSeparatedByString:@";"];
        
        if (submitDesc.length == 0) {
            
            NSString *msg = [NSString stringWithFormat:@"%@不能为空！",form_nameArr.firstObject];
            
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if (Y_Or_N.length == 0) {
            
            NSString *msg = [NSString stringWithFormat:@"%@不能为空！",form_nameArr.lastObject];
            
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        
    }else{
        
        if (submitDesc.length == 0) {
            
            NSString *msg = [NSString stringWithFormat:@"%@不能为空！",[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"]];
            
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        
    }
    
    
    if ([[contentDic objectForKey:@"select_user_list"] count] > 0) {
        
        if ([select_type isEqualToString:@"1"]) {
            if (next_processor_name.length == 0) {
                ALERT_ERR_MSG(@"请选择下级执行人！");
                isDone = YES;
                return;
            }
        }
        
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    /*
     改变工单状态 m_order_change_state
     user_id 用户唯一ID
     order_id 工单唯一ID
     state 状态
     select_type 执行人选择情况
     remarks 备注
     当select_type = 1的时候：
     next_processor_id 下级执行人
     next_processor_name 下级执行人姓名
     */
    NSString *remarks = @"";
    
    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
        
        NSArray *form_nameArr = [[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"] componentsSeparatedByString:@";"];
        
        remarks = [NSString stringWithFormat:@"%@：%@;%@：%@",form_nameArr.firstObject,submitDesc,form_nameArr.lastObject,Y_Or_N];
        
    }else{
        remarks = [NSString stringWithFormat:@"%@:%@",[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],submitDesc];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"m_order_change_state",@"method",
                                self.order_id,@"order_id",
                                userEntity.user_id,@"user_id",
                                stateStr,@"state",
                                select_type,@"select_type",
                                remarks,@"remarks",
                                next_processor_id,@"next_processor_id",
                                next_processor_name,@"next_processor_name",
                                nil];
    
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[[contentDic objectForKey:@"opreator"] objectForKey:@"alert_info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
            }];
            
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

- (void)urgeBtnClicked:(id)sender{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"m_order_reminder",@"method",
                                self.order_id,@"order_id",
                                userEntity.user_id,@"user_id",
                                nil];
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已催单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            [self backBtnClicked:nil];
            
        }];
        
        
        if (state > 0) {
            
        }else{
            
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
                
                return form_infoArr.count + additionalArr.count + 1;
                
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
    static NSString *identifier4 = @"TxtFieldTableViewCell";
    static NSString *identifier5 = @"CheckBoxTableViewCell";
    
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
            
            TxtFieldTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier4
                                                       owner:nil
                                                     options:nil] firstObject];
                cell2.txtField.delegate = self;
            }
            
            cell2.indexPath = indexPath;
            cell2.txtField.tag = indexPath.row;
            
            if ([[[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"type"] isEqualToString:@"0"]) {
                
                
                [cell2.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                cell2.titleLbl.text = [[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"title"];
                
                cell2.txtField.placeholder = @"请填写处理意见";
                
                cell2.txtField.text = submitDesc;
                
                cell2.downArrowImageView.hidden = YES;
                
                return cell2;
                
            }else if([[[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"type"] isEqualToString:@"4"]){
                
                CheckBoxTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:identifier5];
                if (!cell3) {
                    cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier5 owner:nil options:nil] firstObject];
                    cell3.delegate = self;
                }
                cell3.indexPath = indexPath;
                cell3.titleLbl.text = [[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"title"];
                
                
                [cell3 setSelectDataWithArray:@[[[contentDic objectForKey:@"opreator"] objectForKey:@"op1_name"],[[contentDic objectForKey:@"opreator"] objectForKey:@"op2_name"]]];
                
                if (!self.isCheckBoxUnPass) {
                    [cell3 setSelectBtnIndex:1];
                }else{
                    [cell3 setSelectBtnIndex:2];
                }
                
                return cell3;
            }else if ([[[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"type"] isEqualToString:@"1"]) {
                
                cell2.titleLbl.text = [[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"title"];
                cell2.txtField.placeholder = [NSString stringWithFormat:@"请选择下级执行人"];
                cell2.txtField.text = next_processor_name;
                cell2.isNeedSelect = YES;
                cell2.downArrowImageView.hidden = NO;
                
                return cell2;
            }else if ([[[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"type"] isEqualToString:@"5"]) {
                
                cell2.titleLbl.text = [[additionalArr objectAtIndex:indexPath.row - form_infoArr.count - 1] objectForKey:@"title"];
                cell2.txtField.placeholder = [NSString stringWithFormat:@"请选择%@",cell2.titleLbl.text];
                
                if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
                    cell2.txtField.text = Y_Or_N;
                }else{
                    cell2.txtField.text = submitDesc;
                }
                
                cell2.isNeedSelect = YES;
                cell2.downArrowImageView.hidden = YES;
                
                return cell2;
            }else{
                
                return nil;
            }
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [tableView numberOfSections]-1) {
        if (indexPath.row == 0) {
            
        }else{
            M_process_infoEntity *entity = process_infoArr[indexPath.row - 1];
            
            if ([entity.remarks length] > 0) {
                
//                iToast *toast = [iToast makeText:entity.remarks];
//                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//                [toast setDuration:3000];
//                [toast show:iToastTypeNotice];

                ALERT_ERR_MSG(entity.remarks);
                
            }
        }
        
    }
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

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    if (selectedIndex == 1) {
        self.isCheckBoxUnPass = NO;
        //通过
        stateStr = [[contentDic objectForKey:@"opreator"] objectForKey:@"op1_id"];
        select_type = [[contentDic objectForKey:@"opreator"] objectForKey:@"op1_select_type"];
        
    }else{
        self.isCheckBoxUnPass = YES;
        //驳回
        stateStr = [[contentDic objectForKey:@"opreator"] objectForKey:@"op2_id"];
        select_type = [[contentDic objectForKey:@"opreator"] objectForKey:@"op2_select_type"];
        
    }
    
    
    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"show_option"] isEqualToString:@"0"]) {
        
    }else{
        
        if (!self.isCheckBoxUnPass) {
            
            [additionalArr addObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"0",@"message":@""}];
        }else{
            [additionalArr removeObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"0",@"message":@""}];
        }
        
    }
    
    //    if (!self.isCheckBoxUnPass) {
    //
    //        [additionalArr addObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"5",@"message":@""}];
    //    }else{
    //        [additionalArr removeObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"5",@"message":@""}];
    //    }
    
    //    if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"2"]){
    //
    //        [additionalArr addObject:@{@"title":[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"],@"type":@"5",@"message":@""}];
    //    }
    
    if ([select_type isEqualToString:@"0"] || [select_type isEqualToString:@"2"] || [select_type isEqualToString:@"3"] || [select_type isEqualToString:@"4"]) {
        
        
        [additionalArr removeObject:@{@"title":@"下级执行人",@"type":@"1",@"message":next_processor_name}];
        
    }else{
        
        
        [additionalArr addObject:@{@"title":@"下级执行人",@"type":@"1",@"message":next_processor_name}];
        
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
              withRowAnimation:UITableViewRowAnimationNone];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([additionalArr[textField.tag - form_infoArr.count - 1][@"type"] isEqualToString:@"1"]) {
        
        M_OrderUserViewController *vc = [[M_OrderUserViewController alloc]init];
        
        vc.delegate = self;
        
        vc.order_id = _order_id;
        
        vc.type_id = @"1";
        
        vc.Type = @"3";
        
        vc.arrayCutomer = [contentDic objectForKey:@"select_user_list"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if([additionalArr[textField.tag - form_infoArr.count - 1][@"type"] isEqualToString:@"0"]) {
        
    }else if([additionalArr[textField.tag - form_infoArr.count - 1][@"type"] isEqualToString:@"5"]) {
        
        [self.view endEditing:YES];
        
        NSArray *data_arr= [[[contentDic objectForKey:@"opreator"] objectForKey:@"form_option"] componentsSeparatedByString:@";"];
        
        NSString *form_name = @"";
        
        if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
            
            NSArray *form_nameArr = [[[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"] componentsSeparatedByString:@";"];
            
            if (form_nameArr.count > 1) {
                
                form_name = form_nameArr.lastObject;
            }
            
        }else{
            
            form_name = [[contentDic objectForKey:@"opreator"] objectForKey:@"form_name"];
            
        }
        
        
        [UIActionSheet showInView:self.view
                        withTitle:form_name
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:data_arr
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             for (int i = 0; i < data_arr.count; i ++ ) {
                                 if (buttonIndex == i) {
                                     
                                     if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"2"]) {
                                         
                                         submitDesc = data_arr[i];
                                         
                                         if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"dialog_box"] length] > 0) {
                                             
                                             NSArray *dialog_boxArr= [[[contentDic objectForKey:@"opreator"] objectForKey:@"dialog_box"] componentsSeparatedByString:@";"];
                                             
                                             for (NSString *str in dialog_boxArr) {
                                                 
                                                 NSRange range;
                                                 range = [str rangeOfString:@":"];
                                                 
                                                 if (range.location != NSNotFound) {
                                                     
                                                     if ([[str substringFromIndex:range.location + 1] isEqualToString:submitDesc]) {
                                                         
                                                         Business_BillListViewController *vc = [[Business_BillListViewController alloc]init];
                                                         
                                                         vc.groupId = groupId;
                                                         
                                                         [self.navigationController pushViewController:vc animated:YES];
                                                     }
                                                     
                                                 }else{
                                                     
                                                     NSLog(@"Not Found");
                                                     
                                                 }
                                                 
                                             }
                                             
                                         }
                                         
                                         
                                     }else if ([[[contentDic objectForKey:@"opreator"] objectForKey:@"form_type"] isEqualToString:@"3"]) {
                                         
                                         Y_Or_N = data_arr[i];
                                         
                                     }else{
                                         
                                         submitDesc = data_arr[i];
                                         
                                     }
                                     
                                     [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag inSection:0]]
                                                       withRowAnimation:UITableViewRowAnimationFade];
                                 }
                             }
                         }];
        return NO;
    }else{
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([additionalArr[textField.tag - form_infoArr.count - 1][@"type"] isEqualToString:@"0"]) {
        submitDesc = textField.text;
    }
    
}

- (void)successM_OrderUserDelegate:(NSDictionary *)successdelegate{
    
    next_processor_name = [successdelegate objectForKey:@"name"];
    next_processor_id = [successdelegate objectForKey:@"user_id"];
    
    [_tableView reloadData];
}

- (void)setAccountId:(id)sender{
    
    NSUserDefaults *AccountId = [NSUserDefaults standardUserDefaults];
    
    submitDesc = [NSString stringWithFormat:@"%@(%@)",submitDesc,[AccountId objectForKey:@"AccountId"]];
    
    [_tableView reloadData];
}

- (void)GetSAdetail{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{
                          @"method":@"m_get_order_sa_detail",
                          @"user_id":userEntity.user_id,
                          @"order_id":self.order_id,
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
        
           NSDictionary *contenDic = [entity objectForKey:@"content"];
            
            CustomerViewController *vc = [[CustomerViewController alloc]init];
            
            vc.enter_type = 10;
            
            vc.contenDic = contenDic;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
        }
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the tableView it might be occluding
    keyboardFrame = [_tableView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, _tableView.bounds);
    
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
            _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}


@end
