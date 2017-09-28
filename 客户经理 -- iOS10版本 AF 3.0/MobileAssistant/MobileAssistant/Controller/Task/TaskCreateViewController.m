////
////  TaskCreateViewController.m
////  MobileAssistant
////
////  Created by 房 国生 on 14-9-20.
////  Copyright (c) 2014年 avatek. All rights reserved.
////
//
//#import "TaskCreateViewController.h"
//#import "MBProgressHUD.h"
//#import "CommonService.h"
//#import "CalendarHomeViewController.h"
//#import "CalendarViewController.h"
//#import "Color.h"
//#import "ExecutorViewController.h"
//#import "CustomerViewController.h"
//#import "ContactViewController.h"
//#import "UserEntity.h"
//
//@interface TaskCreateViewController ()<MBProgressHUDDelegate>
//{
//    MBProgressHUD *HUD;
//    CalendarHomeViewController *chvc;
//}
//@end
//
//@implementation TaskCreateViewController
//@synthesize viewMore, btnShowMore;
//@synthesize scrollView;
//@synthesize titleTextField;
//@synthesize actionTextField;
//@synthesize customerTextField;
//@synthesize contactTextField;
//@synthesize jobTitleTextField;
//@synthesize addrTextField;
//@synthesize dateTextField;
//@synthesize desTextField;
//@synthesize taskNumberTextField;
//@synthesize giftNumberTextField;
//
//@synthesize dateBtn;
//@synthesize actionBtn;
//@synthesize contactBtn;
//@synthesize customerBtn;
//
//@synthesize exEntity;
//@synthesize compEntity;
//@synthesize contactEntity;
//
//@synthesize fromCoustomer;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//
//    self.title = @"制定拜访任务";
//
//    NSInteger height = [self getBoardHeight:YES];
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
//    //bgImageView.backgroundColor = GrayBackgroundColor;
//    bgImageView.image = [UIImage imageNamed:@"background"];
//    [self.view addSubview:bgImageView];
//
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//
//    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
//    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
//    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
//    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
//    self.navigationItem.rightBarButtonItem = nextButtonItem;
//
//    viewMore.hidden = YES;
//
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    CGSize size = rect.size;
//    CGFloat width = size.width;
//
//    if (width == 480.0) {
//        [scrollView setContentSize: CGSizeMake(320, 960)];
//    } else {
//        [scrollView setContentSize: CGSizeMake(320, 640)];
//    }
//
//    NSDate * newDate = [NSDate date];
//    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
//    [dateformat setDateFormat:@"yyyy-MM-dd"];
//    NSString * newDateOne = [dateformat stringFromDate:newDate];
//    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSLog(@"%@",newDateOne);
//
//    [dateBtn setTitle:newDateOne forState:UIControlStateNormal];
//
//    //{{from comstomer page
//    if (fromCoustomer == YES) {
//        [customerBtn setTitle:compEntity.name forState:UIControlStateNormal];
//        addrTextField.text = compEntity.address;
//        [contactBtn setTitle:contactEntity.name forState:UIControlStateNormal];
//        jobTitleTextField.text = contactEntity.job;
//    }
//    //}}
//    //{{
//    exEntity = [[ExecutorEntity alloc] init];
//    UserEntity *userEntity = [UserEntity sharedInstance];
//    exEntity.user_id = userEntity.user_id;
//    exEntity.name = userEntity.name;
//    exEntity.tel = userEntity.tel;
//
//    [actionBtn setTitle:exEntity.name forState:UIControlStateNormal];
//    //}}
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
//-(IBAction)doShowMoreView:(id)sender
//{
//    viewMore.hidden = NO;
//    btnShowMore.hidden = YES;
//}
//
//-(IBAction)doHideMoreView:(id)sender
//{
//    viewMore.hidden = YES;
//    btnShowMore.hidden = NO;
//}
//
//- (void)backAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)fininCreate:(id)sender
//{
//    if (titleTextField.text.length == 0) {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"主题不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alter show];
//        return;
//    }
//
//    if(customerBtn.titleLabel.text.length == 0)
//    {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"客户名称不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alter show];
//        return;
//    }
//
//    if(contactBtn.titleLabel.text.length == 0)
//    {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"客户联系人不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alter show];
//        return;
//    }
//
//    if(desTextField.text.length == 0)
//    {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"目的不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alter show];
//        return;
//    }
//
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"努力加载中...";
//    [self doCreateTask];
//
//    //[HUD showWhileExecuting:@selector(doCreateTask) onTarget:self withObject:nil animated:YES];
//}
//
//- (void)handleKeyboardWillHide:(NSNotification *)notification
//{
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//}
//
//- (void)handleKeyboardDidShow:(NSNotification *)notification
//{
//}
//
//- (IBAction)textFieldBeginEdit:(UITextField *)theTextField {
//
//    if (theTextField == self.jobTitleTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
//    } else if (theTextField == self.addrTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    } else if (theTextField == self.dateTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
//    } else if (theTextField == self.desTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
//    }
//
//    if (theTextField == self.taskNumberTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 230) animated:YES];
//    } if (theTextField == self.giftNumberTextField) {
//        [scrollView setContentOffset:CGPointMake(0, 290) animated:YES];
//    }
//}
//
//- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
//
//    if (theTextField == self.titleTextField) {
//        [actionTextField becomeFirstResponder];
//    } else if (theTextField == self.actionTextField) {
//        [customerTextField becomeFirstResponder];
//    } else if (theTextField == self.customerTextField) {
//        [contactTextField becomeFirstResponder];
//    } else if (theTextField == self.contactTextField) {
//        [jobTitleTextField becomeFirstResponder];
//    } else if (theTextField == self.jobTitleTextField) {
//        [addrTextField becomeFirstResponder];
//        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
//    } else if (theTextField == self.addrTextField) {
//        [dateTextField becomeFirstResponder];
//        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    } else if (theTextField == self.dateTextField) {
//        [desTextField becomeFirstResponder];
//        [scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
//    } else if (theTextField == self.desTextField) {
//        if (viewMore.hidden == NO) {
//            [taskNumberTextField becomeFirstResponder];
//            [scrollView setContentOffset:CGPointMake(0, 230) animated:YES];
//        } else {
//            [theTextField resignFirstResponder];
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }
//
//    if (viewMore.hidden == NO) {
//        if (theTextField == self.taskNumberTextField) {
//            [giftNumberTextField becomeFirstResponder];
//            [scrollView setContentOffset:CGPointMake(0, 290) animated:YES];
//        } if (theTextField == self.giftNumberTextField) {
//            [theTextField resignFirstResponder];
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }
//}
//
//- (IBAction)doSelectCalendar:(id)sender
//{
//    if (!chvc) {
//        chvc = [[CalendarHomeViewController alloc]init];
//        chvc.calendartitle = @"选择日期";
//        [chvc setAirPlaneToDay:365 ToDateforString:nil];//
//    }
//
//    [scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
//    chvc.calendarblock = ^(CalendarDayModel *model){
//
//        NSLog(@"\n---------------------------");
//        NSLog(@"1星期 %@",[model getWeek]);
//        NSLog(@"2字符串 %@",[model toString]);
//        NSLog(@"3节日  %@",model.holiday);
//        [sender setTitle:[NSString stringWithFormat:@"%@",[model toString]] forState:UIControlStateNormal];
////        if (model.holiday) {
////            [sender setTitle:[NSString stringWithFormat:@"%@ %@ %@",[model toString],[model getWeek],model.holiday] forState:UIControlStateNormal];
////        }else{
////            [sender setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
////        }
//    };
//
//    [self.navigationController pushViewController:chvc animated:YES];
//}
//
//- (IBAction)doSelectActor:(id)sender
//{
//    UserEntity *userEntity = [UserEntity sharedInstance];
//    if ([userEntity.type_id isEqualToString:@"0"] == YES) {
//        return;
//    }
//    ExecutorViewController *vc = [[ExecutorViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.tcVC = self;
//}
//
//- (IBAction)doSelectCustomer:(id)sender
//{
//    CustomerViewController *vc = [[CustomerViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.tcVC = self;
//}
//
//- (IBAction)doSelectContact:(id)sender
//{
//    ContactViewController *vc = [[ContactViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.tcVC = self;
//    vc.compEntity = compEntity;
//}
//
//
//- (void) setExecutorValue:(ExecutorEntity *)ex
//{
//    exEntity = ex;
//    [actionBtn setTitle:exEntity.name forState:UIControlStateNormal];
//}
//
//- (void) setCustomerValue:(CompEntity *)ex
//{
//    compEntity = ex;
//    [customerBtn setTitle:compEntity.name forState:UIControlStateNormal];
//    addrTextField.text = compEntity.address;
//}
//
//- (void) setCotactValue:(ContactEntity *)ex
//{
//    contactEntity = ex;
//    [contactBtn setTitle:contactEntity.name forState:UIControlStateNormal];
//    jobTitleTextField.text = ex.job;
//}
//
//- (void) doCreateTask
//{
//    UserEntity *userEntity = [UserEntity sharedInstance];
//
//    //{{检查是否有重复提交问题
//    CommonService *service = [[CommonService alloc] init];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           exEntity.user_id, @"actor_id",
//                           contactEntity.client_id, @"client_id",
//                           titleTextField.text, @"title",
//                           dateBtn.titleLabel.text, @"time",
//                           @"repeattask", @"method", nil];
//
//    [service getNetWorkData:param  Successed:^(id entity) {
//        NSNumber *state = [entity valueForKeyPath:@"state"];
//        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//        if ([strState isEqualToString:@"0"] == YES) {
//
//            /*
//             maker_id	指定人的ID	必填
//             actor_id	执行人id	必填
//             client_id	客户id	必填
//             title	走访主题	必填
//             time	任务时间	必填
//             reason	任务描述	必填
//             add1	任务编号
//             add2	礼品编号
//             */
//            [HUD show:YES];
//            CommonService *service = [[CommonService alloc] init];
//            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                     userEntity.user_id, @"maker_id",
//                     exEntity.user_id, @"actor_id",
//                     contactEntity.client_id, @"client_id",
//                     titleTextField.text, @"title",
//                     dateBtn.titleLabel.text, @"time",
//                     desTextField.text, @"reason",
//                     taskNumberTextField.text, @"add1",
//                     giftNumberTextField.text, @"add2",
//                     compEntity.company_id, @"company_id",
//                     @"createtask", @"method", nil];
//
//            [service getNetWorkData:param  Successed:^(id entity) {
//                NSNumber *state = [entity valueForKeyPath:@"state"];
//                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
//                if ([strState isEqualToString:@"0"] == YES) {
//                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }
//                else
//                {
//                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                    //NSMutableArray *array = [entity objectForKey:@"content"];
//                }
//                [HUD hide:YES];
//            } Failed:^(int errorCode, NSString *message) {
//                NSLog(@"%@", message);
//                [HUD hide:YES];
//            }];
//        }
//        else
//        {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能重复制定相同的任务！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            //NSMutableArray *array = [entity objectForKey:@"content"];
//        }
//        [HUD hide:YES];
//    } Failed:^(int errorCode, NSString *message) {
//        NSLog(@"%@", message);
//        [HUD hide:YES];
//    }];
//    //}}
//
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (1==buttonIndex)
//    {
//
//    }
//    if (0==buttonIndex) {
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"点击了确认按钮");
//    }
//}
//
//@end




