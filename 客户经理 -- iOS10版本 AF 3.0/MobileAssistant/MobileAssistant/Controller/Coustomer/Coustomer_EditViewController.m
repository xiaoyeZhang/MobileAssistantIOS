
////
////  Coustomer_EditViewController.m
////  MobileAssistant
////
////  Created by 张晓烨 on 16/1/20.
////  Copyright © 2016年 avatek. All rights reserved.
////
//
//#import "Coustomer_EditViewController.h"
//#import "LineTwoLabelTableViewCell.h"
//#import "TxtFieldTableViewCell.h"
//#import "UIActionSheet+Block.h"
//#import "CommonService.h"
//#import "MBProgressHUD.h"
//#import "UserEntity.h"
//#import "UIColor+Hex.h"
//#import "UIAlertView+Blocks.h"
//
//@interface Coustomer_EditViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
//{
//    NSMutableArray *detailMuArr;
//    TxtFieldTableViewCell *cell;
//    LineTwoLabelTableViewCell *cell1;
//    MBProgressHUD *HUD;
//}
//@end
//
//@implementation Coustomer_EditViewController
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self select_logmodel:NSStringFromClass([self class])];
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
//    UIButton *saveButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [saveButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
//    [saveButton setTitle:@"提交" forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
//    self.navigationItem.rightBarButtonItem = saveButtonItem;
//    [self initData];
//    [self setData];
//    self.title = @"修改联系人";
//}
//
//- (void)setData{
//    
//    if (self.entity) {
//        
//        if (self.entity.MemberKind.intValue == 1) {
//            self.kind = @"网内成员";
//        }else if (self.entity.MemberKind.intValue == 3) {
//            self.kind = @"网外成员";
//        }
//        if (self.entity.MemberLevel.intValue == 9) {
//            self.type = @"集团联系人";
//        }else{
//            self.type = @"集团关键人";
//        }
//        self.IsAddMember = @"1";
//        self.num = self.entity.MemUserId;
//        self.name = self.entity.name;
//        self.tel = self.entity.tel;
//        self.job = self.entity.job;
//    }
//    
//    
//}
//
//- (void)initData
//{
//    
//    detailMuArr = [[NSMutableArray alloc] initWithObjects:
//                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
//                   @{@"title":@"集团地址：",      @"num":@"1",    @"type":@"Text"},
//                   @{@"title":@"成员种类：",      @"num":@"2",    @"type":@"Text"},
//                   @{@"title":@"成员类型：",      @"num":@"3",   @"type":@"Text"},
//                   @{@"title":@"工       号：",   @"num":@"5",   @"type":@"Text"},
//                   @{@"title":@"姓       名：",   @"num":@"6",   @"type":@"Text"},
//                   @{@"title":@"职       务：",   @"num":@"7",   @"type":@"Text"},
//                   @{@"title":@"电       话：",   @"num":@"8",   @"type":@"Text"},
//                   @{@"title":@"同步集团成员：",   @"num":@"9",   @"type":@"Text"},
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
//        //        cell.downArrowImageView.image = [UIImage imageNamed:@"c_down"];
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
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.kind;
//                break;
//            }
//            case 3:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.type;
//                
//                break;
//            }
//            case 4:
//            {
//                
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.num;
//                break;
//            }
//            case 5:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.placeholder = nil;
//                cell.txtField.text = self.name;
//                //                if (self.entity.MemberKind.intValue == 3) {
//                //                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                //                }else{
//                //
//                //                }
//                break;
//            }
//            case 6:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.job;
//                
//                cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                
//                break;
//            }
//            case 7:
//            {
//                cell.titleLbl.text = title;
//                cell.txtField.text = self.tel;
//                break;
//            }
//            case 8:
//            {
//                cell.titleLbl.text = title;
//                if ([self.IsAddMember isEqualToString:@"0"]) {
//                    cell.txtField.text = @"否";
//                }else if ([self.IsAddMember isEqualToString:@"1"]) {
//                    cell.txtField.text = @"是";
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
//    
//    switch (textField.tag) {
//            //        case 5:
//            //        {
//            //            self.name = textField.text;
//            //            break;
//            //        }
//        case 6:
//        {
//            self.job = textField.text;
//            break;
//        }
//        default:
//            break;
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
//        textField.tag == 1 |
//        textField.tag == 2 |
//        textField.tag == 3 |
//        textField.tag == 4 |
//        textField.tag == 5 |
//        textField.tag == 7 |
//        textField.tag == 8){
//        return NO;
//        //    }else if (textField.tag == 5){
//        //        if (self.entity.MemberKind.intValue == 1) {
//        //            return NO;
//        //        }else if (self.entity.MemberKind.intValue == 3) {
//        //            [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
//        //            return YES;
//        //        }
//    }else if (textField.tag == 6){
//        [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
//    }
//    //    else if (textField.tag == 8){
//    //
//    //        [self.view endEditing:YES];
//    //        [UIActionSheet showInView:self.view
//    //                        withTitle:@"同步集团成员"
//    //                cancelButtonTitle:@"取消"
//    //           destructiveButtonTitle:nil
//    //                otherButtonTitles:@[@"否",@"是"]
//    //                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//    //                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//    //
//    //                                 if (buttonIndex == 0) {
//    //                                     self.IsAddMember = @"0";
//    //
//    //                                 }else if(buttonIndex == 1){
//    //                                     self.IsAddMember = @"1";
//    //
//    //                                 }
//    //
//    //                                 [_tableView reloadData];
//    //                             }
//    //
//    //                         }];
//    //
//    //        return NO;
//    //    }
//    return YES;
//}
//
//- (void)fininCreate:(id)sender
//{
//    if (self.name.length == 0) {
//        ALERT_ERR_MSG(@"姓名不能为空");
//        
//        return;
//    }
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    [self doTask];
//    
//}
//
//
//- (void) doTask
//{
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [self.view endEditing:YES];
//    
//    UserEntity *userEntity = [UserEntity sharedInstance];
//    
//    CommonService *service = [[CommonService alloc] init];
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    
//    [param setValue:@"client_add_update" forKey:@"method"];
//    [param setValue:self.job?self.job:@"" forKey:@"Job"];
//    [param setValue:@"1" forKey:@"OperType"];
//    [param setValue:self.entity.MemUserId forKey:@"MemUserId"];
//    [param setValue:self.entity.MemberType forKey:@"PartyRoleId"];
//    [param setValue:userEntity.user_id forKey:@"user_id"];
//    [param setValue:self.entity.GroupId forKey:@"GroupId"];
//    [param setValue:self.entity.MemberKind forKey:@"MemberKind"];
//    [param setValue:@"1" forKey:@"c_type"];
//    [param setValue:userEntity.num forKey:@"user_num"];
//    [param setValue:self.name forKey:@"CustName"];
//    [param setValue:self.entity.tel forKey:@"ServiceNum"];
//    [param setValue:self.IsAddMember forKey:@"IsAddMember"];
//    
//    [service getNetWorkData:param  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        if ([strState isEqualToString:@"1"] == YES) {
//            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//            }];
//        }
//        else
//        {
//            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }
//        [HUD hide:YES];
//    } Failed:^(int errorCode, NSString *message) {
//        [HUD hide:YES];
//        iToast *toast = [iToast makeText:@"网络连接失败"];
//        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
//        [toast setDuration:500];
//        [toast show:iToastTypeNotice];
//    }];
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
//  Coustomer_EditViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Coustomer_EditViewController.h"
#import "LineTwoLabelTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "UserEntity.h"
#import "UIColor+Hex.h"
#import "UIAlertView+Blocks.h"

