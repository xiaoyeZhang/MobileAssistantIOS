//
//  Postpaid_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/25.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Postpaid_DetailViewController.h"
#import "MBProgressHUD.h"
#import "LineTwoLabelTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "TxtFieldTableViewCell.h"

@interface Postpaid_DetailViewController ()<MBProgressHUDDelegate,CheckBoxTableViewCellDelegate,UITextFieldDelegate>{
    
    LineTwoLabelTableViewCell *cell;
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    NSString *remark;
}
@property (copy, nonatomic) NSString *submitState;
@property (strong, nonatomic) NSDictionary *dicCutomer;
@property (strong, nonatomic) NSMutableArray *detailMuArr;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Postpaid_DetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"后付费审批详情";
    
    userEntity = [UserEntity sharedInstance];
    self.arrayCutomer = [NSMutableArray array];
    
    remark = @"";
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.isCheckBoxUnPass = NO; //默认通过
    self.submitState = @"2";
    
    [self initData];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    
    NSString *stateStr = @"";
//    0---已提交   -1 审核不通过   1审核通过
    if ([_entity.state intValue] == 0) {
        stateStr = @"已提交";
    }else if ([_entity.state intValue] == -1){
        stateStr = @"审核不通过";
    }else if ([_entity.state intValue] == 1){
        stateStr = @"审核通过";
    }
    
    self.detailMuArr = [[NSMutableArray alloc] initWithObjects:
                        @{@"title":@"客户经理：",@"detail":_entity.user_name},
                        @{@"title":@"申请部门：",@"detail":_entity.dep_name},
                        @{@"title":@"集团名称：",@"detail":_entity.company_name},
                        @{@"title":@"集团编号：",@"detail":_entity.company_num},
                        @{@"title":@"后付费周期：",@"detail":_entity.cycle},
                        @{@"title":@"申请说明：",@"detail":_entity.info},
                        @{@"title":@"备注：",@"detail":_entity.remark},
                        @{@"title":@"审核流程：",@"detail":_entity.infos},nil];
    
    if (_entity.state.length > 0) {
        
        [self.detailMuArr insertObject:@{@"title":@"审核状态：",@"detail":stateStr} atIndex:[self.detailMuArr count] - 1];
    }
    
    if (_entity.suggestion.length > 0) {
        
        [self.detailMuArr insertObject:@{@"title":@"处理意见：",@"detail":_entity.suggestion} atIndex:[self.detailMuArr count] - 1];
    }
    
    NSArray *array = @[@{@"title":@"审批意见：",@"type":@"Check"},
                       @{@"title":@"处理意见：",@"type":@"Input",@"placeholder":@"请输入处理意见"}];
    
    if ([_entity.state intValue] == 0 && [_entity.next_processor isEqualToString:userEntity.user_id]) {
        
        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"审核"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.detailMuArr addObjectsFromArray:array];
        
    }else{
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailMuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_entity.state intValue] == 0 && [_entity.next_processor isEqualToString:userEntity.user_id]) {
        
        if (indexPath.row == self.detailMuArr.count - 1 || indexPath.row == self.detailMuArr.count - 2) {
            
            return 44;
            
        }
    }
    
    CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                            .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 40;
    }
    return size.height + 28;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LineTwoLabelTableViewCell";
    static NSString *identifier1 = @"CheckBoxTableViewCell";
    static NSString *identifier2 = @"TxtFieldTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([[self.detailMuArr[indexPath.row] allKeys] containsObject:@"type"]){
        
        if ([self.detailMuArr[indexPath.row][@"type"] isEqualToString:@"Check"]) {
            CheckBoxTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell1) {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell1.delegate = self;
            }
            
            cell1.titleLbl.text = self.detailMuArr[indexPath.row][@"title"];
            
            [cell1 setSelectDataWithArray:@[@"是",@"否"]];
            
            if (!self.isCheckBoxUnPass) {
                [cell1 setSelectBtnIndex:1];
            }else{
                [cell1 setSelectBtnIndex:2];
            }
            
            return cell1;
            
        }else {
            
            TxtFieldTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier2
                                                       owner:nil
                                                     options:nil] firstObject];
                cell2.txtField.delegate = self;
            }
            
            cell2.indexPath = indexPath;
            cell2.txtField.tag = indexPath.row;
            
            cell2.titleLbl.text = self.detailMuArr[indexPath.row][@"title"];
            cell2.txtField.placeholder = self.detailMuArr[indexPath.row][@"placeholder"];
            
            return cell2;
        }
        
    }else{
        cell.titLabel.text = self.detailMuArr[indexPath.row][@"title"];
        cell.subTitleLbl.layer.borderWidth = 0.5;
        cell.subTitleLbl.font = [UIFont systemFontOfSize:14];
        cell.subTitleLbl.layer.cornerRadius = 6;
        cell.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
        
        cell.subTitleLbl.textColor = [UIColor darkGrayColor];
        cell.subTitleLbl.text = self.detailMuArr[indexPath.row][@"detail"];
        
        return cell;
        
    }
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    if (selectedIndex == 1) {
        self.isCheckBoxUnPass = NO;
        
        self.submitState = @"1";
        
    }else{
        self.isCheckBoxUnPass = YES;
        self.submitState = @"-1";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        if (!cell.isNeedSelect) {
            remark = textField.text;
        }
    }
}

- (void)submitBtnClicked:(UIButton *)sender{
    
//    m_postpaid_check
//    postpaid_id：唯一ID
//    remark：备注
//    state=-1不通过  1通过
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    if ([remark isEqualToString:@""]){
        ALERT_ERR_MSG(@"处理意见不能为空");
        isDone = YES;
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_postpaid_check" forKey:@"method"];
    [dict setObject:userEntity.user_id forKey:@"user_id"];
    [dict setObject:_entity.postpaid_id forKey:@"postpaid_id"];
    [dict setObject:remark forKey:@"remark"];
    [dict setObject:self.submitState forKey:@"state"];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        //        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if (state > 0) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
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