//////////////////////////////////////////////////////////////////////////////////////////
//
//  TaskCreateViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "TaskCreateViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "Color.h"
#import "ExecutorViewController.h"
#import "CustomerViewController.h"
#import "ContactViewController.h"
#import "UserEntity.h"
#import "Customer_epresentativeViewController.h"

@interface TaskCreateViewController ()<MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    
    NSString *actor_id;
    
    MBProgressHUD *HUD;
    CalendarHomeViewController *chvc;
    BOOL FininCreateBtn;
    
    NSString *yes_noStr;
    NSString *unfinish_id;
    
    NSString *company_num;
    NSString *company_level;
}
@end

@implementation TaskCreateViewController
@synthesize viewMore, btnShowMore;
@synthesize scrollView;
@synthesize titleTextField;
@synthesize actionTextField;
@synthesize customerTextField;
@synthesize contactTextField;
@synthesize jobTitleTextField;
@synthesize addrTextField;
@synthesize dateTextField;
@synthesize desTextField;
@synthesize taskNumberTextField;
@synthesize giftNumberTextField;

@synthesize dateBtn;
@synthesize up_dataBtn;
@synthesize actionBtn;
@synthesize contactBtn;
@synthesize customerBtn;

@synthesize exEntity;
@synthesize compEntity;
@synthesize contactEntity;

