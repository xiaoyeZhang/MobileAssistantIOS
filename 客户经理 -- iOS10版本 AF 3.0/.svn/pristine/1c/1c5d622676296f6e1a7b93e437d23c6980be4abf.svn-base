//
//  New_Contacts_MessageViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "New_Contacts_MessageViewController.h"
#import "TxtFieldTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "UserEntity.h"

@interface New_Contacts_MessageViewController ()<UITextFieldDelegate>
{
    UserEntity *userEntity;
    NSArray *dicArr;
    TxtFieldTableViewCell *cell;
}
//姓名
@property (strong, nonatomic) NSString *Name;
//性别
@property (strong, nonatomic) NSString *sex;
//年龄
@property (strong, nonatomic) NSString *age;
//联系电话
@property (strong, nonatomic) NSString *tel;
//职位
@property (strong, nonatomic) NSString *job;
//地址
@property (strong, nonatomic) NSString *address;
//教育背景
@property (strong, nonatomic) NSString *edu;
//家庭情况
@property (strong, nonatomic) NSString *home;
//爱好
@property (strong, nonatomic) NSString *Hobby;
//成员类型
@property (strong, nonatomic) NSString *type;
//主要成员
//@property (strong, nonatomic) NSString *main;

@end

@implementation New_Contacts_MessageViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([userEntity.type_id isEqualToString:@"0"]) {
        
        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"保存"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _Name = self.entity.name;
    _sex = self.entity.Gender;
    _age = @"待填写";//@"49";
    _tel = self.entity.tel;
    _job = self.entity.job;
    _address = @"待填写";//@"贵阳市云岩区保利温泉E区";
    _edu = @"待填写";//@"大学本科";
    _home = @"待填写";
    _Hobby = @"待填写";

    if (self.entity.MemberLevel.intValue == 9) {
        self.type = @"集团联系人";
    }else{
        self.type = @"集团关键人";
    }
    
//    _main = @"是";
    
    [self getData];
    
    [self initData];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
- (void)submitBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    
    CommonService *service = [[CommonService alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    
    [param setValue:@"add_update_client_addition_info" forKey:@"method"];
    [param setValue:self.company_num forKey:@"company_num"];
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

- (void)initData{
    
    dicArr= @[@{@"title":@"姓      名 ：",@"type":@"0",@"message":_Name},
              @{@"title":@"性      别 ：",@"type":@"0",@"message":_sex},
              @{@"title":@"年      龄 ：",@"type":@"0",@"message":_age},
              @{@"title":@"联系电话：",    @"type":@"0",@"message":_tel},
              @{@"title":@"公司职位：",    @"type":@"0",@"message":_job},
              @{@"title":@"住      址 ：",@"type":@"0",@"message":_address},
              @{@"title":@"教育背景：",    @"type":@"0",@"message":_edu},
              @{@"title":@"家庭情况：",    @"type":@"0",@"message":_home},
              @{@"title":@"爱      好 ：",@"type":@"0",@"message":_Hobby},
              @{@"title":@"成员类型：",    @"type":@"1",@"message":_type},
//              @{@"title":@"主要成员：",    @"type":@"1",@"message":_main}
              ];

    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dicArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.txtField.tag = indexPath.row;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.titleLbl.text = dicArr[indexPath.row][@"title"];
    cell.txtField.text = dicArr[indexPath.row][@"message"];
    
    if ([dicArr[indexPath.row][@"type"] isEqualToString:@"1"]) {
        cell.txtField.placeholder = @"请选择";
        cell.downArrowImageView.hidden = NO;
        cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
    }else{
        cell.txtField.placeholder = @"";
        cell.downArrowImageView.hidden = YES;
    }
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            
            _Name = textField.text;
            
            break;
        case 1:
            
            _sex = textField.text;
            
            break;
        case 2:
            
            _age = textField.text;
            
            break;
        case 3:
            
            _tel = textField.text;
            
            break;
        case 4:
            
            _job = textField.text;
            
            break;
        case 5:
            
            _address = textField.text;
            
            break;
        case 6:
            
            _edu = textField.text;
            
            break;
        case 7:
            
            _home = textField.text;
            
            break;
        case 8:
            
            _Hobby = textField.text;
            
            break;
            
        default:
            break;
    }
    
    [self initData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (![userEntity.type_id isEqualToString:@"0"]) {
        
        return NO;
        
    }else{
        
        if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] && [dicArr[textField.tag][@"title"] rangeOfString:@"成员类型"].location != NSNotFound) {
            
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"成员类型"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"集团关键人",@"集团联系人"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     
//                                     if (buttonIndex == 0) {
//                                         _type = @"集团关键人";
//                                     }else if(buttonIndex == 1){
//                                         _type = @"集团联系人";
//                                     }
//                                     [self initData];
//                                 }
//                                 
//                             }];
            
            return NO;
        }else if (self.entity.MemberKind.intValue == 1 && textField.tag == 0){
            
            return NO;
//            成员类型 1：网内成员；2：拓展成员；3：网外成员,
        }
//        else if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] && [dicArr[textField.tag][@"title"] rangeOfString:@"主要成员"].location != NSNotFound) {
//            
//            [self.view endEditing:YES];
//            
//            [UIActionSheet showInView:self.view
//                            withTitle:@"主要成员"
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:@[@"是",@"否"]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                     
//                                     
//                                     if (buttonIndex == 0) {
//                                         _main = @"是";
//                                     }else if(buttonIndex == 1){
//                                         _main = @"否";
//                                     }
//                                     [self initData];
//                                     
//                                 }
//                                 
//                             }];
//            
//            return NO;
//        }
        
        return YES;
    }
}

//获取联系人的附加信息
- (void)getData{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"get_client_addition_info",
                            @"tel":self.entity.tel,
                            @"company_num":self.company_num
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