@interface Coustomer_EditViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *detailMuArr;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
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

@implementation Coustomer_EditViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
    
    userEntity = [UserEntity sharedInstance];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([userEntity.is_first isEqual:@"1"]) {
        
        self.navigationItem.title = @"查看联系人";
        
    }else{
        
        self.navigationItem.title = @"修改联系人";
        
        UIButton *saveButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [saveButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"提交" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        self.navigationItem.rightBarButtonItem = saveButtonItem;

    }
    
    [self initData];
    [self getData];
    [self setData];
    
}

- (void)setData{
    
    if (self.entity) {

        if (self.entity.MemberKind.intValue == 1) {
            self.kind = @"网内成员";
        }else if (self.entity.MemberKind.intValue == 3) {
            self.kind = @"网外成员";
        }
        if (self.entity.MemberLevel.intValue == 9) {
            self.type = @"集团联系人";
        }else{
            self.type = @"集团关键人";
        }
        self.IsAddMember = @"1";
        self.num = self.entity.MemUserId;
        self.name = self.entity.name;
        self.tel = self.entity.tel;
        self.job = self.entity.job;
        
    }
    _sex = self.entity.Gender;
    _age = @"待填写";//@"49";
    _address = @"待填写";//@"贵阳市云岩区保利温泉E区";
    _edu = @"待填写";//@"大学本科";
    _home = @"待填写";
    _Hobby = @"待填写";
    
}

