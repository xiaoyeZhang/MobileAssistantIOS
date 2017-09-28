//
//  AboutViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "AboutViewController.h"
#import "SummaryEntity.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "SuggestViewController.h"
#import "LocationEntity.h"
#import "UIActionSheet+Block.h"
//#import "WZLBadgeImport.h"
#import "ProvinceVIPViewController.h"

@interface AboutViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    SummaryEntity *summaryEntity;
}
@end

@implementation AboutViewController
@synthesize scrollView;
@synthesize labelLastMonth, labelMonth, labelName, labelToday, labelWeek;
@synthesize mainVC;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIScreen *currentScreen = [UIScreen mainScreen];
//    
//    if (currentScreen.applicationFrame.size.height == 460.000000) {
//        scrollView.contentSize = CGSizeMake(320,670);
//    } else {
//        scrollView.contentSize = CGSizeMake(320,480);
//    }
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.bounds.size.height);
    [self getData];
    [self getUnfinishedNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"AboutViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"AboutViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doFeedBack:(id)sender
{
    SuggestViewController *vc = [[SuggestViewController alloc] init];
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logout:(id)sender
{
    [UIActionSheet showInView:self.view
                    withTitle:@"确认注销当前账号?"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:@"注销"
            otherButtonTitles:nil
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex != actionSheet.cancelButtonIndex) {
                             [mainVC.navigationController popViewControllerAnimated:YES];
                         }
                     }];
}

- (IBAction)changePwd:(id)sender
{

}

//进入省要客业务办理
- (IBAction)doP_VIP:(id)sender
{
    ProvinceVIPViewController *vc = [[ProvinceVIPViewController alloc] init];
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (void) getData
{
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    /*
     [titleDataArray count], @"level",
     [titleDataArray count], @"visit",
     [titleDataArray count], @"type",
     [titleDataArray count], @"scope",
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"summary", @"method",
                           entity.user_id, @"user_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        summaryEntity = [[SummaryEntity alloc]init];
        summaryEntity = [summaryEntity initWithAttributes:entity];
        [self setViewValue];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

#pragma mark -

- (void)getUnfinishedNum
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"getunfinishnum",
                           @"user_type":userInfo.type_id,
                           @"user_id":userInfo.user_id,
                           @"dep_id":userInfo.dep_id};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          id content = entity[@"content"];
                          int num = 0;
                          for (NSString *key in [content allKeys]) {
                              num += [content[key] intValue];
                          }
                          
                          if (num > 0) {
                              
                              [self.waitDoneBtn showBadgeWithStyle:WBadgeStyleNumber
                                                             value:num
                                                     animationType:WBadgeAnimTypeNone];
                              
                              [mainVC.btnAbout showBadgeWithStyle:WBadgeStyleNumber
                                                            value:num
                                                    animationType:WBadgeAnimTypeNone];
                          }else{
                              [self.waitDoneBtn clearBadge];
                              
                              [mainVC.btnAbout clearBadge];
                          }
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

- (void) setViewValue
{
    UserEntity *entity = [UserEntity sharedInstance];
    
    //NSString *city =[[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    LocationEntity *locationEntity = [LocationEntity sharedInstance];
    
    NSString *name = [NSString stringWithFormat:@"%@ (%@)",entity.tel, locationEntity.name];
    labelName.text = name;
    NSString *today = [NSString stringWithFormat:@"%d/%d", [summaryEntity.today_finish intValue], [summaryEntity.today intValue]];
    labelToday.text = today;
    NSString *week = [NSString stringWithFormat:@"%d/%d", [summaryEntity.this_week_finish intValue], [summaryEntity.this_week intValue]];
    labelWeek.text = week;
    NSString *month = [NSString stringWithFormat:@"%d/%d", [summaryEntity.this_month_finish intValue], [summaryEntity.this_month intValue]];
    labelMonth.text = month;
    NSString *lastMonth = [NSString stringWithFormat:@"%d/%d", [summaryEntity.last_month_finish intValue], [summaryEntity.last_month intValue]];
    labelLastMonth.text = lastMonth;
}

- (void) loadData
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [self getUnfinishedNum];
}


@end
