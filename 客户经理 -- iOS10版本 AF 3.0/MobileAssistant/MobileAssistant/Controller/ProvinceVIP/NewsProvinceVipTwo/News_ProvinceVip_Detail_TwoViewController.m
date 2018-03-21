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
#import "CheckBoxTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "News_PtovinceVip_Next_CustomerEntity.h"
#import "News_Select_Next_listViewController.h"
#import "MBProgressHUD.h"

#import "P_SpecialSubmitViewController.h"
#import "P_TerminalSubmitViewController.h"
#import "P_StockSubmitViewController.h"
#import "P_TerminalStockSubmitViewController.h"
#import "P_BookSubmitViewController.h"
#import "P_BillSubmitViewController.h"
#import "P_Marketing_PlanSubmitViewController.h"
#import "Basic_business_moduleSubmitViewController.h"
#import "News_ProvinceVip_Detail_TwoViewController.h"

@interface News_ProvinceVip_Detail_TwoViewController ()<CheckBoxTableViewCellDelegate,News_Select_Next_listViewControllerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSString *op_info;
    TwoLablesTableViewCell *cell1;
    CheckBoxTableViewCell *cell2;
    TxtFieldTableViewCell *cell3;
    UIButton *submitBtn;
    NSMutableArray *typearr;
    NSMutableArray *formsMuArr;
    UserEntity *userInfo;
    MBProgressHUD *HUD;
}
@property (nonatomic,assign) BOOL isCheckBoxUnPass;
///处理意见
@property (nonatomic, copy) NSString *submitDesc;
@property (nonatomic, copy) NSString *next_processor_id;
@property (nonatomic, copy) NSString *next_name;
@end

