//
//  MainViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "MainTableViewCell.h"
#import "UserEntity.h"
#import "AdEntity.h"
#import "NewsViewController.h"
#import "CommonService.h"
#import "AboutViewController.h"
#import "CoustomerMainNewsViewController.h"
#import "LocationEntity.h"
#import "BusinessViewController.h"
#import "ProvinceVIPViewController.h"
#import "UserCenterViewController.h"

#import "MALocationEntity.h"
#import "News_ProvinceVIPViewController.h"
#import "News_ProviceVip_TwoViewController.h"

#import "MainBaseViewController.h"

#import "New_CustiomerViewController.h"

@interface MainViewController ()
{
    int i;
    NSMutableArray *ConfigureArr;
    NSString *ProvinceVIP_State;
    NSArray *MainTableViewArr;
    
    
    NSString *Already_visitedstrCount;
    NSString *Not_visitedstrCount;
    
    NSString *P_StockstrCount;
    NSString *P_BookstrCount;
    NSString *P_BillstrCount;
    NSString *P_MarketingstrCount;
    
}
@property (nonatomic, strong) UserCenterViewController *aboutVC;/*AboutViewController *aboutVC;*/
@property (nonatomic, strong) NewsViewController *newsVC;
@property (nonatomic, strong) CoustomerMainNewsViewController *cmVC;

@property (nonatomic, strong) New_CustiomerViewController *NcVC;
@property (strong, nonatomic) DataSql *db;
@end

@implementation MainViewController

@synthesize scrollView;
@synthesize aboutVC, newsVC, cmVC, NcVC, page;
@synthesize animatedLabel;
@synthesize btnMain,backButton;
@synthesize btnMainText;
@synthesize btnCoustomer;
@synthesize btnCoustomerText;
@synthesize btnNews;
@synthesize btnNewsText;
@synthesize btnAbout;
@synthesize btnAboutText;
@synthesize bottomView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init{
    
    [self getProvinceVIP_state];
    
    return self;
}

- (void)ChangeTitleColor{
        
    NSMutableAttributedString *Already_visitedstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本月已走访任务数 %@ ",Already_visitedstrCount]];
    
    [Already_visitedstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(9, Already_visitedstrCount.length)];
    
    NSMutableAttributedString *Not_visitedstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本月剩余未走访任务数 %@ ",Not_visitedstrCount]];
    
    [Not_visitedstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(11, Not_visitedstrCount.length)];
    
    NSMutableAttributedString *P_Stockstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"终端退库 %@ ",P_StockstrCount]];
    
    [P_Stockstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(5, P_StockstrCount.length)];
    
    NSMutableAttributedString *P_Bookstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"台账登记 %@ ",P_BookstrCount]];
    
    [P_Bookstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(5, P_BookstrCount.length)];
    
    NSMutableAttributedString *P_Billstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开具发票 %@ ",P_BillstrCount]];
    
    [P_Billstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(5, P_BillstrCount.length)];
    
    NSMutableAttributedString *P_Marketingstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"营销方案更改 %@ ",P_MarketingstrCount]];
    
    [P_Marketingstr addAttribute:NSForegroundColorAttributeName value:RGBA(181, 211, 69, 1) range:NSMakeRange(7, P_MarketingstrCount.length)];
 
    self.Already_visitedLabel.attributedText = Already_visitedstr;
    self.Not_visitedLabel.attributedText = Not_visitedstr;
    self.P_StockLabel.attributedText = P_Stockstr;
    self.P_BookLabel.attributedText = P_Bookstr;
    self.P_BillLabel.attributedText = P_Billstr;
    self.P_MarketingLabel.attributedText = P_Marketingstr;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MainTableViewArr = @[@{@"color":@"45, 215, 220",@"icon":@"统一下单业务",@"title":@"统一下单业务",@"message":@"特号办理、台账登记、终端业务等",},
                         @{@"color":@"35, 159, 218",@"icon":@"走访任务系统",@"title":@"走访任务系统",@"message":@"走访任务、走访轨迹、走访情况等",},
                         @{@"color":@"24, 90, 204",@"icon":@"crm",@"title":@"CRM业务办理",@"message":@"集团V网、彩铃、国际漫游等",},
                         @{@"color":@"45, 215, 220",@"icon":@"平台",@"title":@"订单中心",@"message":@"订单需求发起、故障投诉等",},
                         @{@"color":@"45, 215, 220",@"icon":@"在线考试",@"title":@"考试系统",@"message":@"考试、历史试卷、积分排名等",},
                         @{@"color":@"247, 173, 39",@"icon":@"其他",@"title":@"其他资料库",@"message":@"产品资料库、营销活动信息库等",}];
    
    Already_visitedstrCount = @"0";
    Not_visitedstrCount = @"0";
    
    P_StockstrCount = @"0";
    P_BookstrCount = @"0";
    P_BillstrCount = @"0";
    P_MarketingstrCount = @"0";
    
    [self getTask_NumData];
    
    
    [self select_logmodel:NSStringFromClass([self class])];
    
    UserEntity *userInfo = [UserEntity sharedInstance];//[NSKeyedUnarchiver unarchiveObjectWithData:userData];

