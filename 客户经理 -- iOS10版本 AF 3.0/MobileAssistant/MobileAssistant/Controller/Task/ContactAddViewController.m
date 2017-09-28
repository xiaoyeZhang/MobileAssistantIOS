////
////  ContactAddViewController.m
////  MobileAssistant
////
////  Created by 房 国生 on 14-10-7.
////  Copyright (c) 2014年 avatek. All rights reserved.
////
//
//#import "ContactAddViewController.h"
//#import "MBProgressHUD.h"
//#import "ExecutorTableViewCell.h"
//#import "CommonService.h"
//#import "UserEntity.h"
//#import "ContactEntity.h"
//#import "Utilies.h"
//#import "SIAlertView.h"
//#import "LineTwoLabelTableViewCell.h"
//#import "TxtFieldTableViewCell.h"
//#import "UIActionSheet+Block.h"
//#import "UIAlertView+Blocks.h"
//
//@interface ContactAddViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
//{
//    MBProgressHUD *HUD;
//    NSString *level;
//    NSMutableArray *detailMuArr;
//    TxtFieldTableViewCell *cell;
//    LineTwoLabelTableViewCell *cell1;
//}
/////成员种类
//@property(nonatomic, copy) NSString *kind;
////成员类型
//@property(nonatomic, copy) NSString *type;
/////成员类别
//@property(nonatomic, copy) NSString *MemberLevel;
/////关键人物级别
//@property(nonatomic, copy) NSString *KernelLevel;
/////主要成员
//@property(nonatomic, copy) NSString *IsMain;
/////主要联系人
//@property(nonatomic, copy) NSString *IsMainLinkMan;
/////是否添加成员
//@property(nonatomic, copy) NSString *IsAddMember;
//////集团成员角色
////@property(nonatomic, copy) NSString *PartyRoleId;
/////姓名
//@property(nonatomic, copy) NSString *name;
/////职务
//@property(nonatomic, copy) NSString *job;
/////电话
//@property(nonatomic, copy) NSString *tel;
//@end
//
//
//@implementation ContactAddViewController
//
//
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    self.title = @"添加联系人";
//    [self select_logmodel:NSStringFromClass([self class])];
//    
//    NSInteger height = [self getBoardHeight:YES];
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
//    //bgImageView.backgroundColor = GrayBackgroundColor;
//    bgImageView.image = [UIImage imageNamed:@"background"];
//    [self.view addSubview:bgImageView];
//    
//    //    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    //    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    //    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    //    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    //    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    //    self.navigationItem.leftBarButtonItem = backButtonItem;
//    
//    UIButton *backBtn = [self setNaviCommonBackBtn];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
//    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
//    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
//    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
//    self.navigationItem.rightBarButtonItem = nextButtonItem;
//    
//    [self initData];
//    
//    self.kind = @"1";
//    self.type = @"1";
//    self.MemberLevel = @"2";
//    self.KernelLevel = @"0";
//    self.IsMain = @"1";
//    self.IsMainLinkMan = @"1";
//    self.IsAddMember = @"1";
//}
//
//- (void)initData
//{
//    detailMuArr = [[NSMutableArray alloc] initWithObjects:
//                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
//                   @{@"title":@"集团地址：",      @"num":@"1",    @"type":@"Text"},
//                   @{@"title":@"成员种类：",      @"num":@"2",    @"type":@"Text"},
//                   @{@"title":@"成员类型：",      @"num":@"3",   @"type":@"Text"},
//                   @{@"title":@"职       务：",   @"num":@"6",   @"type":@"Text"},
//                   @{@"title":@"电       话：",   @"num":@"7",   @"type":@"Text"},
//                   @{@"title":@"主要成员：",      @"num":@"7",   @"type":@"Text"},
//                   @{@"title":@"主要联系人：",     @"num":@"7",   @"type":@"Text"},
//                   @{@"title":@"添加集团成员：",   @"num":@"8",   @"type":@"Text"},
//                   nil];
//    [_tableView reloadData];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [MobClick endLogPageView:@"ContactAddViewController"];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [MobClick beginLogPageView:@"ContactAddViewController"];
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [detailMuArr count];
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0 || indexPath.row == 1) {
//        CGFloat cellheight;
//        cellheight = cell1.subTitleLbl.layer.frame.size.height;
//        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
//                                                                 .size.width, MAXFLOAT)];
//        if (size.height == 0) {
//            return 44;
//        }
//        return size.height + 27;
//    }
//    return 44;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"TxtFieldTableViewCell";
//    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
//    
//    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
//        cell.txtField.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    cell.indexPath = indexPath;
//    cell.txtField.tag = indexPath.row;
//    cell.txtField.textAlignment = NSTextAlignmentCenter;
//    cell.txtField.returnKeyType = UIReturnKeyDone;
//    [cell.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    
//    NSDictionary *dict = detailMuArr[indexPath.row];
//    
//    NSString *title = dict[@"title"];
//    
//    NSString *type = dict[@"type"]; //类型
//    
//    if ([type isEqualToString:@"Text"]) {
//        
//        switch (indexPath.row) {
//            case 0:
//            {
//                
//                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
//                if(!cell1)
//                {
//                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
//                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                cell1.titLabel.text = title;
//                cell1.subTitleLbl.layer.borderWidth = 0.5;
//                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
//                cell1.subTitleLbl.layer.cornerRadius = 6;
//                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
//                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.name];
//                
//                return cell1;
//                
//                break;
//            }
//            case 1:
//            {
//                
//                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
//                if(!cell1)
//                {
//                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
//                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                cell1.titLabel.text = title;
//                cell1.subTitleLbl.layer.borderWidth = 0.5;
//                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
//                cell1.subTitleLbl.layer.cornerRadius = 6;
//                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
//                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.address];
//                
//                return cell1;
//                break;
//            }
//            case 2:
//            {
//                
//                
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"请选择";
//                cell.downArrowImageView.hidden = NO;
//                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                
//                if ([self.kind isEqualToString:@"1"]) {
//                    cell.txtField.text = @"网内成员";
//                }else if ([self.kind isEqualToString:@"3"]) {
//                    cell.txtField.text = @"网外成员";
//                }else{
//                    cell.txtField.text = @"";
//                }
//                
//                
//                break;
//            }
//            case 3:
//            {
//                
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"请选择";
//                cell.downArrowImageView.hidden = NO;
//                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                
//                if ([self.type isEqualToString:@"1"]) {
//                    cell.txtField.text = @"集团联系人";
//                }else if ([self.type isEqualToString:@"0"]) {
//                    cell.txtField.text = @"集团关键人";
//                }else{
//                    cell.txtField.text = @"";
//                }
//                break;
//            }
//            case 4:
//            {
//                
//                
//                if (detailMuArr.count == 9) {
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    
//                    if (self.job.length > 0) {
//                        cell.txtField.text = self.job;
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 10){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    if (self.name.length > 0) {
//                        cell.txtField.text = self.name;
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                    
//                }else if(detailMuArr.count == 11){
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.MemberLevel isEqualToString:@"2"]) {
//                        cell.txtField.text = @"高层领导/管理层";
//                    }else if ([self.MemberLevel isEqualToString:@"3"]) {
//                        cell.txtField.text = @"中层领导/影响力人物";
//                    }else if ([self.MemberLevel isEqualToString:@"5"]) {
//                        cell.txtField.text = @"最高领导";
//                    }else if ([self.MemberLevel isEqualToString:@"6"]) {
//                        cell.txtField.text = @"通讯部负责人";
//                    }else if ([self.MemberLevel isEqualToString:@"10"]) {
//                        cell.txtField.text = @"信息化部门负责人";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 12){
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    
//                    if ([self.MemberLevel isEqualToString:@"2"]) {
//                        cell.txtField.text = @"高层领导/管理层";
//                    }else if ([self.MemberLevel isEqualToString:@"3"]) {
//                        cell.txtField.text = @"中层领导/影响力人物";
//                    }else if ([self.MemberLevel isEqualToString:@"5"]) {
//                        cell.txtField.text = @"最高领导";
//                    }else if ([self.MemberLevel isEqualToString:@"6"]) {
//                        cell.txtField.text = @"通讯部负责人";
//                    }else if ([self.MemberLevel isEqualToString:@"10"]) {
//                        cell.txtField.text = @"信息化部门负责人";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }
//                break;
//                
//            }
//            case 5:
//            {
//                
//                if (detailMuArr.count == 9) {
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.tel;
//                }else if(detailMuArr.count == 10){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.job;
//                }else if(detailMuArr.count == 11){
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.KernelLevel isEqualToString:@"0"]) {
//                        cell.txtField.text = @"无";
//                    }else if ([self.KernelLevel isEqualToString:@"1"]) {
//                        cell.txtField.text = @"集团1级";
//                    }else if ([self.KernelLevel isEqualToString:@"2"]) {
//                        cell.txtField.text = @"集团2级";
//                    }else if ([self.KernelLevel isEqualToString:@"3"]) {
//                        cell.txtField.text = @"集团3级";
//                    }else if ([self.KernelLevel isEqualToString:@"4"]) {
//                        cell.txtField.text = @"关系A";
//                    }else if ([self.KernelLevel isEqualToString:@"5"]) {
//                        cell.txtField.text = @"关系B";
//                    }else if ([self.KernelLevel isEqualToString:@"6"]) {
//                        cell.txtField.text = @"关系C";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 12){
//                    cell.txtField.placeholder = nil;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.KernelLevel isEqualToString:@"0"]) {
//                        cell.txtField.text = @"无";
//                    }else if ([self.KernelLevel isEqualToString:@"1"]) {
//                        cell.txtField.text = @"集团1级";
//                    }else if ([self.KernelLevel isEqualToString:@"2"]) {
//                        cell.txtField.text = @"集团2级";
//                    }else if ([self.KernelLevel isEqualToString:@"3"]) {
//                        cell.txtField.text = @"集团3级";
//                    }else if ([self.KernelLevel isEqualToString:@"4"]) {
//                        cell.txtField.text = @"关系A";
//                    }else if ([self.KernelLevel isEqualToString:@"5"]) {
//                        cell.txtField.text = @"关系B";
//                    }else if ([self.KernelLevel isEqualToString:@"6"]) {
//                        cell.txtField.text = @"关系C";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }
//                break;
//            }
//            case 6:
//            {
//                if (detailMuArr.count == 9) {
//                    cell.txtField.placeholder = nil;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.IsMain isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMain isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 10){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.tel;
//                }else if(detailMuArr.count == 11){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.job;
//                }else if(detailMuArr.count == 12){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.name;
//                }
//                break;
//            }
//            case 7:
//            {
//                if (detailMuArr.count == 9) {
//                    cell.txtField.placeholder = nil;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                    
//                }else if(detailMuArr.count == 10){
//                    cell.txtField.placeholder = nil;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.IsMain isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMain isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 11){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.tel;
//                }else if(detailMuArr.count == 12){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.job;
//                }
//                
//                break;
//            }
//            case 8:
//            {
//                
//                if (detailMuArr.count == 9) {
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.IsAddMember isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 10){
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 11){
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = @"请选择";
//                    cell.downArrowImageView.hidden = NO;
//                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                    
//                    if ([self.IsMain isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMain isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 12){
//                    cell.downArrowImageView.hidden = YES;
//                    cell.titleLbl.text = title;
//                    cell.txtField.placeholder = nil;
//                    cell.txtField.text = self.tel;
//                }
//                break;
//            }
//            case 9:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"请选择";
//                cell.downArrowImageView.hidden = NO;
//                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                if (detailMuArr.count == 9) {
//                    if ([self.IsMain isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMain isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 10){
//                    if ([self.IsAddMember isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 11){
//                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 12){
//                    if ([self.IsMain isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMain isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                    
//                }
//                break;
//            }
//            case 10:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"请选择";
//                cell.downArrowImageView.hidden = NO;
//                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                
//                if(detailMuArr.count == 11){
//                    if ([self.IsAddMember isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }else if(detailMuArr.count == 12){
//                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
//                        cell.txtField.text = @"是";
//                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
//                        cell.txtField.text = @"否";
//                    }else{
//                        cell.txtField.text = @"";
//                    }
//                }
//                
//                
//                break;
//            }
//            case 11:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = @"请选择";
//                cell.downArrowImageView.hidden = NO;
//                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
//                if ([self.IsAddMember isEqualToString:@"1"]) {
//                    cell.txtField.text = @"是";
//                }else if ([self.IsAddMember isEqualToString:@"0"]) {
//                    cell.txtField.text = @"否";
//                }else{
//                    cell.txtField.text = @"";
//                }
//                break;
//            }
//                
//        }
//    }
//    return cell;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([detailMuArr count] == 9) {
//        switch (textField.tag) {
//            case 4:
//            {
//                self.job = textField.text;
//                break;
//            }
//            case 5:
//            {
//                self.tel = textField.text;
//                break;
//            }
//            default:
//                break;
//        }
//    }else if ([detailMuArr count] == 10) {
//        
//        switch (textField.tag) {
//            case 4:
//            {
//                self.name = textField.text;
//                break;
//            }
//            case 5:
//            {
//                self.job = textField.text;
//                break;
//            }
//            case 6:
//            {
//                self.tel = textField.text;
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }else if ([detailMuArr count] == 11) {
//        switch (textField.tag) {
//            case 6:
//            {
//                self.job = textField.text;
//                break;
//            }
//            case 7:
//            {
//                self.tel = textField.text;
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }else if ([detailMuArr count] == 12) {
//        switch (textField.tag) {
//            case 6:
//            {
//                self.name = textField.text;
//                break;
//            }
//            case 7:
//            {
//                self.job = textField.text;
//                break;
//            }
//            case 8:
//            {
//                self.tel = textField.text;
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }
//    
//    
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    //    NSLog(@"textField.tag=%d",textField.tag);
//    //测试时切勿按tab键 此处有bug 暂未解决
//    
//    if (textField.tag == 0 |
//        textField.tag == 1 ){
//        return NO;
//    }else if (textField.tag == 2){
//        [self.view endEditing:YES];
//        
//        [UIActionSheet showInView:self.view
//                        withTitle:@"成员种类"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"网内成员",@"网外成员"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 [detailMuArr removeObject:@{@"title":@"姓       名：",@"type":@"Text"}];
//                                 if (buttonIndex == 0) {
//                                     self.kind = @"1";
//                                     [detailMuArr removeObject:@{@"title":@"姓       名：",@"type":@"Text"}];
//                                 }else if(buttonIndex == 1){
//                                     self.kind = @"3";
//                                     NSArray *array = @[@{@"title":@"姓       名：",@"type":@"Text"}];
//                                     NSRange range;
//                                     if ([self.type isEqualToString:@"0"]) {
//                                         
//                                         range = NSMakeRange(6, [array count]);
//                                         
//                                     }else{
//                                         range = NSMakeRange(4, [array count]);
//                                         
//                                     }
//                                     NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//                                     [detailMuArr insertObjects:array atIndexes:indexSet];
//                                     
//                                 }
//                                 
//                                 
//                                 
//                                 [_tableView reloadData];
//                             }
//                             
//                         }];
//        
//        return NO;
//    }else if(textField.tag == 3){ //成员类别
//        
//        [self.view endEditing:YES];
//        [UIActionSheet showInView:self.view
//                        withTitle:@"成员类型"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"集团联系人",@"集团关键人"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 [detailMuArr removeObject:@{@"title":@"成员类别：",   @"num":@"8",   @"type":@"Text"}];
//                                 [detailMuArr removeObject:@{@"title":@"人物级别：",   @"num":@"8",   @"type":@"Text"}];
//                                 if (buttonIndex == 0) {
//                                     
//                                     self.type = @"1";
//                                     
//                                 }else if(buttonIndex == 1){
//                                     self.type = @"0";
//                                     NSArray *array = @[
//                                                        @{@"title":@"成员类别：",   @"num":@"8",   @"type":@"Text"},
//                                                        @{@"title":@"人物级别：",   @"num":@"8",   @"type":@"Text"},];
//                                     NSRange range = NSMakeRange(4, [array count]);
//                                     NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//                                     [detailMuArr insertObjects:array atIndexes:indexSet];
//                                     
//                                 }
//                                 
//                                 [_tableView reloadData];
//                             }
//                             
//                         }];
//        
//        return NO;
//    }
//    if (detailMuArr.count == 9) {
//        if (textField.tag == 4 |
//            textField.tag == 5 ){
//            return YES;
//        }
//        if(textField.tag == 6){ //集团单位
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMain = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.IsMain = @"1";
//                                         
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 7){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要联系人"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMainLinkMan = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsMainLinkMan = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 8){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"添加集团成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsAddMember = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsAddMember = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }
//        
//        
//    }else if(detailMuArr.count == 10){
//        
//        if (textField.tag == 4 |
//            textField.tag == 5|
//            textField.tag == 6  ){
//            [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
//            return YES;
//        }
//        if(textField.tag == 7){ //集团单位
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMain = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.IsMain = @"1";
//                                         
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 8){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要联系人"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMainLinkMan = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsMainLinkMan = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 9){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"添加集团成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsAddMember = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsAddMember = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }
//        
//    }else if(detailMuArr.count == 11){
//        
//        if (textField.tag == 6 |
//            textField.tag == 7  ){
//            [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
//            return YES;
//        }
//        
//        if(textField.tag == 4){ //集团单位
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"成员类别"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"高层领导/管理层",@"中层领导/影响力人物",@"最高领导",@"通讯部负责人",@"信息化部门负责人"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.MemberLevel = @"2";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.MemberLevel = @"3";
//                                         
//                                     }else if (buttonIndex == 2) {
//                                         self.MemberLevel = @"5";
//                                         
//                                     }else if(buttonIndex == 3){
//                                         self.MemberLevel = @"6";
//                                         
//                                     }else if(buttonIndex == 4){
//                                         self.MemberLevel = @"10";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            return NO;
//        }else if(textField.tag == 5){ //集团单位
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"人物级别"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"无",@"集团1级",@"集团2级",@"集团3级",@"关系A",@"关系B",@"关系C"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.KernelLevel = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.KernelLevel = @"1";
//                                         
//                                     }else if (buttonIndex == 2) {
//                                         self.KernelLevel = @"2";
//                                         
//                                     }else if(buttonIndex == 3){
//                                         self.KernelLevel = @"3";
//                                         
//                                     }else if(buttonIndex == 4){
//                                         
//                                         self.KernelLevel = @"4";
//                                     }else if(buttonIndex == 5){
//                                         
//                                         self.KernelLevel = @"5";
//                                     }else if(buttonIndex == 6){
//                                         
//                                         self.KernelLevel = @"6";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            return NO;
//        }else if(textField.tag == 8){ //集团单位
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMain = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.IsMain = @"1";
//                                         
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 9){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要联系人"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMainLinkMan = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsMainLinkMan = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 10){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"添加集团成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsAddMember = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsAddMember = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }
//        
//    }else if(detailMuArr.count == 12){
//        if (textField.tag == 6 |
//            textField.tag == 7|
//            textField.tag == 8  ){
//            [self.tableView setContentOffset:CGPointMake(0, 150) animated:YES];
//            return YES;
//        }
//        if(textField.tag == 4){ //集团单位
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"成员类别"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"高层领导/管理层",@"中层领导/影响力人物",@"最高领导",@"通讯部负责人",@"信息化部门负责人"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.MemberLevel = @"2";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.MemberLevel = @"3";
//                                         
//                                     }else if (buttonIndex == 2) {
//                                         self.MemberLevel = @"5";
//                                         
//                                     }else if(buttonIndex == 3){
//                                         self.MemberLevel = @"6";
//                                         
//                                     }else if(buttonIndex == 4){
//                                         self.MemberLevel = @"10";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            return NO;
//        }else if(textField.tag == 5){ //集团单位
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"人物级别"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"无",@"集团1级",@"集团2级",@"集团3级",@"关系A",@"关系B",@"关系C"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.KernelLevel = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.KernelLevel = @"1";
//                                         
//                                     }else if (buttonIndex == 2) {
//                                         self.KernelLevel = @"2";
//                                         
//                                     }else if(buttonIndex == 3){
//                                         self.KernelLevel = @"3";
//                                         
//                                     }else if(buttonIndex == 4){
//                                         
//                                         self.KernelLevel = @"4";
//                                     }else if(buttonIndex == 5){
//                                         
//                                         self.KernelLevel = @"5";
//                                     }else if(buttonIndex == 6){
//                                         
//                                         self.KernelLevel = @"6";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            return NO;
//        }else if(textField.tag == 9){ //集团单位
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMain = @"0";
//                                         
//                                     }else if(buttonIndex == 1){
//                                         self.IsMain = @"1";
//                                         
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 10){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要联系人"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsMainLinkMan = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsMainLinkMan = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }else  if(textField.tag == 11){ //集团单位
//            
//            [self.view endEditing:YES];
//            [UIActionSheet showInView:self.view
//                            withTitle:@"添加集团成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"否",@"是"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     if (buttonIndex == 0) {
//                                         self.IsAddMember = @"0";
//                                     }else if(buttonIndex == 1){
//                                         self.IsAddMember = @"1";
//                                     }
//                                     
//                                     [_tableView reloadData];
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }
//        
//    }
//    return YES;
//}
//
//
//- (void)fininCreate:(id)sender
//{
//    
//    if (self.tel.length == 0) {
//        ALERT_ERR_MSG(@"手机号不能为空");
//        
//        return;
//    }
//    if (self.tel.length != 11) {
//        ALERT_ERR_MSG(@"手机号格式不对");
//        
//        return;
//    }
//    
//    if ([detailMuArr count] == 10 || [detailMuArr count] == 12) {
//        if (self.name.length == 0) {
//            ALERT_ERR_MSG(@"姓名不能为空");
//            
//            return;
//        }
//        
//    }
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    [self doTask];
//    HUD.labelText = @"Loading";
//    
//    //    [HUD showWhileExecuting:@selector(doTask) onTarget:self withObject:nil animated:YES];
//}
//
//
//- (void) doTask
//{
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [self.view endEditing:YES];
//    
//    UserEntity *userEntity = [UserEntity sharedInstance];
//    CommonService *service = [[CommonService alloc] init];
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    [self.view resignFirstResponder];
//    [param setValue:@"client_add_update" forKey:@"method"];
//    [param setValue:self.job?self.job:@"" forKey:@"Job"];
//    [param setValue:@"0" forKey:@"OperType"];
//    [param setValue:self.type forKey:@"PartyRoleId"];
//    [param setValue:userEntity.user_id forKey:@"user_id"];
//    [param setValue:self.compEntity.num forKey:@"GroupId"];
//    [param setValue:self.kind forKey:@"MemberKind"];
//    [param setValue:@"1" forKey:@"c_type"];
//    [param setValue:userEntity.num forKey:@"user_num"];
//    [param setValue:self.tel forKey:@"ServiceNum"];
//    [param setValue:self.name?self.name:@"" forKey:@"CustName"];
//    [param setValue:self.IsMain forKey:@"IsMain"];
//    [param setValue:self.IsMainLinkMan forKey:@"IsMainLinkMan"];
//    [param setValue:self.IsAddMember forKey:@"IsAddMember"];
//    
//    if ([self.type isEqualToString:@"0"]) {
//        [param setValue:self.KernelLevel forKey:@"KernelLevel"];
//        [param setValue:self.MemberLevel forKey:@"MemberLevel"];
//        
//    }else{
//        
//    }
//    [service getNetWorkData:param  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        if ([strState isEqualToString:@"1"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//            }];
//        }
//        else if ([strState isEqualToString:@"-1"] == YES)
//        {
//            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        [HUD hide:YES];
//    } Failed:^(int errorCode, NSString *message) {
//        iToast *toast = [iToast makeText:@"网络连接失败"];
//        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//        [toast setDuration:500];
//        [toast show:iToastTypeNotice];
//        [HUD hide:YES];
//    }];
//}
//
//- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
//{
//    if (isShowNavigationBar) {
//        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//        if (version >= 7.0f) {
//            return self.view.frame.size.height - 64.0f;
//        }
//        else
//            return self.view.frame.size.height - 44.0;
//    }
//    else {
//        return self.view.frame.size.height;
//    }
//}
//
//- (void)backAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//@end