@implementation News_ProvinceVip_Detail_TwoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情",_titleName];
    
    userInfo = [UserEntity sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.isCheckBoxUnPass = NO; //默认通过
    
    self.detailMuArr = [NSMutableArray array];
    self.select_listMuArr = [NSMutableArray array];
    self.processMuArr = [NSMutableArray array];
    formsMuArr = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self getBusinessDetailWithGroup:group];
    
    //任务组完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self setRightBtn];
        
        // 刷新表格
        [_tableView reloadData];

        
    });
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightBtn{    //提交
    
    if([op_info isEqualToString:@"-1"]){
        
    }else if ([op_info isEqualToString:@"-2"]){
        
        submitBtn = [self setNaviRightBtnWithTitle:@"编辑"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    } else{
        
        NSArray *arr = [op_info componentsSeparatedByString:@";"];
        typearr = [[NSMutableArray alloc]init];
        for (NSString *str in arr) {
            
            NSRange range;
            range = [str rangeOfString:@":"];
            
            if (range.location != NSNotFound) {
                
                NSDictionary *dic = @{@"str":[str substringToIndex:range.location],
                                      @"num":[str substringFromIndex:range.location + 1]
                                      };
                [typearr addObject:dic];
                
            }else{
                
                NSLog(@"Not Found");
                
            }
            
        }
        
        if (typearr.count > 0) {
            
            self.submitState = [typearr[0][@"num"] intValue];

            if (typearr.count == 1) {
                
                submitBtn = [self setNaviRightBtnWithTitle:typearr[0][@"str"]];
                [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [formsMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                
            }else{
                
                submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
                [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [formsMuArr addObject:@{@"title":@"处       理:",@"type":@"Check"}];
                [formsMuArr addObject:@{@"title":@"审核领导",@"type":@"Select"}];
                [formsMuArr addObject:@{@"title":@"审核意见:",@"type":@"Input"}];
                
            }
        }
        
    }
}

- (void)submitBtnClicked:(id)sender{
    
    if ([submitBtn.titleLabel.text isEqualToString:@"编辑"]) {
        
        [self chageViewController];
        
        return;
    }
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSDictionary *dict = @{@"state":@(self.submitState),
                           @"business_id":self.business_id,
                           @"user_id":userInfo.user_id,
                           @"method":@"change_state",
                           @"next_processor":self.next_processor_id,
                           @"info":self.submitDesc?self.submitDesc:@"",
//                           @"remark":self.make_card_num?self.make_card_num:@""
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        isDone = YES;
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
        [HUD hide:YES];
    }];
    
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
            
            for (NSDictionary *attributes in entity[@"content"][@"select_list"]) {
                
                News_PtovinceVip_Next_CustomerEntity *entity = [[News_PtovinceVip_Next_CustomerEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                
                [self.select_listMuArr addObject:entity];
                
            }
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
        
        return [_detailMuArr count] + [formsMuArr count];
    }else{
        return [_processMuArr count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"ThreeLabelsTableViewCell";
    static NSString *identifier3 = @"CheckBoxTableViewCell";
    static NSString *identifier4 = @"TxtFieldTableViewCell";
    
    cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) { //详情
        
        if (indexPath.row < _detailMuArr.count) {

            NSDictionary *dict = _detailMuArr[indexPath.row];
            
            cell1.titleLbl.text = [NSString stringWithFormat:@"%@:",dict[@"ch_name"]];
            
            cell1.subTitleLbl.text = dict[@"value"];
            
            return cell1;
            
        }else{
            
            NSDictionary *dict = formsMuArr[indexPath.row - _detailMuArr.count];
            
            if ([dict[@"type"] isEqualToString:@"Check"]) {
                
                cell2 = [tableView dequeueReusableCellWithIdentifier:identifier3];
                if (!cell2) {
                    cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell2.delegate = self;
                }
                
                cell2.titleLbl.text = dict[@"title"];
                
                [cell2 setSelectDataWithArray:@[typearr[1][@"str"],typearr[1][@"str"]]];
                
                if (!self.isCheckBoxUnPass) {
                    [cell2 setSelectBtnIndex:1];
                }else{
                    [cell2 setSelectBtnIndex:2];
                }
                
                return cell2;
                
            }else if ([dict[@"type"] isEqualToString:@"Input"]|
                      [dict[@"type"] isEqualToString:@"Select"]) {
                
                cell3 = [tableView dequeueReusableCellWithIdentifier:identifier4];
                if (!cell3) {
                    cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil] firstObject];
                    cell3.txtField.delegate = self;
                    cell3.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell3.txtField.tag = indexPath.row;
                
                cell3.titleLbl.text = dict[@"title"];
                
                cell3.txtField.placeholder = @"";

                if ([dict[@"type"] isEqualToString:@"Select"]) {
                    
                    cell3.txtField.placeholder = @"请选择下级处理人";
                    
                    cell3.txtField.text = _next_name;
                    
                }else{
                    
                    cell3.txtField.text = self.submitDesc;
                }
                
                return cell3;
            
            }else{
                return cell1;
            }
        }

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSDictionary *dict = formsMuArr[textField.tag - _detailMuArr.count];
    
    if ([dict[@"type"] isEqualToString:@"Input"]) {
        
        
    }else if ([dict[@"type"] isEqualToString:@"Select"]){
        
        [self.view endEditing:YES];
        
        News_Select_Next_listViewController *vc = [[News_Select_Next_listViewController alloc]init];
        
        vc.delegate = self;
        
        vc.arrayCutomer = self.select_listMuArr;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else{
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *dict = formsMuArr[textField.tag - _detailMuArr.count];
    
    if ([dict[@"type"] isEqualToString:@"Input"]) {
        
        self.submitDesc = textField.text;

    }else if ([dict[@"type"] isEqualToString:@"Select"]){
        
    }else{
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)News_Select_Next_listViewControllerViewController:(News_Select_Next_listViewController *)vc didSelectCompany:(News_PtovinceVip_Next_CustomerEntity *)entity{
    
    self.next_name = entity.name;
    
    self.next_processor_id = entity.user_id;
    
    [_tableView reloadData];
    
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{

    if (selectedIndex == 1) {
        
        self.isCheckBoxUnPass = NO; 
        
        self.submitState = [typearr[0][@"num"] intValue];
        
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                  withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        self.isCheckBoxUnPass = YES;

        self.submitState = [typearr[1][@"num"] intValue];
        
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                  withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

- (void)chageViewController{
    
    NSMutableDictionary *detailDict = [NSMutableDictionary dictionary]; //被驳回时重新提交内容

    for (NSDictionary *dict in _detailMuArr) {
        
        [detailDict setValue:dict[@"value"] forKey:dict[@"key_name"]];
    }
    
    NSMutableArray *arr = [News_BusinessListModel keyValuesArrayWithObjectArray:self.listMuArr];
   
    NSMutableArray *arrr = [BusinessListModel objectArrayWithKeyValuesArray:arr];
   
    BusinessListModel *bListModel = [arrr objectAtIndex:0];
    
    if ([self.typeId isEqualToString:@"1"]) {
        
        P_SpecialSubmitViewController *vc = [[P_SpecialSubmitViewController alloc] init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"3"]){
        
        P_TerminalSubmitViewController *vc = [[P_TerminalSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"4"]){
        
        P_StockSubmitViewController *vc = [[P_StockSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"9"]){

        P_TerminalStockSubmitViewController *vc = [[P_TerminalStockSubmitViewController alloc] initWithNibName:@"P_TerminalSubmitViewController" bundle:nil];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"6"]){
        
        P_BookSubmitViewController *vc = [[P_BookSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"8"]){
        
        P_BillSubmitViewController *vc = [[P_BillSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"15"]){
        
        P_Marketing_PlanSubmitViewController *vc = [[P_Marketing_PlanSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.typeId isEqualToString:@"16"]){
        Basic_business_moduleSubmitViewController *vc = [[Basic_business_moduleSubmitViewController alloc]init];
        vc.detailDict = detailDict;
        vc.bListModel = bListModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