//    if (userInfo.name.length > 4) {
//        backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
//    }else if(userInfo.name.length == 4){
//        backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//    }else{
//        backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
//    }

    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
    
    backButton.userInteractionEnabled = NO;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"人员icon"] forState:UIControlStateNormal];
    [backButton setTitle:[NSString stringWithFormat:@" %@",userInfo.name] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    //二期整体页面规划
    [self.scrollView addSubview:_MainTableView];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    UIScrollView *WebScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    WebScroller.backgroundColor = RGBA(66, 187, 233, 1);
    WebScroller.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 140);
    WebScroller.pagingEnabled = YES;//整个页面翻页
    WebScroller.showsHorizontalScrollIndicator = NO;
    WebScroller.showsVerticalScrollIndicator = NO;

    [self.MainTableView addSubview:WebScroller];
    
    UIWebView *webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    webView1.userInteractionEnabled = NO;
    
    NSString *url1 = [NSString stringWithFormat:@"http://gzcmm.dayo.net.cn/cmm/charts.php?id=%@",userEntity.user_id];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
    
    [webView1 loadRequest:request1];
    
    
    UIWebView *webView2 = [[UIWebView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 160)];
    webView2.userInteractionEnabled = NO;
    
    NSString *url2 = [NSString stringWithFormat:@"http://gzcmm.dayo.net.cn/cmm/charts1.php?id=%@",userEntity.user_id];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
    
    [webView2 loadRequest:request2];
    
    [WebScroller addSubview:webView1];
    [WebScroller addSubview:webView2];
    
    page = 0;
    [self showMainView];
    aboutVC = [[UserCenterViewController alloc] init];//[[AboutViewController alloc] init];
    newsVC = [[NewsViewController alloc] init];
    cmVC = [[CoustomerMainNewsViewController alloc] init];
    
    NcVC = [[New_CustiomerViewController alloc]init];
    
    aboutVC.view.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 60);
    newsVC.view.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 60);
    cmVC.view.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 60);
    
    NcVC.view.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - 60);    //   首席看管
    
    newsVC.mainVC = self;
    aboutVC.mainVC = self;
    cmVC.mainVC = self;
    NcVC.mainVC = self;  //   首席看管
    
    [self.view addSubview:aboutVC.view];
    [self.view addSubview:newsVC.view];
