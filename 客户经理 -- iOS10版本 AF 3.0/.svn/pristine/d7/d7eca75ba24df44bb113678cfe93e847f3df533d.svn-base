//
//  P_Vertical_industry_collaborationDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/21.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_Vertical_industry_collaborationDetailViewController.h"
#import "ThreeLabelsTableViewCell.h"
#import "TwoLablesTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "BtnTableViewCell.h"
#import "ImagesBrowserViewController.h"
#import "TxtFieldTableViewCell.h"
#import "News_ClickBtnTableViewCell.h"
#import "P_Vertical_industry_collaborationSubmitViewController.h"
#import "MBProgressHUD.h"
@interface P_Vertical_industry_collaborationDetailViewController ()<UITextFieldDelegate,CheckBoxTableViewCellDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    TwoLablesTableViewCell *cell1;
    TxtFieldTableViewCell *cell2;
    CheckBoxTableViewCell *cell3;
    BtnTableViewCell *cell4;
    News_ClickBtnTableViewCell *cell6;
    NSMutableArray *detailMuArr;

    NSMutableDictionary *detailDic;
    
    NSMutableArray *selsecArr;
    NSMutableArray *historyArr;
}
@property (strong, nonatomic) NSString *num;
@end

@implementation P_Vertical_industry_collaborationDetailViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCheckBoxUnPass = NO; //默认通过
    
    self.navigationItem.title = @"纵向行业任务协同";
    
    selsecArr = [[NSMutableArray alloc]init];
    
    detailDic = [[NSMutableDictionary alloc]init];
    historyArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"主      题：", @"detail":@"title",         @"type":@"Label"},
                   @{@"title":@"提交人 ：",     @"detail":@"submit_name",   @"type":@"Label"},
                   @{@"title":@"联系方式：",   @"detail":@"tel",              @"type":@"Label"},
                   @{@"title":@"操作部门：",   @"detail":@"dep_name",    @"type":@"Label"},
                   @{@"title":@"操作时间：",   @"detail":@"op_time",     @"type":@"Label"},
                   @{@"title":@"处理时限：",   @"detail":@"to_day",        @"type":@"Label"},
                   @{@"title":@"集团产品：",   @"detail":@"product",     @"type":@"Label"},
                   @{@"title":@"紧急程度：",   @"detail":@"level",     @"type":@"Label"},
                   @{@"title":@"任务类别：",   @"detail":@"type",        @"type":@"Label"},
                   @{@"title":@"合同上传：",   @"detail":@"dep_name",         @"type":@"Btn"},
                   @{@"title":@"任务描述：",   @"detail":@"content",         @"type":@"Label"},
                   @{@"title":@"备      注：", @"detail":@"marks",         @"type":@"Label"},
                   @{@"title":@"派发对象：",   @"detail":@"target_name",         @"type":@"Label"},
                   @{@"title":@"状      态：", @"detail":@"state_name",          @"type":@"Label"},nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([self.entity.state intValue] == 4) {
        NSArray *array = @[@{@"title":@"处理意见:",@"detail":@"reply",@"type":@"Label"}];
        
        [detailMuArr addObjectsFromArray:array];
    }
    
    [self getDetail];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑
- (void)editBtnClicked:(id)sender
{
    P_Vertical_industry_collaborationSubmitViewController *vc = [[P_Vertical_industry_collaborationSubmitViewController alloc]init];
    
    vc.entity = self.entity;
    
    if (self.entity.images.length > 0) {
        NSString *names = [self.entity.images substringFromIndex:1];
        if (names.length > 0) {
            vc.uploadImagesArr = [names componentsSeparatedByString:@","];
        }
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

//提交
- (void)SubmitBtnClicked:(UIButton *)sender{
 
    [self.view endEditing:YES];
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    
    NSString *useridStr = [[NSString alloc]init];
    NSString *usernameStr = [[NSString alloc]init];
    
    if (selsecArr.count < [[detailDic objectForKey:@"select"] count] && [self.num isEqualToString:[self addtypeArr][0]]) {
        ALERT_ERR_MSG(@"请选择下级执行人");
        isDone = YES;
        return;
    }
    
    if ([self.entity.state intValue] == 3 && self.submitDesc.length == 0) {
        ALERT_ERR_MSG(@"请填写处理意见");
        isDone = YES;
        return;
    }
    
    if ([self.num isEqualToString:[self addtypeArr][0]]) {
        
        if (selsecArr.count > 0) {
            
            for (NSDictionary *dic in selsecArr) {
                
                NSString *string1 = [NSString stringWithFormat:@"%@",dic[@"list"][@"user_id"]];
                useridStr = [useridStr stringByAppendingFormat:@"%@;",string1];
                
                NSString *string2 = [NSString stringWithFormat:@"%@",dic[@"list"][@"name"]];
                usernameStr = [usernameStr stringByAppendingFormat:@"%@;",string2];
                
            }
            
            useridStr = [useridStr substringToIndex:useridStr.length - 1];
            usernameStr = [usernameStr substringToIndex:usernameStr.length - 1];

        }
        
    }

//    if ([[detailDic objectForKey:@"select"] count] > 0) {
//        
//    }else{
//        useridStr = userEntity.user_id;
//        usernameStr = userEntity.name;
//    }
    
    if ([self addtypeArr].count == 1) {
        
        NSArray *arr = [[[detailDic valueForKey:@"content"] valueForKey:@"op"] componentsSeparatedByString:@":"];
        
        self.num = arr[1];
        
    }
    
    
        
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSDictionary *dict = @{@"method":@"change_teamwork_state",
                           @"user_id":userEntity.user_id,
                           @"teamwork_id":self.entity.teamwork_id,
                           @"state":self.num,
                           @"next_process_id":useridStr,
                           @"next_processor_name":usernameStr,
                           @"reply":[self.entity.state intValue] == 3?self.submitDesc:@"",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                //                [self.navigationController popViewControllerAnimated:YES];
                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
           
        }else{
            ALERT_ERR_MSG(@"提交失败");
            
        }
        
        [_tableView reloadData];
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
        isDone = YES;
        [HUD hide:YES];
    }];
    
}