@synthesize fromCoustomer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    userEntity = [UserEntity sharedInstance];
    
    actor_id = userEntity.user_id;
    
    [self select_logmodel:NSStringFromClass([self class])];
    self.title = @"制定拜访任务";
    
    FininCreateBtn = NO;
    
    _setCustomer_epresentativeBtn.userInteractionEnabled = NO;
    
    yes_noStr = @"0";
    
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //bgImageView.backgroundColor = GrayBackgroundColor;
    bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImageView];
    
    //    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    //    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    //    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //
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
    
    viewMore.hidden = YES;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    
    if (width == 480.0) {
        [scrollView setContentSize: CGSizeMake(320, 960)];
    } else {
        [scrollView setContentSize: CGSizeMake(320, 700)];
    }
    
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    
    [dateBtn setTitle:newDateOne forState:UIControlStateNormal];
    [up_dataBtn setTitle:newDateOne forState:UIControlStateNormal];
    
    //{{from comstomer page
    if (fromCoustomer == YES) {
        [customerBtn setTitle:compEntity.name forState:UIControlStateNormal];
        addrTextField.text = compEntity.address;
        [contactBtn setTitle:contactEntity.name forState:UIControlStateNormal];
        jobTitleTextField.text = contactEntity.job;
    }
    //}}
    //{{
    exEntity = [[ExecutorEntity alloc] init];
    
    exEntity.user_id = userEntity.num;
    exEntity.name = userEntity.name;
    exEntity.tel = userEntity.tel;
    
    [actionBtn setTitle:exEntity.name forState:UIControlStateNormal];
    //}}
    
    
    if (self.entity != nil) {
        
        [customerBtn setTitle:self.entity.name forState:UIControlStateNormal];
        company_num = self.entity.num;
        company_level = self.entity.company_level;
        addrTextField.text = self.entity.address;
        
    }else if (self.No_visit_Entity != nil){

        customerBtn.userInteractionEnabled = NO;
        [customerBtn setTitle:self.No_visit_Entity.name forState:UIControlStateNormal];
        company_num = self.No_visit_Entity.num;
        company_level = self.No_visit_Entity.company_level;
        addrTextField.text = self.No_visit_Entity.address;
        
    }else if (self.handlingEntity != nil){
        
        customerBtn.userInteractionEnabled = NO;
        [customerBtn setTitle:self.handlingEntity.company_name forState:UIControlStateNormal];
        unfinish_id = self.handlingEntity.unvisit_id;
        company_num = self.handlingEntity.company_num;
        company_level = self.handlingEntity.company_level;
        addrTextField.text = self.handlingEntity.address;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TaskCreateViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"TaskCreateViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
{
    if (isShowNavigationBar) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 7.0f) {
            return self.view.frame.size.height - 64.0f;
        }
        else
            return self.view.frame.size.height - 44.0;
    }
    else {
        return self.view.frame.size.height;
    }
}