//    [self.view addSubview:cmVC.view];
    
    [self.view addSubview:NcVC.view];  //   首席看管
    
    aboutVC.view.hidden = YES;
    newsVC.view.hidden = YES;
    cmVC.view.hidden = YES;
    
    NcVC.view.hidden = YES;   //   首席看管
    
    [self getWeatherData];
    [self getLocationData];
    
    [self getUnfinishedNum];
    
    [self getProvinceVIP_state];
    
    if (self.isAutoInP_VIP) {
        [self doProvinceVIP:nil];
    }
    
    if (userEntity.notice.length > 0) {
        
        ALERT_MSG(@"公告",userEntity.notice);
    }
    
    ConfigureArr = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return MainTableViewArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"MainTableViewCell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }

    NSArray *arr = [[MainTableViewArr[indexPath.row]objectForKey:@"color"] componentsSeparatedByString:@","];

    cell.ColorLabel.backgroundColor = RGBCOLOR([arr[0] intValue], [arr[1] intValue], [arr[2] intValue], 1);
    cell.iconImage.image = [UIImage imageNamed:[MainTableViewArr[indexPath.row]objectForKey:@"icon"]];
    cell.titleLabel.text = [MainTableViewArr[indexPath.row]objectForKey:@"title"];
    cell.messageLabel.text = [MainTableViewArr[indexPath.row]objectForKey:@"message"];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([userInfo.type_id intValue]== ROLE_SOCOALCHANNEL) {
        
        if ([[MainTableViewArr[indexPath.row]objectForKey:@"title"] isEqualToString:@"订单中心"]) {
            
            [self goMainBaseViewController:[MainTableViewArr[indexPath.row]objectForKey:@"title"]];
        }
        
    }else{
        
        switch (indexPath.row) {
            case 0:
                [self doProvinceVIP:nil];
                
                break;
                
            case 2:
                
                [self doEnterBusiness:nil];
                
                break;
            case 3:
                //
                //            [self goMainBaseViewController:[MainTableViewArr[indexPath.row]objectForKey:@"title"]];
                //
                //            break;
                
            default:
                [self goMainBaseViewController:[MainTableViewArr[indexPath.row]objectForKey:@"title"]];
                break;
        }

    }
   
}

