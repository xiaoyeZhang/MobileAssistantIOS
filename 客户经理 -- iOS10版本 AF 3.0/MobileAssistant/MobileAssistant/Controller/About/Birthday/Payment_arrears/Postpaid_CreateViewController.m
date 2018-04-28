//
//  Postpaid_CreateViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/4/25.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Postpaid_CreateViewController.h"
#import "MBProgressHUD.h"
#import "TxtFieldTableViewCell.h"
#import "CustomerViewController.h"
#import "UIActionSheet+Block.h"

@interface Postpaid_CreateViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,CustomerViewControllerDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    TxtFieldTableViewCell *cell;
    NSMutableArray *dicArr;
}
@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *company_num;
@property (copy, nonatomic) NSString *cycle;
@property (copy, nonatomic) NSString *info;//截止时间
@property (copy, nonatomic) NSString *remark;

@end

@implementation Postpaid_CreateViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"后付费审批";
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _company_name = @"";
    _company_num = @"";
    _cycle = @"";
    _info = @"";
    _remark = @"";
    
    [self initData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    
    //    $user_name  用户姓名
    //    $dep_name  部门名称
    //    $company_name  集团名称
    //    $company_num 集团编号
    //    $product_name = 产品列表
    //type:  2--只读  0--可写  1--跳转列表 3 -- 附件上传  4 -- 当前页面选择
    dicArr = [NSMutableArray arrayWithObjects:
              @{@"title":@"客户经理：",    @"type":@"2",  @"message":userEntity.name},
              @{@"title":@"申请部门：",    @"type":@"2",  @"message":userEntity.dep_name},
              @{@"title":@"集团单位：",@"type":@"1",@"message":_company_name},
              @{@"title":@"集团编号：",@"type":@"2",@"message":_company_num},
              @{@"title":@"后付费周期：",@"type":@"4",@"message":_cycle},
              @{@"title":@"申请说明：",@"type":@"0",@"message":_info},
              @{@"title":@"备      注：",@"type":@"0",@"message":_remark},
              nil];
    
    
    [self.tableView reloadData];
    
}

- (void)submitBtnClicked:(id)sender{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    if ([_cycle isEqualToString:@""]) {
        
        ALERT_ERR_MSG(@"电话号码不能为空");
        isDone = YES;
        return;
    }else if ([_company_name isEqualToString:@""]){
        ALERT_ERR_MSG(@"集团单位不能为空");
        isDone = YES;
        return;
    }else if ([_info isEqualToString:@""]){
        ALERT_ERR_MSG(@"申请说明不能为空");
        isDone = YES;
        return;
    }else if ([_remark isEqualToString:@""]){
        ALERT_ERR_MSG(@"备注不能为空");
        isDone = YES;
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    //    http://sw.avatek.com.cn/gzcms/cmm_boss.php?method=m_postpaid_create&user_id=1208&user_name=%E5%90%B4%E7%BE%8E%E6%9E%97&company_name=%E6%B5%8B%E8%AF%95%E9%9B%86%E5%9B%A2&company_num=121212&info=%E6%B5%8B%E8%AF%95&remark=%E6%B5%8B%E8%AF%95&cycle=%E5%90%8E%E4%BB%98%E8%B4%B912%E4%B8%AA%E6%9C%88&next_processor=6200
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"m_postpaid_create" forKey:@"method"];
    
    [dict setObject:userEntity.user_id forKey:@"user_id"];
    
    [dict setObject:userEntity.dep_name forKey:@"dep_name"];
    
    [dict setObject:userEntity.name forKey:@"user_name"];
    
    [dict setObject:_company_name forKey:@"company_name"];
    
    [dict setObject:_company_num forKey:@"company_num"];
    
    [dict setObject:_info forKey:@"info"];
    
    [dict setObject:_remark forKey:@"remark"];
    
    [dict setObject:_cycle forKey:@"cycle"];
    
    [self get_three_list:[dict objectForKey:@"cycle"] Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:dict];
        }else{
            
//            [self goSumbitData:dict];
        }
        [HUD hide:YES];
        isDone = YES;
    }];
    
}

- (void )get_three_list:(NSString *)business_type Successed:(void (^)(id))successed{
    
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"m_postpaid_user_list",
                           @"cycle":_cycle,
                           @"dep_id":userInfo.dep_id,
                           };
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        successed(entity);
        
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
    
    
}

- (void)showSIAlertView:(NSArray *)arr andWithDict:(NSMutableDictionary *)dic{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"下级执行人" andMessage:@""];
    
    for (int i = 0; i < arr.count; i++) {
        
        [alertView addButtonWithTitle:[arr[i] objectForKey:@"name"]
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  NSLog(@"Button1 Clicked:%@",[arr[i] objectForKey:@"name"]);
                                  
                                  [dic setObject:[arr[i] objectForKey:@"user_id"] forKey:@"next_processor"];
                                  
                                  [self goSumbitData:dic];
                              }];
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler", alertView);
        };
        
    }
    [alertView addButtonWithTitle:@"取   消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    [alertView show];
    
}

- (void)goSumbitData:(NSMutableDictionary *)dict{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {

                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
        [HUD hide:YES];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    if ([dicArr[indexPath.row][@"type"] isEqualToString:@"1"] || [dicArr[indexPath.row][@"type"] isEqualToString:@"4"]) {
        cell.txtField.placeholder = @"请选择";
        cell.downArrowImageView.hidden = NO;
        cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
    }  else{
        
        cell.txtField.placeholder = @"";
        cell.downArrowImageView.hidden = YES;
    }
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 4:
            self.cycle = textField.text;
            break;
        case 5:
            self.info = textField.text;
            break;
        case 6:
            self.remark = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"2"]) {
        
        return NO;
        
    }
    
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"]) {
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        vc.OderVC = self;
        vc.delegate = self;
        vc.enter_type = 6;
        
        return NO;
    }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"4"]){
        
        NSArray *Arr;

        Arr = @[@"后付费3个月",@"后付费6个月",@"后付费12个月"];
        
        [self.view endEditing:YES];
        [UIActionSheet showInView:self.view
                        withTitle:@"后付费周期"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:Arr
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                            
                                 if (buttonIndex == 0) {
                                     self.cycle = @"后付费3个月";
                                 }else if(buttonIndex == 1){
                                     self.cycle = @"后付费6个月";
                                 }else if(buttonIndex == 2){
                                     self.cycle = @"后付费12个月";
                                 }
              
                                 [self initData];
                             
                         }];
        
        return NO;
    }
    
    return YES;
}

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity{
    
    if (entity == nil) {
        self.company_name = @"";
        self.company_num = @"";
    } else {
        self.company_name = entity.name;
        self.company_num = entity.num;
    }
    [self initData];
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
