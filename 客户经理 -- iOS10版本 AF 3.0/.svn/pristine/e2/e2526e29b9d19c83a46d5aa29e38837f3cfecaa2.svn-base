//
//  New_MyGroup_baseMessageViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "New_MyGroup_baseMessageViewController.h"
#import "TxtFieldTableViewCell.h"
#import "LineTwoLabelTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "UserEntity.h"
#import "MBProgressHUD.h"

@interface New_MyGroup_baseMessageViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    NSArray *dicArr;
    TxtFieldTableViewCell *cell;
    LineTwoLabelTableViewCell *cell1;
}

//集团编号
@property (strong, nonatomic) NSString *Group_number;
//集团状态
@property (strong, nonatomic) NSString *Group_status;
//集团地址
@property (strong, nonatomic) NSString *Group_address;
//集团类型
@property (strong, nonatomic) NSString *Group_type;
//首席代表
@property (strong, nonatomic) NSString *Chief_representative;
//联系方式
@property (strong, nonatomic) NSString *Tel;
//保有率
@property (strong, nonatomic) NSString *Retention_rate;
//目前合作情况
@property (strong, nonatomic) NSString *Cooperation_situation;
//目前合作困难
@property (strong, nonatomic) NSString *Cooperation_difficulties;
//集团当前属于
@property (strong, nonatomic) NSString *Group_belongs;
//通信与信息化收入
@property (strong, nonatomic) NSString *Communication_information;

@end

@implementation New_MyGroup_baseMessageViewController
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
    
    if (![userEntity.is_first isEqualToString:@"1"]) {
        
        UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"保存"];
        [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _Group_number = self.compEntity.num;
    
    if ([self.compEntity.company_status isEqualToString:@"0"]) {
        _Group_status = @"正使用集团客户";
    }else{
        _Group_status = @"未开户集团客户";
    }

    _Group_address = self.compEntity.address;
    _Group_type = [self setLevel:self.compEntity.company_level];
    _Chief_representative = @"张波";
    _Tel = @"1397768741";
    _Retention_rate = @"等待接口";
    _Cooperation_situation = @"待填写";
    _Cooperation_difficulties = @"待填写";
    _Group_belongs = @"";
    _Communication_information = @"等待接口";
    
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
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    [param setValue:@"add_update_company_addition_info" forKey:@"method"];
    [param setValue:self.compEntity.num forKey:@"company_num"];
    
    [param setValue:_Retention_rate forKey:@"cp_retention_rate"];
    [param setValue:_Cooperation_situation forKey:@"cp_cooperation_situation"];
    [param setValue:_Cooperation_difficulties forKey:@"cp_cooperation_difficulties"];
    [param setValue:_Group_belongs forKey:@"cp_group_belongs"];
    [param setValue:_Communication_information forKey:@"cp_communication_information"];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state integerValue] > 0) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
        }else{
            
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];

    
}

- (void)initData{
    
    dicArr= @[@{@"title":@"集团编号：",@"type":@"2",@"message":_Group_number},
              @{@"title":@"集团状态：",@"type":@"2",@"message":_Group_status},
              @{@"title":@"集团地址：",@"type":@"2",@"message":_Group_address},
              @{@"title":@"集团类型：",    @"type":@"2",@"message":_Group_type},
              @{@"title":[userEntity.type_id isEqualToString:@"0"]?@"首席代表：":@"客户经理：",    @"type":@"2",@"message":_Chief_representative},
              @{@"title":@"联系方式：",@"type":@"2",@"message":_Tel},
              @{@"title":@"保  有  率：",    @"type":@"2",@"message":_Retention_rate},
              @{@"title":@"目 前 合 作 情 况：",    @"type":@"0",@"message":_Cooperation_situation},
              @{@"title":@"目 前 合 作 困 难：",@"type":@"0",@"message":_Cooperation_difficulties},
              @{@"title":@"集 团 当 前 属 于：",    @"type":@"1",@"message":_Group_belongs},
              @{@"title":@"通信与信息化收入：",    @"type":@"2",@"message":_Communication_information}];

    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dicArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
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
        
        if (indexPath.row == 2) {
            cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if(!cell1)
            {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.titLabel.text = dicArr[indexPath.row][@"title"];
            cell1.subTitleLbl.layer.borderWidth = 0.5;
            cell1.subTitleLbl.font = [UIFont systemFontOfSize:14];
            cell1.subTitleLbl.layer.cornerRadius = 6;
            cell1.subTitleLbl.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
            
            cell1.subTitleLbl.textColor = [UIColor darkGrayColor];
            cell1.subTitleLbl.text = dicArr[indexPath.row][@"message"];
            
            return cell1;
        }
        
        cell.txtField.placeholder = @"";
        cell.downArrowImageView.hidden = YES;
        
    }
    
    if ([dicArr[indexPath.row][@"type"] isEqualToString:@"2"]) {
        cell.txtField.textColor = [UIColor darkGrayColor];
    }else{
        cell.txtField.textColor = [UIColor blackColor];
    }
    
    return cell;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 6:
            
            self.Retention_rate = textField.text;
            
            break;
        case 7:
            self.Cooperation_situation = textField.text;
            break;
        case 8:
            self.Cooperation_difficulties = textField.text;
            break;
        case 10:
            self.Communication_information = textField.text;
            break;
            
        default:
            break;
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([userEntity.is_first isEqualToString:@"1"]) {
        
        return NO;
    }else{
        if ([dicArr[textField.tag][@"type"] isEqualToString:@"2"]) {
            return NO;
            
        }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] ) {
            
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"集团当前属于"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"重点保有集团",@"重点发展集团"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     
                                     if (buttonIndex == 0) {
                                         _Group_belongs = @"重点保有集团";
                                     }else if(buttonIndex == 1){
                                         _Group_belongs = @"重点发展集团";
                                     }
                                     [self initData];
                                 }
                                 
                             }];
            
            return NO;
            
        }
        
        return YES;
    }
  
}

//获取集团的附加信息
- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = @{@"method":@"get_company_addition_info",
                            @"user_id":entity.user_id,
                            @"is_first":entity.is_first,
                            @"company_num":self.compEntity.num
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
           NSDictionary *dic = [entity objectForKey:@"content"];


            _Chief_representative = [dic objectForKey:@"name"];
            _Tel = [dic objectForKey:@"tel"];

        }else if([strState isEqualToString:@"2"] == YES){
            
            NSDictionary *dic = [entity objectForKey:@"content"];
            
            _Chief_representative = [dic objectForKey:@"name"];
            _Tel = [dic objectForKey:@"tel"];
            
            _Retention_rate = [dic objectForKey:@"cp_retention_rate"];
            _Cooperation_situation = [dic objectForKey:@"cp_cooperation_situation"];
            _Cooperation_difficulties = [dic objectForKey:@"cp_cooperation_difficulties"];
            _Group_belongs = [dic objectForKey:@"cp_group_belongs"];
            _Communication_information = [dic objectForKey:@"cp_communication_information"];
            
        }else{
            
        }
        
        [self initData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
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