- (void)toast{
    iToast *toast = [iToast makeText:@"开发中"];
    [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
    [toast setDuration:500];
    [toast show:iToastTypeNotice];
}

- (void)goMainBaseViewController:(NSString *)NameStr{
    
    MainBaseViewController *vc = [[MainBaseViewController alloc]init];
    vc.name = NameStr;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    [MobClick endLogPageView:@"MainViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"MainViewController"];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doNews:(id)sender
{
    page = 2;
    [self showMainView];
}

- (IBAction)doMain:(id)sender
{
    page = 0;
    [self showMainView];
}

- (IBAction)doCoustomerMain:(id)sender
{
    page = 1;
    [self showMainView];
}

- (IBAction)doAbout:(id)sender
{
    page = 3;
    [self showMainView];
}

#pragma mark - CRM业务办理
- (void)doEnterBusiness:(id)sender
{
    BusinessViewController *vc = [[BusinessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - 统一下单业务受理
- (void)doProvinceVIP:(id)sender
{

    if ([ProvinceVIP_State isEqualToString:@"old"]) {
        
        ProvinceVIPViewController *vc = [[ProvinceVIPViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([ProvinceVIP_State isEqualToString:@"new"]){
        
        News_ProviceVip_TwoViewController *vc = [[News_ProviceVip_TwoViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([ProvinceVIP_State isEqualToString:@"close"]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你没有访问权限！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void) showMainView
{
    if (page == 0) {
        self.scrollView.hidden = NO;
        aboutVC.view.hidden = YES;
        newsVC.view.hidden = YES;
        cmVC.view.hidden = YES;
        
        NcVC.view.hidden = YES;   //   首席看管
        
        self.navigationItem.title = @"";
        
        UserEntity *userInfo = [UserEntity sharedInstance];
        
        backButton.alpha = 1;
        
//        if (userInfo.name.length > 4) {
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
//        }else if(userInfo.name.length == 4){
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//        }else{
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
//        }
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
        
        backButton.userInteractionEnabled = NO;
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton setImage:[UIImage imageNamed:@"人员icon"] forState:UIControlStateNormal];
        [backButton setTitle:[NSString stringWithFormat:@" %@",userInfo.name] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        
        [btnMain setBackgroundImage:[UIImage imageNamed:@"tab_hp_press"] forState:UIControlStateNormal];
        [btnAbout setBackgroundImage:[UIImage imageNamed:@"tab_about"] forState:UIControlStateNormal];
        [btnCoustomer setBackgroundImage:[UIImage imageNamed:@"tab_contact"] forState:UIControlStateNormal];
        [btnNews setBackgroundImage:[UIImage imageNamed:@"tab_push"] forState:UIControlStateNormal];
        
        [btnMainText setTitleColor:[UIColor colorWithRed:0.21 green:0.69 blue:0.89 alpha:1] forState:UIControlStateNormal];
        [btnAboutText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnCoustomerText setTitleColor:[UIColor colorWithRed:0.66 green:0.69 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnNewsText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
    } else if (page == 1) {
        self.scrollView.hidden = YES;
        aboutVC.view.hidden = YES;
        newsVC.view.hidden = YES;
        cmVC.view.hidden = NO;
        [cmVC loadData];
        NcVC.view.hidden = NO;   //   首席看管
        
//        self.navigationItem.title = @"客户列表";

        UserEntity *userInfo = [UserEntity sharedInstance];
        
        self.navigationItem.title = @"";

//        if (userInfo.name.length > 4) {
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
//        }else if(userInfo.name.length == 4){
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//        }else{
//            backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
//        }
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
        
        backButton.userInteractionEnabled = NO;
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton setImage:[UIImage imageNamed:@"人员icon"] forState:UIControlStateNormal];
        [backButton setTitle:[NSString stringWithFormat:@" %@",userInfo.name] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;

        [btnMain setBackgroundImage:[UIImage imageNamed:@"tab_hp"] forState:UIControlStateNormal];
        [btnAbout setBackgroundImage:[UIImage imageNamed:@"tab_about"] forState:UIControlStateNormal];
        [btnCoustomer setBackgroundImage:[UIImage imageNamed:@"tab_contact_press"] forState:UIControlStateNormal];
        [btnNews setBackgroundImage:[UIImage imageNamed:@"tab_push"] forState:UIControlStateNormal];
        
        [btnMainText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnAboutText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnCoustomerText setTitleColor:[UIColor colorWithRed:0.21 green:0.69 blue:0.89 alpha:1] forState:UIControlStateNormal];
        [btnNewsText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        
    } else if (page == 2) {
        self.scrollView.hidden = YES;
        aboutVC.view.hidden = YES;
        newsVC.view.hidden = NO;
        cmVC.view.hidden = YES;
        NcVC.view.hidden = YES;  //   首席看管
        [newsVC reloadNewsData];
        
        self.navigationItem.title = @"公告";
        
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
        
        UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = ButtonItem;
        
        [btnMain setBackgroundImage:[UIImage imageNamed:@"tab_hp"] forState:UIControlStateNormal];
        [btnAbout setBackgroundImage:[UIImage imageNamed:@"tab_about"] forState:UIControlStateNormal];
        [btnCoustomer setBackgroundImage:[UIImage imageNamed:@"tab_contact"] forState:UIControlStateNormal];
        [btnNews setBackgroundImage:[UIImage imageNamed:@"tab_push_press"] forState:UIControlStateNormal];
        
        [btnMainText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnAboutText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnCoustomerText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnNewsText setTitleColor:[UIColor colorWithRed:0.21 green:0.69 blue:0.89 alpha:1] forState:UIControlStateNormal];
        
        
    } else if (page == 3) {
        self.scrollView.hidden = YES;
        aboutVC.view.hidden = NO;
        newsVC.view.hidden = YES;
        cmVC.view.hidden = YES;
        NcVC.view.hidden = YES;  //   首席看管
        [aboutVC loadData];
        
        self.navigationItem.title = @"我的";
        
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
        
        UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = ButtonItem;
        
        [btnMain setBackgroundImage:[UIImage imageNamed:@"tab_hp"] forState:UIControlStateNormal];
        [btnAbout setBackgroundImage:[UIImage imageNamed:@"tab_about_press"] forState:UIControlStateNormal];
        [btnCoustomer setBackgroundImage:[UIImage imageNamed:@"tab_contact"] forState:UIControlStateNormal];
        [btnNews setBackgroundImage:[UIImage imageNamed:@"tab_push"] forState:UIControlStateNormal];
        
        [btnMainText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnAboutText setTitleColor:[UIColor colorWithRed:0.21 green:0.69 blue:0.89 alpha:1] forState:UIControlStateNormal];
        [btnCoustomerText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        [btnNewsText setTitleColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] forState:UIControlStateNormal];
        
    }
}

- (void) getLocationData
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.area_id, @"area_id",
                           @"updatelocation", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState= [NSString stringWithFormat:@"%d", [state intValue]];
        LocationEntity *locationEntity = [LocationEntity sharedInstance];
        if ([strState isEqualToString:@"1"] == YES) {
            NSArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                locationEntity = [locationEntity initWithAttributes:attributes];
            }
        } else {
            locationEntity.name = @"苏州";
        }
        
//        self.title = locationEntity.name;
    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

- (void) getWeatherData
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.area_id, @"area",
                           @"area", @"method", nil];
    
    [service getWeatherNetWorkData:param  Successed:^(id entity) {
        NSString * strWeather = entity;
        NSArray *weather = [strWeather componentsSeparatedByString:@"@"];
        [self.animatedLabel animateWithWords:weather forDuration:1.0f];
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

- (void)locationUpdatedFailed:(int)errorCode ErrorMessage:(NSString *)message
{
    self.title = @"";
}

#pragma mark - 走访情况 ， 待办事项 数据
- (void) getTask_NumData
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
                           @"home_page", @"method",
                           entity.type_id, @"user_type",
                           entity.user_id, @"user_id",
                           entity.dep_id, @"dep_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            NSArray *pageArr = [[entity valueForKey:@"content"] componentsSeparatedByString:@","];
            
            Already_visitedstrCount = pageArr[0];
            Not_visitedstrCount = pageArr[1];
            
            P_StockstrCount = pageArr[2];
            P_BookstrCount = pageArr[3];
            P_BillstrCount = pageArr[4];
            P_MarketingstrCount = pageArr[5];
            
            [self ChangeTitleColor];
        }

    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

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
                              
                              [self.btnAbout showBadgeWithStyle:WBadgeStyleNumber
                                                                 value:num
                                                         animationType:WBadgeAnimTypeNone];
                          }else{
                              
                              [self.btnAbout clearBadge];
                          }
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

-(void)getModuleList{
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{
                            @"method":@"get_module_list",
                            @"user_id":userEntity.user_id,
                            @"dep_id":userEntity.dep_id,
                            };
    
    
    [service getNetWorkData:dict1 Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"]) {
            
            
        }else{
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            int num = 0;
            for (NSDictionary* attributes in array) {
                num += [attributes[@"count"] intValue];
            }
            if (num > 0) {
                
                [self.btnAbout showBadgeWithStyle:WBadgeStyleNumber
                                            value:num
                                    animationType:WBadgeAnimTypeNone];
            }else{
                
                [self.btnAbout clearBadge];
            }
//            for (NSDictionary* attributes in array) {
//                News_ProvinceVipEntity *entity = [[News_ProvinceVipEntity alloc] init];
//                entity = [entity initWithAttributes:attributes];
//                [self.arrayCutomer addObject:entity];
//            }
            
            
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
    
}

- (void)getProvinceVIP_state
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"get_business_config",
                           @"dep_id":userInfo.dep_id};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          
                          ProvinceVIP_State = entity[@"content"];
                          
                          NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
                          
                          [locationDefaults setObject:ProvinceVIP_State forKey:@"ProvinceVIP_State"];
                          
                          [locationDefaults synchronize];
                      
                          if ([ProvinceVIP_State isEqualToString:@"new"]) {
                              
                              [self getModuleList];
                              
                          }
                      }
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [self getTask_NumData];
}

@end