//获取详情
- (void)getDetail{
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"teamwork_detail",
                           @"user_id":userEntity.user_id,
                           @"teamwork_id":self.entity.teamwork_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 0) {
            
            
        }else{
       
            [detailDic addEntriesFromDictionary:entity];
            
            [historyArr addObjectsFromArray:[entity valueForKey:@"history"]];
            
            NSString *opStr = [[entity valueForKey:@"content"] valueForKey:@"op"];
            if (opStr.length > 0) {
                
                self.num = [self addtypeArr][0];
                if ([opStr rangeOfString:@"编辑"].location != NSNotFound) {
                    
                    UIButton *recieveBtn = [self setNaviRightBtnWithTitle:@"编辑"];
                    [recieveBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
                }else{
                    UIButton *addBtn = [self setNaviRightBtnWithTitle:@"提交"];
                    [addBtn addTarget:self action:@selector(SubmitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                   
                    if ([self.entity.state intValue] == 3) {
                        
                        NSArray *array = @[@{@"title":@"处理意见",@"type":@"Input"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                    }else{
                        
                        NSArray *array = @[@{@"title":@"审      核：",@"type":@"Check"}];
                        
                        [detailMuArr addObjectsFromArray:array];
                    }
                    
                }
               
                NSMutableArray *selectArr = [[NSMutableArray alloc]init];

                [selectArr addObjectsFromArray:[entity valueForKey:@"select"]];
                
                if (selectArr.count > 0) {
                    for (NSDictionary *dic in selectArr) {
                        NSArray *arr = @[@{@"title":[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]],   @"detail":@"content",    @"type":@"Select"}];
                        [detailMuArr addObjectsFromArray:arr];
                    }
                }
               
            }

        }
        
        [_tableView reloadData];
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return detailMuArr.count;
    }else if (section == 1){
        return historyArr.count + 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"ThreeLabelsTableViewCell";
    static NSString *identifier3 = @"CheckBoxTableViewCell";
    static NSString *identifier4 = @"BtnTableViewCell";
    static NSString *identifier5 = @"TxtFieldTableViewCell";
    static NSString *identifier6 = @"News_ClickBtnTableViewCell";
    
    if (indexPath.section == 0) {
        
        NSDictionary *dict = detailMuArr[indexPath.row];
        
        NSString *title = dict[@"title"];
        
        NSString *type = dict[@"type"]; //类型
        
        if ([type isEqualToString:@"Label"]) {
            
            cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell1) {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cell1.titleLbl.text = title;
            NSString *detailKey = @"";
            
            if ([[dict allKeys] containsObject:@"detail"]) {
                detailKey = dict[@"detail"];
                
                cell1.subTitleLbl.text = [self.entity valueForKey:detailKey];
            }
            return cell1;
        }else if([type isEqualToString:@"Check"]){
            
            cell3 = [tableView dequeueReusableCellWithIdentifier:identifier3];
            
            if (!cell3) {
                cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                cell3.delegate = self;
            }
            cell6 = [tableView dequeueReusableCellWithIdentifier:identifier6];
            if (!cell6) {
                cell6 = [[[NSBundle mainBundle] loadNibNamed:identifier6 owner:nil options:nil] firstObject];
                cell6.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell3.indexPath = indexPath;
            
            if ([self addtypeArr].count == 2) {
                cell3.titleLbl.text = title;
                
                [cell3 setSelectDataWithArray:@[@"通过",@"不通过"]];
                
                if (!self.isCheckBoxUnPass) {
                    [cell3 setSelectBtnIndex:1];
                }else{
                    [cell3 setSelectBtnIndex:2];
                }
                
                return cell3;
            }else{
                
                NSArray *arr = [[[detailDic valueForKey:@"content"] valueForKey:@"op"] componentsSeparatedByString:@":"];
                
                cell6.titleLabel.text = title;
                
                cell6.clickBtn.selected = YES;
                
                cell6.clickBtn.tag = indexPath.row;
                
                [cell6.clickBtn setImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateNormal];

                [cell6.clickBtn setTitle:arr[0] forState:UIControlStateNormal];
                
                return cell6;
            }

        }else if([type isEqualToString:@"Input"]|
                 [type isEqualToString:@"Select"]){
            cell2 = [tableView dequeueReusableCellWithIdentifier:identifier5];
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier5
                                                      owner:nil
                                                    options:nil] firstObject];
                cell2.txtField.delegate = self;
            }
            
            cell2.indexPath = indexPath;
            cell2.txtField.tag = indexPath.row;
            
            cell2.titleLbl.text = [NSString stringWithFormat:@"%@:",title];
            
            NSString *placeholder1 = dict[@"placeholder"];
            NSString *placeholder = nil;
            if (!placeholder1) {
                placeholder = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            if ([type isEqualToString:@"Input"]) {
                if (placeholder1) {
                    cell2.txtField.placeholder = placeholder1;
                }else{
                    cell2.txtField.placeholder = [NSString stringWithFormat:@"请输入%@",placeholder];
                }
                cell2.txtField.text = self.submitDesc;
                cell2.isNeedSelect = NO;
                cell2.downArrowImageView.hidden = YES;
                
                NSString *keyboardType = dict[@"keyboardType"];
                if ([keyboardType isEqualToString:@"number"]) {
                    //                    cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
                }else{
                    cell2.txtField.keyboardType = UIKeyboardTypeDefault;
                }
                
            }else if([type isEqualToString:@"Select"]){
                cell2.txtField.placeholder = [NSString stringWithFormat:@"请选择%@的执行人",placeholder];
//                cell2.txtField.text = self.selectedUserModel.name;
                for (NSDictionary *dic in selsecArr) {
                    if ([[dic objectForKey:@"title"] isEqualToString:detailMuArr[indexPath.row][@"title"]]) {
                        
                        cell2.txtField.text = [[dic objectForKey:@"list"] objectForKey:@"name"];

                    }
                }
                
                cell2.isNeedSelect = YES;
                cell2.downArrowImageView.hidden = YES;
            }
            
            return cell2;
        }else if([type isEqualToString:@"Btn"]){
            cell4 = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (!cell4) {
                cell4 = [[[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil] firstObject];
                
                [cell4.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell4.btn.tag = indexPath.row;
            
            cell4.titleLbl.text = [NSString stringWithFormat:@"%@",title]; ;
            
            if (self.entity.images.length > 0) {
                NSString *names = [self.entity.images substringFromIndex:1];
                if (names.length > 0) {
                    NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
                    if (imagesNameArr.count > 0) {
                        [cell4.btn setTitle:@"查看" forState:UIControlStateNormal];
                    }else{
                        [cell4.btn setTitle:@"暂无" forState:UIControlStateNormal];
                    }
                }
            }else{
                [cell4.btn setTitle:@"暂无" forState:UIControlStateNormal];
            }
            
            return cell4;
            
        }

        return cell1;
    }else if (indexPath.section == 1) {
     
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
            
            
//            if ([model.state intValue] == 99) {
//                NSArray *arr = [model.user_name componentsSeparatedByString:@","];
//                if ([arr count] == 2) {
//                    cell.leftLbl.text = [NSString stringWithFormat:@"%@待处理",[StringHelper getUserType:[arr[0] intValue]]];
//                    cell.middleLbl.text = arr[1];
//                    cell.rightLbl.text = model.time;
//                }
//            }else{
                cell.leftLbl.text = historyArr[indexPath.row - 1][@"state_name"];
                cell.middleLbl.text = historyArr[indexPath.row - 1][@"user_name"];
                cell.rightLbl.text = historyArr[indexPath.row - 1][@"time"];
//            }
        }
        
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 处理记录";
    }
    
    return title;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
    
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (cell.isNeedSelect) {
        
            NSDictionary *dict = detailMuArr[textField.tag];
            NSString *type = dict[@"type"]; //类型
            if ([type isEqualToString:@"Select"]) {
                Select_section_ManmerViewController *vc = [[Select_section_ManmerViewController alloc] init];
                
                vc.delegate = self;
                vc.type = @"2";
                vc.selectDic = [[detailDic objectForKey:@"select"] objectAtIndex:textField.tag - 15];
                
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        
        return !cell.isNeedSelect;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (!cell.isNeedSelect) {
            self.submitDesc = textField.text;
        }
    }
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    NSMutableArray *typearr = [self addtypeArr];

    if (selectedIndex == 1) {
        self.isCheckBoxUnPass = NO;
        self.num = typearr[0];
        
    }else{
        self.isCheckBoxUnPass = YES;
        self.num = typearr[1];
    }
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    if (self.entity.images.length > 0) {
        NSString *names = [self.entity.images substringFromIndex:1];
        if (names.length > 0) {
            NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
            
            ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
            vc.imagesNameArray = imagesNameArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)Select_section_ManmerViewController:(Select_section_ManmerViewController *)vc didSelectUser:(NSMutableDictionary *)dic{
    
    NSDictionary *remDic = [[NSDictionary alloc]init];
    bool isBool = NO;
    for (NSDictionary *dicc in selsecArr) {
        
        if ([[dicc objectForKey:@"title"] isEqualToString:[dic objectForKey:@"title"]]) {
            
//            [selsecArr removeObject:dicc];
            remDic = dicc;
            isBool =YES;
        }
    }

    if (isBool) {
        [selsecArr removeObject:remDic];
    }
    [selsecArr addObject:dic];
    
    [_tableView reloadData];
    
}

- (NSMutableArray *)addtypeArr{
    
    
    NSArray *arr = [[[detailDic objectForKey:@"content"] valueForKey:@"op"] componentsSeparatedByString:@";"];
    NSMutableArray *typearr = [[NSMutableArray alloc]init];
    for (NSString *str in arr) {
        NSRange range;
        range = [str rangeOfString:@":"];
        
        if (range.location != NSNotFound) {
            [typearr addObject:[str substringFromIndex:range.location+range.length]];
            
        }
    }
    
    return typearr;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