- (void)initData
{

    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"集团名称：",      @"num":@"0",    @"type":@"Text"},
                   @{@"title":@"集团地址：",      @"num":@"1",    @"type":@"Text"},
                   @{@"title":@"成员种类：",      @"num":@"2",    @"type":@"Text"},
                   @{@"title":@"成员类型：",      @"num":@"3",   @"type":@"Text"},
                   @{@"title":@"工       号：",   @"num":@"5",   @"type":@"Text"},
                   @{@"title":@"姓       名：",   @"num":@"6",   @"type":@"Text"},
                   @{@"title":@"职       务：",   @"num":@"7",   @"type":@"Text"},
                   @{@"title":@"电       话：",   @"num":@"8",   @"type":@"Text"},
                   @{@"title":@"同步集团成员：",   @"num":@"9",   @"type":@"Text"},
                   
                   @{@"title":@"性       别 ：",  @"num":@"10",   @"type":@"Text"},
                   @{@"title":@"年       龄 ：",@"num":@"11",   @"type":@"Text"},
                   @{@"title":@"住       址 ：",@"num":@"12",   @"type":@"Text"},
                   @{@"title":@"教育背景：",    @"num":@"13",   @"type":@"Text"},
                   @{@"title":@"家庭情况：",    @"num":@"14",   @"type":@"Text"},
                   @{@"title":@"爱       好 ：",@"num":@"15",   @"type":@"Text"},
                   
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
        return size.height + 35;
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
    
    cell.titleLbl.textColor = RGBA(0, 0, 0, 1);
    
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    NSString *title = dict[@"title"];
    
    NSString *type = dict[@"type"]; //类型
    
    if ([type isEqualToString:@"Text"]) {
        //        cell.downArrowImageView.image = [UIImage imageNamed:@"c_down"];
        
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
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.name];
                cell1.subTitleLbl.textColor = [UIColor darkGrayColor];
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
                cell1.subTitleLbl.text = [NSString stringWithFormat:@"  %@",self.compEntity.address];
                cell1.subTitleLbl.textColor = [UIColor darkGrayColor];
                
                return cell1;
                break;
            }
            case 2:
            {

                cell.titleLbl.text = title;
                cell.txtField.text = self.kind;
                cell.txtField.textColor = [UIColor darkGrayColor];
                break;
            }
            case 3:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = self.type;
                cell.txtField.textColor = [UIColor darkGrayColor];
                break;
            }
            case 4:
            {

                cell.titleLbl.text = title;
                cell.txtField.text = self.num;
                cell.txtField.textColor = [UIColor darkGrayColor];
                break;
            }
            case 5:
            {
                cell.titleLbl.text = title;
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.name;
                cell.txtField.textColor = [UIColor darkGrayColor];
//                if (self.entity.MemberKind.intValue == 3) {
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }else{
//                    
//                }
                break;
            }
            case 6:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = self.job;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }


                break;
            }
            case 7:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = self.tel;
                cell.txtField.textColor = [UIColor darkGrayColor];
                break;
            }
            case 8:
            {
                cell.titleLbl.text = title;
                if ([self.IsAddMember isEqualToString:@"0"]) {
                    cell.txtField.text = @"否";
                }else if ([self.IsAddMember isEqualToString:@"1"]) {
                    cell.txtField.text = @"是";
                }
                cell.txtField.textColor = [UIColor darkGrayColor];
                
                break;
            }
            case 9:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _sex;
                cell.downArrowImageView.hidden = NO;
                cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
                
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
            case 10:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _age;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
            case 11:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _address;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
            case 12:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _edu;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
            case 13:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _home;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
            case 14:
            {
                cell.titleLbl.text = title;
                cell.txtField.text = _Hobby;
                cell.txtField.textColor = [UIColor blackColor];
//                if ([userEntity.is_first isEqual:@"1"]) {
//                    
//                }else{
//                    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#0099CC"];
//                }
                break;
            }
                
                
        }
    }
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    switch (textField.tag) {
//        case 5:
//        {
//            self.name = textField.text;
//            break;
//        }
        case 6:
        {
            self.job = textField.text;
            break;
        }
        case 9:
            
            _sex = textField.text;
            
            break;
        case 10:
            
            _age = textField.text;
            
            break;
        case 11:
            
            _address = textField.text;
            
            break;
        case 12:
            
            _edu = textField.text;
            
            break;
        case 13:
            
            _home = textField.text;
            
            break;
        case 14:
            
            _Hobby = textField.text;
            
            break;
            
        default:
            break;
    }

    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    if ([userEntity.is_first isEqual:@"1"]) {
        
        return NO;
    }
    
    if (textField.tag == 0 |
        textField.tag == 1 |
        textField.tag == 2 |
        textField.tag == 3 |
        textField.tag == 4 |
        textField.tag == 5 |
        textField.tag == 7 |
        textField.tag == 8){
        return NO;
//    }else if (textField.tag == 5){
//        if (self.entity.MemberKind.intValue == 1) {
//            return NO;
//        }else if (self.entity.MemberKind.intValue == 3) {
//            [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
//            return YES;
//        }
    }else if (textField.tag == 6){
//        [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
    }else if (textField.tag == 9){
    

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

//    else if (textField.tag == 8){
//
//        [self.view endEditing:YES];
//        [UIActionSheet showInView:self.view
//                        withTitle:@"同步集团成员"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"否",@"是"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 if (buttonIndex == 0) {
//                                     self.IsAddMember = @"0";
//
//                                 }else if(buttonIndex == 1){
//                                     self.IsAddMember = @"1";
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
    return YES;
}