#pragma mark - 首席看管

//
//  ContactAddViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-7.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ContactAddViewController.h"
#import "MBProgressHUD.h"
#import "ExecutorTableViewCell.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "ContactEntity.h"
#import "Utilies.h"
#import "SIAlertView.h"
#import "LineTwoLabelTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "UIAlertView+Blocks.h"
#import "CustomerViewController.h"

@interface ContactAddViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    NSString *level;
    NSMutableArray *detailMuArr;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
}

///集团名称
@property(nonatomic, copy) NSString *compName;
///集团地址
@property(nonatomic, copy) NSString *compAddress;

///成员种类
@property(nonatomic, copy) NSString *kind;
//成员类型
@property(nonatomic, copy) NSString *type;
///成员类别
@property(nonatomic, copy) NSString *MemberLevel;
///关键人物级别
@property(nonatomic, copy) NSString *KernelLevel;
///主要成员
@property(nonatomic, copy) NSString *IsMain;
///主要联系人
@property(nonatomic, copy) NSString *IsMainLinkMan;
///是否添加成员
@property(nonatomic, copy) NSString *IsAddMember;
////集团成员角色
//@property(nonatomic, copy) NSString *PartyRoleId;
///姓名
@property(nonatomic, copy) NSString *name;
///职务
@property(nonatomic, copy) NSString *job;
///电话
@property(nonatomic, copy) NSString *tel;


