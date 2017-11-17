//
//  Product_Visit_SumbitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_Visit_SumbitViewController.h"
#import "TxtFieldTableViewCell.h"
#import "CalendarHomeViewController.h"
#import "Product_Visit_Select_userViewController.h"
#import "MBProgressHUD.h"

@interface Product_Visit_SumbitViewController ()<UITextFieldDelegate,Product_VisitViewControllerDelegate,MBProgressHUDDelegate>
{
    TxtFieldTableViewCell *cell;
    CalendarHomeViewController *chvc;
    MBProgressHUD *HUD;
    NSMutableArray *dicArr;
    UserEntity *userEntity;
    NSString *product_name;         //走访人姓名
    NSString *Visiting_name;        //走访单位名称
    NSString *duty_access;          //走访对接人职务
    NSString *Visit_matters;        //走访事宜
    NSString *Account_Manager;      //陪同客户经理
    NSString *Visit_date;           //走访日期
    NSString *assis_user_id;
}
@end

@implementation Product_Visit_SumbitViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"产品经理走访";
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(doCreateTask) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    product_name = @"";
    Visiting_name = @"";
    duty_access = @"";
    Visit_matters = @"";
    Account_Manager = @"";
    Visit_date = @"";
    assis_user_id = @"";
    
    [self initData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    
    //type:  2--只读  0--可写  1--跳转列表 3 -- 日期选择
    dicArr = [NSMutableArray arrayWithObjects:
              @{@"title":@"产品及项目经理姓名",    @"type":@"2", @"placeholder":@"", @"message":userEntity.name},
              @{@"title":@"走访单位\n名称",    @"type":@"0", @"placeholder":@"", @"message":Visiting_name},
              @{@"title":@"陪同客户\n经理",@"type":@"0",@"placeholder":@"",@"message":Account_Manager},
              @{@"title":@"走访对接人职务",@"type":@"0",@"placeholder":@"",@"message":duty_access},
              @{@"title":@"走访人姓名",@"type":@"0",@"placeholder":@"",@"message":product_name},
              @{@"title":@"走访事宜",@"type":@"0",@"placeholder":@"",@"message":Visit_matters},
              @{@"title":@"走访日期",@"type":@"3",@"placeholder":@"请选择",@"message":Visit_date},
              
              nil];
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dicArr.count;
    
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
    
    cell.txtField.placeholder = dicArr[indexPath.row][@"placeholder"];
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
   
        case 1:
            Visiting_name = textField.text;
            break;
        case 2:
            Account_Manager = textField.text;
            break;
        case 3:
            duty_access = textField.text;
            break;
        case 4:
            product_name = textField.text;
            break;
        case 5:
            Visit_matters = textField.text;
            break;
        default:
            break;
    }
    
    [self initData];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"2"]) {
        
        return NO;
        
    }
    
    [self.view endEditing:YES];
    
    //type:  2--只读  0--可写  1--跳转列表 3 -- 日期选择
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"]) {
        
        Product_Visit_Select_userViewController *vc = [[Product_Visit_Select_userViewController alloc]init];
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];

        return NO;
    }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"3"]) {
        
        if (!chvc) {
            chvc = [[CalendarHomeViewController alloc]init];
            chvc.calendartitle = @"选择日期";
            [chvc setAirPlaneToDay:365 ToDateforString:nil];//
        }
        
        //    [scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
        chvc.calendarblock = ^(CalendarDayModel *model){
            
            NSLog(@"\n---------------------------");
            NSLog(@"1星期 %@",[model getWeek]);
            NSLog(@"2字符串 %@",[model toString]);
            NSLog(@"3节日  %@",model.holiday);
            
            textField.text = [NSString stringWithFormat:@"%@",[model toString]];
            
            Visit_date = [NSString stringWithFormat:@"%@",[model toString]];
        };
        
        [self.navigationController pushViewController:chvc animated:YES];
        
        return NO;
    }
    
    return YES;
}


- (void)addProduct_VisitViewController:(Product_Visit_Select_userViewController *)vc didSelectUser:(No_visit_listEntity *)UserEntity{
    
    Account_Manager = UserEntity.name;

    assis_user_id = UserEntity.user_id;
    
    [self initData];
    
}

- (void) doCreateTask
{
    /*
    method = product_visit_create_task
    user_id =唯一ID
    company_name = 公司名称（填写）
    assis_user_id = 随访客户经理（复用之前的接口）
    job=职务
    client_name=客户姓名
    time=时间 YYYY-MM-DD
     
     
     NSString *product_name;         //走访人
     NSString *Visiting_name;        //走访单位名称
     NSString *duty_access;          //走访对接人职务
     NSString *Visit_matters;        //走访事宜
     NSString *Account_Manager;      //陪同客户经理
     NSString *Visit_date;           //走访日期
     
    */
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    if ([Visiting_name isEqualToString:@""]) {
        
        ALERT_ERR_MSG(@"走访单位名称不能为空");
        isDone = YES;
        return;
    }
//    else if ([Account_Manager isEqualToString:@""]){
//        ALERT_ERR_MSG(@"陪同客户经理不能为空");
//        isDone = YES;
//        return;
//    }
    else if ([duty_access isEqualToString:@""]){
        ALERT_ERR_MSG(@"走访对接人职务不能为空");
        isDone = YES;
        return;
    }else if ([product_name isEqualToString:@""]){
        ALERT_ERR_MSG(@"走访人姓名不能为空");
        isDone = YES;
        return;
    }else if ([Visit_matters isEqualToString:@""]){
        ALERT_ERR_MSG(@"走访事宜不能为空");
        isDone = YES;
        return;
    }else if ([Visit_date isEqualToString:@""]){
        ALERT_ERR_MSG(@"走访日期不能为空");
        isDone = YES;
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"product_visit_create_task",
                           @"user_id":userEntity.user_id,
                           @"company_name":Visiting_name,
                           @"assis_user_id":assis_user_id,
                           @"assis_user_name":Account_Manager,
                           @"job":duty_access,
                           @"client_name":product_name,
                           @"content":Visit_matters,
                           @"time":Visit_date,
                           };
    
    [service getNetWorkData:dict Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
        
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
        
                [self backBtnClicked:nil];
            }];
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        
        [HUD hide:YES];
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        isDone = YES;
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