- (void)fininCreate:(id)sender
{
    if (self.name.length == 0) {
        ALERT_ERR_MSG(@"姓名不能为空");
        
        return;
    }

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];

}


- (void) doTask
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];

    CommonService *service = [[CommonService alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:@"client_add_update" forKey:@"method"];
    [param setValue:self.job?self.job:@"" forKey:@"Job"];
    [param setValue:@"1" forKey:@"OperType"];
    [param setValue:self.entity.MemUserId forKey:@"MemUserId"];
    [param setValue:self.entity.MemberType forKey:@"PartyRoleId"];
    [param setValue:userEntity.user_id forKey:@"user_id"];
    [param setValue:self.entity.GroupId forKey:@"GroupId"];
    [param setValue:self.entity.MemberKind forKey:@"MemberKind"];
    [param setValue:@"1" forKey:@"c_type"];
    [param setValue:userEntity.num forKey:@"user_num"];
    [param setValue:self.name forKey:@"CustName"];
    [param setValue:self.entity.tel forKey:@"ServiceNum"];
    [param setValue:self.IsAddMember forKey:@"IsAddMember"];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"] == YES) {
            
            [self submitBtnClicked];
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
 
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }
        else
        {

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}

//获取联系人的附加信息
- (void)getData{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"get_client_addition_info",
                            @"tel":self.entity.tel,
                            @"company_num":self.compEntity.num
                            };
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSDictionary *dic = [entity objectForKey:@"content"];
            
            self.sex = [dic objectForKey:@"cl_sex"];
            self.age = [dic objectForKey:@"cl_age"];
            self.address = [dic objectForKey:@"cl_address"];
            self.edu = [dic objectForKey:@"cl_edu"];
            self.home = [dic objectForKey:@"cl_home"];
            self.Hobby = [dic objectForKey:@"cl_hobby"];
            
            [self initData];
        }
        else
        {
            
        }
        
        //        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        //        [HUD hide:YES];
    }];
    
    
}

//提交附加信息
- (void)submitBtnClicked
{
    [self.view endEditing:YES];
    
    CommonService *service = [[CommonService alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    
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
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"1"] == YES) {
            
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
    
}

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