//性别
@property (strong, nonatomic) NSString *sex;
//年龄
@property (strong, nonatomic) NSString *age;
//地址
@property (strong, nonatomic) NSString *address;
//教育背景
@property (strong, nonatomic) NSString *edu;
//家庭情况
@property (strong, nonatomic) NSString *home;
//爱好
@property (strong, nonatomic) NSString *Hobby;



@end


@implementation ContactAddViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加联系人";
    [self select_logmodel:NSStringFromClass([self class])];
    
//    NSInteger height = [self getBoardHeight:YES];
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
//    //bgImageView.backgroundColor = GrayBackgroundColor;
//    bgImageView.image = [UIImage imageNamed:@"background"];
//    [self.view addSubview:bgImageView];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initData];
    
    self.kind = @"1";
    self.type = @"1";
    self.MemberLevel = @"2";
    self.KernelLevel = @"0";
    self.IsMain = @"1";
    self.IsMainLinkMan = @"1";
    self.IsAddMember = @"1";
}

- (void)initData
{
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
                   @{@"title":@"集团地址：",      @"num":@"1",    @"type":@"Text"},
                   @{@"title":@"成员种类：",      @"num":@"2",    @"type":@"Text"},
                   @{@"title":@"成员类型：",      @"num":@"3",   @"type":@"Text"},
                   @{@"title":@"职       务：",   @"num":@"6",   @"type":@"Text"},
                   @{@"title":@"电       话：",   @"num":@"7",   @"type":@"Text"},
                   @{@"title":@"主要成员：",      @"num":@"7",   @"type":@"Text"},
                   @{@"title":@"主要联系人：",     @"num":@"7",   @"type":@"Text"},
                   @{@"title":@"添加集团成员：",   @"num":@"8",   @"type":@"Text"},
                   
                   @{@"title":@"性       别：",   @"num":@"9",   @"type":@"Text"},
                   @{@"title":@"年       龄：",   @"num":@"9",   @"type":@"Text"},
                   @{@"title":@"住       址：",   @"num":@"9",   @"type":@"Text"},
                   @{@"title":@"教育背景：",      @"num":@"9",   @"type":@"Text"},
                   @{@"title":@"家庭情况：",     @"num":@"9",   @"type":@"Text"},
                   @{@"title":@"爱       好：", @"num":@"9",   @"type":@"Text"},
                   nil];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ContactAddViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ContactAddViewController"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailMuArr count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        CGFloat cellheight;
        cellheight = cell1.subTitleLbl.layer.frame.size.height;
        CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 27;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    cell.txtField.textAlignment = NSTextAlignmentCenter;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    NSString *type = dict[@"type"]; //类型
    
    if ([type isEqualToString:@"Text"]) {
        
        switch (indexPath.row) {
            case 0:
            {
                
                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(!cell1)
                {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell1.titLabel.text = title;
                cell1.subTitleLbl.layer.borderWidth = 0.5;
                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
                cell1.subTitleLbl.layer.cornerRadius = 6;
                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
                if (self.enter_type == 1) {
                    cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.name];
                }else{
                    
                    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCustomerViewController)];
                    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
                    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
                    [cell1.subTitleLbl addGestureRecognizer:singleRecognizer];//添加一个手势监测
                    cell1.subTitleLbl.userInteractionEnabled = YES;
                    
                    cell1.subTitleLbl.text = _compName;
                    
                }
                
                return cell1;
                
                break;
            }
            case 1:
            {
                
                cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(!cell1)
                {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell1.titLabel.text = title;
                cell1.subTitleLbl.layer.borderWidth = 0.5;
                cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
                cell1.subTitleLbl.layer.cornerRadius = 6;
                cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
                
                if (self.enter_type == 1) {
                    cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.address];
                }else{
                    cell1.subTitleLbl.text = _compAddress;
                }
                return cell1;
                break;
            }
            case 2:
            {
                

                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                
                if ([self.kind isEqualToString:@"1"]) {
                    cell.txtField.text = @"网内成员";
                }else if ([self.kind isEqualToString:@"3"]) {
                    cell.txtField.text = @"网外成员";
                }else{
                    cell.txtField.text = @"";
                }
                
            
                break;
            }
            case 3:
            {

                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];

                if ([self.type isEqualToString:@"1"]) {
                    cell.txtField.text = @"集团联系人";
                }else if ([self.type isEqualToString:@"0"]) {
                    cell.txtField.text = @"集团关键人";
                }else{
                    cell.txtField.text = @"";
                }
                break;
            }
            case 4:
            {

               
                if (detailMuArr.count == 15) {
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;

                    if (self.job.length > 0) {
                        cell.txtField.text = self.job;
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 16){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    if (self.name.length > 0) {
                        cell.txtField.text = self.name;
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                }else if(detailMuArr.count == 17){
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.MemberLevel isEqualToString:@"2"]) {
                        cell.txtField.text = @"高层领导/管理层";
                    }else if ([self.MemberLevel isEqualToString:@"3"]) {
                        cell.txtField.text = @"中层领导/影响力人物";
                    }else if ([self.MemberLevel isEqualToString:@"5"]) {
                        cell.txtField.text = @"最高领导";
                    }else if ([self.MemberLevel isEqualToString:@"6"]) {
                        cell.txtField.text = @"通讯部负责人";
                    }else if ([self.MemberLevel isEqualToString:@"10"]) {
                        cell.txtField.text = @"信息化部门负责人";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 18){
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    
                    if ([self.MemberLevel isEqualToString:@"2"]) {
                        cell.txtField.text = @"高层领导/管理层";
                    }else if ([self.MemberLevel isEqualToString:@"3"]) {
                        cell.txtField.text = @"中层领导/影响力人物";
                    }else if ([self.MemberLevel isEqualToString:@"5"]) {
                        cell.txtField.text = @"最高领导";
                    }else if ([self.MemberLevel isEqualToString:@"6"]) {
                        cell.txtField.text = @"通讯部负责人";
                    }else if ([self.MemberLevel isEqualToString:@"10"]) {
                        cell.txtField.text = @"信息化部门负责人";
                    }else{
                        cell.txtField.text = @"";
                    }
                }
                break;
                
            }
            case 5:
            {
               
                if (detailMuArr.count == 15) {
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.tel;
                }else if(detailMuArr.count == 16){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.job;
                }else if(detailMuArr.count == 17){
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.KernelLevel isEqualToString:@"0"]) {
                        cell.txtField.text = @"无";
                    }else if ([self.KernelLevel isEqualToString:@"1"]) {
                        cell.txtField.text = @"集团1级";
                    }else if ([self.KernelLevel isEqualToString:@"2"]) {
                        cell.txtField.text = @"集团2级";
                    }else if ([self.KernelLevel isEqualToString:@"3"]) {
                        cell.txtField.text = @"集团3级";
                    }else if ([self.KernelLevel isEqualToString:@"4"]) {
                        cell.txtField.text = @"关系A";
                    }else if ([self.KernelLevel isEqualToString:@"5"]) {
                        cell.txtField.text = @"关系B";
                    }else if ([self.KernelLevel isEqualToString:@"6"]) {
                        cell.txtField.text = @"关系C";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 18){
                    cell.txtField.placeholder = nil;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.KernelLevel isEqualToString:@"0"]) {
                        cell.txtField.text = @"无";
                    }else if ([self.KernelLevel isEqualToString:@"1"]) {
                        cell.txtField.text = @"集团1级";
                    }else if ([self.KernelLevel isEqualToString:@"2"]) {
                        cell.txtField.text = @"集团2级";
                    }else if ([self.KernelLevel isEqualToString:@"3"]) {
                        cell.txtField.text = @"集团3级";
                    }else if ([self.KernelLevel isEqualToString:@"4"]) {
                        cell.txtField.text = @"关系A";
                    }else if ([self.KernelLevel isEqualToString:@"5"]) {
                        cell.txtField.text = @"关系B";
                    }else if ([self.KernelLevel isEqualToString:@"6"]) {
                        cell.txtField.text = @"关系C";
                    }else{
                        cell.txtField.text = @"";
                    }
                }
                break;
            }
            case 6:
            {
                if (detailMuArr.count == 15) {
                    cell.txtField.placeholder = nil;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.IsMain isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMain isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 16){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.tel;
                }else if(detailMuArr.count == 17){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.job;
                }else if(detailMuArr.count == 18){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.name;
                }
                break;
            }
            case 7:
            {
                if (detailMuArr.count == 15) {
                    cell.txtField.placeholder = nil;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }

                }else if(detailMuArr.count == 16){
                    cell.txtField.placeholder = nil;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.IsMain isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMain isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 17){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.tel;
                }else if(detailMuArr.count == 18){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.job;
                }
                
                break;
            }
            case 8:
            {
                
                if (detailMuArr.count == 15) {
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.IsAddMember isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 16){
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 17){
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = @"请选择";
                    cell.downArrowImageView.hidden = NO;
                    cell.downArrowImageView.image = [UIImage imageNamed:@"right"];

                    if ([self.IsMain isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMain isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }else if(detailMuArr.count == 18){
                    cell.downArrowImageView.hidden = YES;
                    cell.titleLbl.text = title;
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.tel;
                }
                break;
            }
            case 9:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                if (detailMuArr.count == 15) {//性别

                    cell.txtField.text = self.sex;
                    
                }else if(detailMuArr.count == 16){//添加集团成员
                    if ([self.IsAddMember isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                }else if(detailMuArr.count == 17){//主要联系人
                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                }else if(detailMuArr.count == 18){//主要成员
                    if ([self.IsMain isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMain isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                }
                break;
            }
            case 10:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];

                if(detailMuArr.count == 15){//年龄
                    cell.txtField.placeholder = @"";
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.age;
                    
                }else if(detailMuArr.count == 16){//性别

                    cell.txtField.text = self.sex;
                    
                }else if(detailMuArr.count == 17){//是否添加成员
                    if ([self.IsAddMember isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                    
                }else if(detailMuArr.count == 18){///主要联系人
                    if ([self.IsMainLinkMan isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsMainLinkMan isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                }else{
                    
                }
                

                break;
            }
            case 11:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                
                if(detailMuArr.count == 15){//住址
                    cell.txtField.placeholder = @"";
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.address;
                
                }else if(detailMuArr.count == 16){//年龄
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.age;
                    
                }else if(detailMuArr.count == 17){//性别

                    cell.txtField.text = self.sex;
                    
                }else if(detailMuArr.count == 18){///是否添加成员
                    
                    if ([self.IsAddMember isEqualToString:@"1"]) {
                        cell.txtField.text = @"是";
                    }else if ([self.IsAddMember isEqualToString:@"0"]) {
                        cell.txtField.text = @"否";
                    }else{
                        cell.txtField.text = @"";
                    }
                    
                }else{
                    
                }
                

                break;
            }
            case 12:
            {
                
                cell.titleLbl.text = title;
                cell.txtField.placeholder = @"请选择";
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                
                
                if(detailMuArr.count == 15){//教育背景
                    cell.txtField.placeholder = @"";
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.edu;
                    
                }else if(detailMuArr.count == 16){//住址
                    cell.txtField.placeholder = @"";
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.address;
                    
                }else if(detailMuArr.count == 17){//年龄
                    cell.txtField.placeholder = @"";
                    cell.downArrowImageView.hidden = YES;
                    cell.txtField.text = self.age;
                    
                }else if(detailMuArr.count == 18){//性别
                    
                    cell.txtField.text = self.sex;

                }else{
                    
                }
                
                break;
            }
            case 13:
            {
                cell.downArrowImageView.hidden = YES;
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                if (detailMuArr.count == 15) {
                    cell.txtField.text = self.home;
                }else if (detailMuArr.count == 16){
                    cell.txtField.text = self.edu;
                }else if(detailMuArr.count == 17){
                    
                    cell.txtField.text = self.address;
                    
                }else{
                    cell.txtField.text = self.age;
                }
                
                break;
            }
            case 14:
            {
                cell.downArrowImageView.hidden = YES;
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                if (detailMuArr.count == 15) {
                    cell.txtField.text = self.Hobby;
                }else if (detailMuArr.count == 16){
                    cell.txtField.text = self.home;
                }else if(detailMuArr.count == 17){
                    
                    cell.txtField.text = self.edu;
                    
                }else{
                    cell.txtField.text = self.address;
                }
                break;
            }
            case 15:
            {
                cell.downArrowImageView.hidden = YES;
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                if (detailMuArr.count == 16){
                    cell.txtField.text = self.Hobby;
                }else if(detailMuArr.count == 17){
                    
                    cell.txtField.text = self.home;
                    
                }else{
                    cell.txtField.text = self.edu;
                }
                break;
            }
            case 16://家庭情况
            {
                cell.downArrowImageView.hidden = YES;
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                if(detailMuArr.count == 17){
                    
                    cell.txtField.text = self.Hobby;
                    
                }else{
                    cell.txtField.text = self.home;
                }

                break;
            }
            case 17://爱好
            {
                cell.downArrowImageView.hidden = YES;
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.Hobby;
                break;
            }
        
        }
    }
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([detailMuArr count] == 15) {
        switch (textField.tag) {
            case 4:
            {
                self.job = textField.text;
                break;
            }
            case 5:
            {
                self.tel = textField.text;
                break;
            }
            case 10:
            {
                self.age = textField.text;
                break;
            }
            case 11:
            {
                self.address = textField.text;
                break;
            }
            case 12:
            {
                self.edu = textField.text;
                break;
            }
            case 13:
            {
                self.home = textField.text;
                break;
            }
            case 14:
            {
                self.Hobby = textField.text;
                break;
            }
            default:
                break;
        }
    }else if ([detailMuArr count] == 16) {

        switch (textField.tag) {
            case 4:
            {
                self.name = textField.text;
                break;
            }
            case 5:
            {
                self.job = textField.text;
                break;
            }
            case 6:
            {
                self.tel = textField.text;
                break;
            }
            case 11:
            {
                self.age = textField.text;
                break;
            }
            case 12:
            {
                self.address = textField.text;
                break;
            }
            case 13:
            {
                self.edu = textField.text;
                break;
            }
            case 14:
            {
                self.home = textField.text;
                break;
            }
            case 15:
            {
                self.Hobby = textField.text;
                break;
            }
            default:
                break;
        }

    }else if ([detailMuArr count] == 17) {
        switch (textField.tag) {
            case 6:
            {
                self.job = textField.text;
                break;
            }
            case 7:
            {
                self.tel = textField.text;
                break;
            }
            case 12:
            {
                self.age = textField.text;
                break;
            }
            case 13:
            {
                self.address = textField.text;
                break;
            }
            case 14:
            {
                self.edu = textField.text;
                break;
            }
            case 15:
            {
                self.home = textField.text;
                break;
            }
            case 16:
            {
                self.Hobby = textField.text;
                break;
            }
            default:
                break;
        }
        
    }else if ([detailMuArr count] == 18) {
        switch (textField.tag) {
            case 6:
            {
                self.name = textField.text;
                break;
            }
            case 7:
            {
                self.job = textField.text;
                break;
            }
            case 8:
            {
                self.tel = textField.text;
                break;
            }
            case 13:
            {
                self.age = textField.text;
                break;
            }
            case 14:
            {
                self.address = textField.text;
                break;
            }
            case 15:
            {
                self.edu = textField.text;
                break;
            }
            case 16:
            {
                self.home = textField.text;
                break;
            }
            case 17:
            {
                self.Hobby = textField.text;
                break;
            }
            default:
                break;
        }
        
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == 0 |
        textField.tag == 1 ){
        return NO;
    }else if (textField.tag == 2){
        [self.view endEditing:YES];

        [UIActionSheet showInView:self.view
                        withTitle:@"成员种类"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"网内成员",@"网外成员"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 [detailMuArr removeObject:@{@"title":@"姓       名：",@"type":@"Text"}];
                                 if (buttonIndex == 0) {
                                     self.kind = @"1";
                                     [detailMuArr removeObject:@{@"title":@"姓       名：",@"type":@"Text"}];
                                 }else if(buttonIndex == 1){
                                     self.kind = @"3";
                                     NSArray *array = @[@{@"title":@"姓       名：",@"type":@"Text"}];
                                     NSRange range;
                                     if ([self.type isEqualToString:@"0"]) {
                                         
                                        range = NSMakeRange(6, [array count]);
                                       
                                     }else{
                                         range = NSMakeRange(4, [array count]);
                                        
                                     }
                                     NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                     [detailMuArr insertObjects:array atIndexes:indexSet];
                                     
                                 }

                            

                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    }else if(textField.tag == 3){ //成员类别
        
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"成员类型"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"集团联系人",@"集团关键人"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {

                                     [detailMuArr removeObject:@{@"title":@"成员类别：",   @"num":@"8",   @"type":@"Text"}];
                                     [detailMuArr removeObject:@{@"title":@"人物级别：",   @"num":@"8",   @"type":@"Text"}];
                                     if (buttonIndex == 0) {
                                         
                                         self.type = @"1";
                                         
                                     }else if(buttonIndex == 1){
                                         self.type = @"0";
                                         NSArray *array = @[
                                                            @{@"title":@"成员类别：",   @"num":@"8",   @"type":@"Text"},
                                                            @{@"title":@"人物级别：",   @"num":@"8",   @"type":@"Text"},];
                                         NSRange range = NSMakeRange(4, [array count]);
                                         NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                         [detailMuArr insertObjects:array atIndexes:indexSet];
                                         
                                     }
    
                                     [_tableView reloadData];
                                 }
    
                             }];
    
            return NO;
        }
    if (detailMuArr.count == 15) {
        if (textField.tag == 4 |
            textField.tag == 5 ){
            return YES;
        }
        if(textField.tag == 6){ //集团单位
            [self.view endEditing:YES];
                [UIActionSheet showInView:self.view
                                withTitle:@"主要成员"
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@[@"否",@"是"]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex != actionSheet.cancelButtonIndex) {
                                         
                                         if (buttonIndex == 0) {
                                             self.IsMain = @"0";
                                             
                                         }else if(buttonIndex == 1){
                                             self.IsMain = @"1";
                                             
                                         }
                                         
                                         [_tableView reloadData];
                                     }
                                     
                        }];
      
            return NO;
        }else  if(textField.tag == 7){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要联系人"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMainLinkMan = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsMainLinkMan = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 8){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"添加集团成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsAddMember = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsAddMember = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 9){ //性别
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"性别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"男",@"女"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.sex = @"男";
                                     }else if(buttonIndex == 1){
                                         self.sex = @"女";
                                     }
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }
        
        
    }else if(detailMuArr.count == 16){
        
        if (textField.tag == 4 |
            textField.tag == 5|
            textField.tag == 6  ){
            [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
            return YES;
        }
        if(textField.tag == 7){ //集团单位
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMain = @"0";
                                         
                                     }else if(buttonIndex == 1){
                                         self.IsMain = @"1";
                                         
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 8){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要联系人"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMainLinkMan = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsMainLinkMan = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 9){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"添加集团成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsAddMember = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsAddMember = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 10){ //性别
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"性别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"男",@"女"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.sex = @"男";
                                     }else if(buttonIndex == 1){
                                         self.sex = @"女";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }
        
    }else if(detailMuArr.count == 17){
        
        if (textField.tag == 6 |
            textField.tag == 7  ){
            [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
            return YES;
        }
        
        if(textField.tag == 4){ //集团单位
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"成员类别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"高层领导/管理层",@"中层领导/影响力人物",@"最高领导",@"通讯部负责人",@"信息化部门负责人"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.MemberLevel = @"2";
                                         
                                     }else if(buttonIndex == 1){
                                         self.MemberLevel = @"3";
                                         
                                     }else if (buttonIndex == 2) {
                                         self.MemberLevel = @"5";
                                         
                                     }else if(buttonIndex == 3){
                                         self.MemberLevel = @"6";
                                         
                                     }else if(buttonIndex == 4){
                                         self.MemberLevel = @"10";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            return NO;
        }else if(textField.tag == 5){ //集团单位
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"人物级别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"无",@"集团1级",@"集团2级",@"集团3级",@"关系A",@"关系B",@"关系C"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.KernelLevel = @"0";
                                         
                                     }else if(buttonIndex == 1){
                                         self.KernelLevel = @"1";
                                         
                                     }else if (buttonIndex == 2) {
                                         self.KernelLevel = @"2";
                                         
                                     }else if(buttonIndex == 3){
                                         self.KernelLevel = @"3";
                                         
                                     }else if(buttonIndex == 4){
                                         
                                         self.KernelLevel = @"4";
                                     }else if(buttonIndex == 5){
                                         
                                         self.KernelLevel = @"5";
                                     }else if(buttonIndex == 6){
                                         
                                         self.KernelLevel = @"6";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            return NO;
        }else if(textField.tag == 8){ //集团单位
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMain = @"0";
                                         
                                     }else if(buttonIndex == 1){
                                         self.IsMain = @"1";
                                         
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 9){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要联系人"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMainLinkMan = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsMainLinkMan = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 10){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"添加集团成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsAddMember = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsAddMember = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 11){ //性别
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"性别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"男",@"女"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.sex = @"男";
                                     }else if(buttonIndex == 1){
                                         self.sex = @"女";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }
        
    }else if(detailMuArr.count == 18){
        if (textField.tag == 6 |
            textField.tag == 7|
            textField.tag == 8  ){
            [self.tableView setContentOffset:CGPointMake(0, 150) animated:YES];
            return YES;
        }
        if(textField.tag == 4){ //集团单位
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"成员类别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"高层领导/管理层",@"中层领导/影响力人物",@"最高领导",@"通讯部负责人",@"信息化部门负责人"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.MemberLevel = @"2";
                                         
                                     }else if(buttonIndex == 1){
                                         self.MemberLevel = @"3";
                                         
                                     }else if (buttonIndex == 2) {
                                         self.MemberLevel = @"5";
                                         
                                     }else if(buttonIndex == 3){
                                         self.MemberLevel = @"6";
                                         
                                     }else if(buttonIndex == 4){
                                         self.MemberLevel = @"10";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            return NO;
        }else if(textField.tag == 5){ //集团单位
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"人物级别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"无",@"集团1级",@"集团2级",@"集团3级",@"关系A",@"关系B",@"关系C"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.KernelLevel = @"0";
                                         
                                     }else if(buttonIndex == 1){
                                         self.KernelLevel = @"1";
                                         
                                     }else if (buttonIndex == 2) {
                                         self.KernelLevel = @"2";
                                         
                                     }else if(buttonIndex == 3){
                                         self.KernelLevel = @"3";
                                         
                                     }else if(buttonIndex == 4){
                                         
                                         self.KernelLevel = @"4";
                                     }else if(buttonIndex == 5){
                                         
                                         self.KernelLevel = @"5";
                                     }else if(buttonIndex == 6){
                                         
                                         self.KernelLevel = @"6";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            return NO;
        }else if(textField.tag == 9){ //集团单位
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMain = @"0";
                                         
                                     }else if(buttonIndex == 1){
                                         self.IsMain = @"1";
                                         
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 10){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"主要联系人"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsMainLinkMan = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsMainLinkMan = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 11){ //集团单位
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"添加集团成员"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"否",@"是"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.IsAddMember = @"0";
                                     }else if(buttonIndex == 1){
                                         self.IsAddMember = @"1";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }else  if(textField.tag == 12){ //性别
            
            [self.view endEditing:YES];
            [UIActionSheet showInView:self.view
                            withTitle:@"性别"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"男",@"女"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.sex = @"男";
                                     }else if(buttonIndex == 1){
                                         self.sex = @"女";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;
        }
        
    }
    return YES;
}


- (void)fininCreate:(id)sender
{

    if (self.tel.length == 0) {
        ALERT_ERR_MSG(@"手机号不能为空");
        
        return;
    }
    if (self.tel.length != 11) {
        ALERT_ERR_MSG(@"手机号格式不对");
        
        return;
    }
    
    if ([detailMuArr count] == 16 || [detailMuArr count] == 18) {
        if (self.name.length == 0) {
            ALERT_ERR_MSG(@"姓名不能为空");
            
            return;
        }

    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    HUD.labelText = @"Loading";
    
//    [HUD showWhileExecuting:@selector(doTask) onTarget:self withObject:nil animated:YES];
}


- (void) doTask
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [self.view resignFirstResponder];
    [param setValue:@"client_add_update" forKey:@"method"];
    [param setValue:self.job?self.job:@"" forKey:@"Job"];
    [param setValue:@"0" forKey:@"OperType"];
    [param setValue:self.type forKey:@"PartyRoleId"];
    [param setValue:userEntity.user_id forKey:@"user_id"];
    [param setValue:self.compEntity.num forKey:@"GroupId"];
    [param setValue:self.kind forKey:@"MemberKind"];
    [param setValue:@"1" forKey:@"c_type"];
    [param setValue:userEntity.num forKey:@"user_num"];
    [param setValue:self.tel forKey:@"ServiceNum"];
    [param setValue:self.name?self.name:@"" forKey:@"CustName"];
    [param setValue:self.IsMain forKey:@"IsMain"];
    [param setValue:self.IsMainLinkMan forKey:@"IsMainLinkMan"];
    [param setValue:self.IsAddMember forKey:@"IsAddMember"];
    
    if ([self.type isEqualToString:@"0"]) {
        [param setValue:self.KernelLevel forKey:@"KernelLevel"];
        [param setValue:self.MemberLevel forKey:@"MemberLevel"];
        
    }else{
        
    }
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"] == YES) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
            [self add_Other_Data];
            
        }
        else if ([strState isEqualToString:@"-1"] == YES)
        {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
        [HUD hide:YES];
    }];
}

//- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
//{
//    if (isShowNavigationBar) {
//        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//        if (version >= 7.0f) {
//            return self.view.frame.size.height - 64.0f;
//        }
//        else
//            return self.view.frame.size.height - 44.0;
//    }
//    else {
//        return self.view.frame.size.height;
//    }
//}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)goCustomerViewController{
    
    CustomerViewController *vc = [[CustomerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.addCusVC = self;
    vc.enter_type = 4;

}

- (void) setCustomerValue:(CompEntity *)ex
{
    _compEntity = ex;
    
    _compAddress = _compEntity.address;
    _compName = _compEntity.name;
    
    [self.tableView reloadData];
    
    //    textFieldCustomer.text = compEntity.name;
}

- (void)add_Other_Data{
    
    CommonService *service = [[CommonService alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [self.view resignFirstResponder];
    [param setValue:@"add_update_client_addition_info" forKey:@"method"];
    [param setValue:self.compEntity.num forKey:@"company_num"];
    [param setValue:self.tel forKey:@"tel"];
    
    [param setValue:self.sex forKey:@"cl_sex"];
    [param setValue:self.age forKey:@"cl_age"];
    [param setValue:self.address forKey:@"cl_address"];
    [param setValue:self.edu forKey:@"cl_edu"];
    [param setValue:self.home forKey:@"cl_home"];
    [param setValue:self.Hobby forKey:@"cl_hobby"];

    [service getNetWorkData:param  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        if ([strState isEqualToString:@"1"] == YES) {
//            
//        }
 
    } Failed:^(int errorCode, NSString *message) {

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