-(IBAction)doShowMoreView:(id)sender
{
    viewMore.hidden = NO;
    btnShowMore.hidden = YES;
}

-(IBAction)doHideMoreView:(id)sender
{
    viewMore.hidden = YES;
    btnShowMore.hidden = NO;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fininCreate:(id)sender
{
    
    if([yes_noStr isEqualToString:@"1"]){
        
        if (_setCustomer_epresentativeBtn.titleLabel.text.length == 0) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"首席客户代表不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    
    if (titleTextField.text.length == 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"主题不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    if(customerBtn.titleLabel.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"客户名称不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    if(contactBtn.titleLabel.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"客户联系人不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    if(desTextField.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"目的不能为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
   
    
    if([yes_noStr isEqualToString:@"1"]){
        
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"首席拜访任务提交后，该单位客户画像信息将推送至首席客户代表，是否确认提交该任务" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"努力加载中...";
            [self doCreateTask];
            
        }];
        [contoller addAction:cancelAction];
        [contoller addAction:otherAction];
        [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
        
    }else{
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"努力加载中...";
        [self doCreateTask];
        
    }
    //[HUD showWhileExecuting:@selector(doCreateTask) onTarget:self withObject:nil animated:YES];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
}

- (IBAction)textFieldBeginEdit:(UITextField *)theTextField {
    
    if (theTextField == self.jobTitleTextField) {
        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    } else if (theTextField == self.addrTextField) {
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (theTextField == self.dateTextField) {
        [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    } else if (theTextField == self.desTextField) {
        [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    
    if (theTextField == self.taskNumberTextField) {
        [scrollView setContentOffset:CGPointMake(0, 230) animated:YES];
    } if (theTextField == self.giftNumberTextField) {
        [scrollView setContentOffset:CGPointMake(0, 290) animated:YES];
    }
}

- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.titleTextField) {
        [actionTextField becomeFirstResponder];
    } else if (theTextField == self.actionTextField) {
        [customerTextField becomeFirstResponder];
    } else if (theTextField == self.customerTextField) {
        [contactTextField becomeFirstResponder];
    } else if (theTextField == self.contactTextField) {
        [jobTitleTextField becomeFirstResponder];
    } else if (theTextField == self.jobTitleTextField) {
        [addrTextField becomeFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    } else if (theTextField == self.addrTextField) {
        [dateTextField becomeFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (theTextField == self.dateTextField) {
        [desTextField becomeFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    } else if (theTextField == self.desTextField) {
        if (viewMore.hidden == NO) {
            [taskNumberTextField becomeFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 230) animated:YES];
        } else {
            [theTextField resignFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    if (viewMore.hidden == NO) {
        if (theTextField == self.taskNumberTextField) {
            [giftNumberTextField becomeFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 290) animated:YES];
        } if (theTextField == self.giftNumberTextField) {
            [theTextField resignFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (IBAction)doSelectCalendar:(id)sender
{
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
        [sender setTitle:[NSString stringWithFormat:@"%@",[model toString]] forState:UIControlStateNormal];
        //        if (model.holiday) {
        //            [sender setTitle:[NSString stringWithFormat:@"%@ %@ %@",[model toString],[model getWeek],model.holiday] forState:UIControlStateNormal];
        //        }else{
        //            [sender setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
        //        }
    };
    
    [self.navigationController pushViewController:chvc animated:YES];
}

- (IBAction)doSelectActor:(id)sender
{
    
    if ([userEntity.type_id isEqualToString:@"0"] == YES) {
        return;
    }
    ExecutorViewController *vc = [[ExecutorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.tcVC = self;
}

- (IBAction)doSelectCustomer:(id)sender
{
    CustomerViewController *vc = [[CustomerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.tcVC = self;
}

- (IBAction)yes_no_Btn:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        yes_noStr = @"1";
        
        [self.Yes_Btn setImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateNormal];
        [self.No_Btn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        
        _setCustomer_epresentativeBtn.userInteractionEnabled = YES;
        _Customer_epresentativeLabel.textColor = RGBA(0, 0, 0, 1);
        
        
    }else if (sender.tag == 2){
        
        yes_noStr = @"0";
        
        [self.Yes_Btn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [self.No_Btn setImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateNormal];
        
        _Customer_epresentativeLabel.textColor = RGBA(170, 170, 170, 1);
        _setCustomer_epresentativeBtn.userInteractionEnabled = NO;
        
    }
    
}
#pragma  mark - 客户代表
- (IBAction)doSelectCustomer_representative:(id)sender {
    
    Customer_epresentativeViewController *vc = [[Customer_epresentativeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.tcVC = self;
}

- (IBAction)doSelectContact:(id)sender
{
    if (customerBtn.titleLabel.text.length <= 0) {
        ALERT_ERR_MSG(@"请选择客户");
        return;
    }
    ContactViewController *vc = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.tcVC = self;
    
    if (self.entity != nil) {
        
         vc.num = self.entity.num;
        
    }else if (self.No_visit_Entity != nil){
        
         vc.num = self.No_visit_Entity.num;
    }else if (self.handlingEntity != nil){
        
         vc.num = self.handlingEntity.company_num;
    }
    
    vc.compEntity = compEntity;
    
}

- (void) setCustomer_epresentative:(ExecutorEntity *)ex
{
    exEntity = ex;
    [_setCustomer_epresentativeBtn setTitle:exEntity.name forState:UIControlStateNormal];
    
    actor_id = exEntity.user_id;
    
}

- (void) setExecutorValue:(ExecutorEntity *)ex
{
    exEntity = ex;
    [actionBtn setTitle:exEntity.name forState:UIControlStateNormal];
}

- (void) setCustomerValue:(CompEntity *)ex
{
    compEntity = ex;
    
    if (ex == nil) {
        [customerBtn setTitle:@"" forState:UIControlStateNormal];
        addrTextField.text = @"";
    } else {
        [customerBtn setTitle:compEntity.name forState:UIControlStateNormal];
        addrTextField.text = compEntity.address;
    }
    
}

- (void) setCotactValue:(ContactEntity *)ex
{
    contactEntity = ex;
    
    if (ex == nil) {
        [contactBtn setTitle:@"" forState:UIControlStateNormal];
        jobTitleTextField.text = @"";
    } else {
        [contactBtn setTitle:contactEntity.name forState:UIControlStateNormal];
        jobTitleTextField.text = ex.job;
    }
}

- (void) doCreateTask
{
    
    
    //{{检查是否有重复提交问题
    //    CommonService *service = [[CommonService alloc] init];
    //    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    //                           exEntity.user_id, @"actor_id",
    //                           contactEntity.MemberCustId, @"client_id",
    //                           titleTextField.text, @"title",
    //                           dateBtn.titleLabel.text, @"time",
    //                           @"repeattask", @"method", nil];
    if (FininCreateBtn == NO) {
        FininCreateBtn = YES;
        //    [service getNetWorkData:param  Successed:^(id entity) {
        //        NSNumber *state = [entity valueForKeyPath:@"state"];
        //        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        //        if ([strState isEqualToString:@"0"] == YES) {
        
        /*
         maker_id	指定人的ID	必填
         actor_id	执行人id	必填
         client_id	客户id	必填
         title	走访主题	必填
         time	任务时间	必填
         reason	任务描述	必填
         add1	任务编号
         add2	礼品编号
         */
        //            [HUD show:YES];
        CommonService *service = [[CommonService alloc] init];
        //            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
        //                                   userEntity.user_id, @"maker_id",
        //                                   exEntity.user_id, @"actor_id",
        //                                   contactEntity.client_id, @"client_id",
        //                                   titleTextField.text, @"title",
        //                                   dateBtn.titleLabel.text, @"time",
        //                                   desTextField.text, @"reason",
        //                                   taskNumberTextField.text, @"add1",
        //                                   giftNumberTextField.text, @"add2",
        //                                   compEntity.company_id, @"company_id",
        //                                   @"createtask", @"method", nil];
        //boss接口
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               userEntity.user_id,         @"maker_id",
                               userEntity.user_id,         @"actor_id",
                               yes_noStr,                  @"is_chief",
                               customerBtn.titleLabel.text,@"company_name",
                               contactBtn.titleLabel.text, @"client_name",
                               addrTextField.text,         @"company_address",
                               contactEntity.tel,          @"client_tel",
                               compEntity?compEntity.num:company_num,             @"company_num",
                               compEntity?compEntity.company_level:company_level,   @"company_level",
                               jobTitleTextField.text,     @"client_job",
                               titleTextField.text,        @"title",
                               dateBtn.titleLabel.text,    @"time",
                               desTextField.text,          @"reason",
                               taskNumberTextField.text,   @"add1",
                               giftNumberTextField.text,   @"add2",
                               up_dataBtn.titleLabel.text, @"up_date",
                               @"createtask",              @"method",
                               @"1",                       @"check",
                               [yes_noStr isEqualToString:@"1"]?actor_id:@"-1",    @"assist_id",
                               nil];
        
        [service getNetWorkData:param  Successed:^(id entity) {
            NSNumber *state = [entity valueForKeyPath:@"state"];
            NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
            if ([strState isEqualToString:@"0"] == YES) {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else
            {
                if ([strState isEqualToString:@"-1"] == YES) {
                    
                        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:[entity valueForKeyPath:@"content"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                            [self getSecond_creat];
                            
                        }];
                        
                        UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                            FininCreateBtn = NO;
                            
                        }];
                        [contoller addAction:otherAction];
                        [contoller addAction:canceAction];
                        [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
                    
                }else if ([strState isEqualToString:@"1"] == YES){
                    
                    if ((self.entity != nil || self.handlingEntity != nil || self.No_visit_Entity != nil) && compEntity == nil) {
                        
                        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"制定任务成功！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                            
                            if (unfinish_id.length > 0) {
                                [self getExec_unvisit_task:[entity valueForKey:@"content"]];
                            }else{
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }];
                        [contoller addAction:otherAction];
                        [self presentViewController:contoller animated:YES completion:nil];//弹出提醒框
                        
                    }else{
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    
                }else{
                    
                }
                //NSMutableArray *array = [entity objectForKey:@"content"];
            }
            [HUD hide:YES];
        } Failed:^(int errorCode, NSString *message) {
            NSLog(@"%@", message);
            [HUD hide:YES];
        }];
        //        }
        //        else
        //        {
        //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能重复制定相同的任务！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //            [alert show];
        //            //NSMutableArray *array = [entity objectForKey:@"content"];
        //        }
        //        [HUD hide:YES];
        //    } Failed:^(int errorCode, NSString *message) {
        //        NSLog(@"%@", message);
        //        [HUD hide:YES];
        //    }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        
    }
    if (0==buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了确认按钮");
    }
}

- (void)getSecond_creat{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.user_id,         @"maker_id",
                           userEntity.user_id,         @"actor_id",
                           yes_noStr,                  @"is_chief",
                           customerBtn.titleLabel.text,@"company_name",
                           contactBtn.titleLabel.text, @"client_name",
                           addrTextField.text,         @"company_address",
                           contactEntity.tel,          @"client_tel",
                           compEntity?compEntity.num:company_num,             @"company_num",
                           compEntity?compEntity.company_level:company_level,   @"company_level",
                           jobTitleTextField.text,     @"client_job",
                           titleTextField.text,        @"title",
                           dateBtn.titleLabel.text,    @"time",
                           desTextField.text,          @"reason",
                           taskNumberTextField.text,   @"add1",
                           giftNumberTextField.text,   @"add2",
                           up_dataBtn.titleLabel.text, @"up_date",
                           @"createtask",              @"method",
                           @"0",                       @"check",
                           [yes_noStr isEqualToString:@"1"]?actor_id:@"-1",    @"assist_id",
                           nil];
    
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"0"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"制定任务成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
}

- (void)getExec_unvisit_task:(NSString *)visit_id{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"exec_unvisit_task",
                           @"unfinish_id":unfinish_id,
                           @"visit_id":visit_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {

            [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
        }

    } Failed:^(int errorCode, NSString *message) {

    }];
    
}

@end

