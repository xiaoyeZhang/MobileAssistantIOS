//
//  TaskListViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "TaskListViewController.h"
#import "HMSegmentedControl.h"
#import "MBProgressHUD.h"
#import "CustomerViewController.h"
#import "appDelegate.h"

@interface TaskListViewController ()<UIScrollViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    HMSegmentedControl *segmentedControl1 ;
}

@end

@implementation TaskListViewController
@synthesize viewCondition;
@synthesize labelStatus, labelCompany;
@synthesize compEntity;
@synthesize state;
@synthesize currentVC;
@synthesize background;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"拜访任务";
    [self select_logmodel:NSStringFromClass([self class])];
    
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
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
    [nextButton addTarget:self action:@selector(doSearchByCondition:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"筛选" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
    NSMutableArray *titles = [[NSMutableArray alloc] initWithArray:@[@"今  日", @"本  周", @"本  月",@"全  部"]];
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
//    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
    [segmentedControl1 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    segmentedControl1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl1 addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
    
    [self loadListView];
    [self.slideSwitchView buildUI];
    
    [self.view addSubview:viewCondition];
    viewCondition.frame = CGRectMake(320, 0, 200, 300);
    state = @"-99";
    
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.taskListVC = self;
    
    background.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"TaskListViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"TaskListViewController"];
    [self.slideSwitchView selectIndex:segmentedControl1.selectedSegmentIndex annimation:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)change{
    [self.slideSwitchView selectIndex:segmentedControl1.selectedSegmentIndex];
    //    [self.slideSwitchView setUserSelectedChannelID:segmentedControl1.selectedSegmentIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectByCondition:(id)sender
{
}

-(void)loadListView{
    
    self.vc1 = [[SUNListViewController alloc] initWithNibName:@"SUNListViewController" bundle:nil];
    self.vc1.title = @"今日任务";
    self.vc1.pressType = Press_1;
    
    self.vc2 = [[SUNListViewController alloc] initWithNibName:@"SUNListViewController" bundle:nil];
    self.vc2.title = @"本周任务";
    self.vc2.pressType = Press_2;
    
    self.vc3 = [[SUNListViewController alloc] initWithNibName:@"SUNListViewController" bundle:nil];
    self.vc3.title = @"本月任务";
    self.vc3.pressType = Press_3;
    
    self.vc4 = [[SUNListViewController alloc] initWithNibName:@"SUNListViewController" bundle:nil];
    self.vc4.title = @"全部任务";
    self.vc4.pressType = Press_4;
    
    self.vc1.parentViewController = self;
    self.vc2.parentViewController = self;
    self.vc3.parentViewController = self;
    self.vc4.parentViewController = self;
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 4;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    } else if (number == 3) {
        return self.vc4;
    } else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    SUNListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else if (number == 1) {
        vc = self.vc2;
    } else if (number == 2) {
        vc = self.vc3;
    } else if (number == 3) {
        vc = self.vc4;
    }
    currentVC = vc;
    vc.state = state;
    vc.compEntity = compEntity;
    [vc viewDidCurrentView];
    segmentedControl1.selectedSegmentIndex = number;
}

//
- (IBAction)doSearchByCondition:(id)sender
{
    viewCondition.frame = CGRectMake(100, 0, 220, self.view.frame.size.height);
    background.hidden = NO;
}

- (IBAction)doHideSearchView:(id)sender
{
    viewCondition.frame = CGRectMake(320, 0, 220, self.view.frame.size.height);
    background.hidden = YES;
}

- (IBAction)doComfirm:(id)sender
{
    currentVC.state = state;
    currentVC.compEntity = compEntity;
    [currentVC.mutableArrayData removeAllObjects];
    [currentVC viewDidCurrentView];
    viewCondition.frame = CGRectMake(320, 0, 220, self.view.frame.size.height);
    
    background.hidden = YES;
}

- (IBAction)doReset:(id)sender
{
    labelStatus.text = @"全部";
    state = @"100";
    
    labelCompany.text = @"全部";
    CompEntity *entity = [[CompEntity alloc] init];
    entity.name = @"全部";
    entity.company_id=@"0";
    compEntity = entity;
}

- (IBAction)doSelectCompany:(id)sender
{
    CustomerViewController *vc = [[CustomerViewController alloc]init];
    vc.enter_type = 1;
    vc.tlVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) setCustomerValue:(CompEntity *)ex
{
    compEntity = ex;
    labelCompany.text = compEntity.name;
}

- (IBAction)doSelectStatus1:(id)sender
{
    labelStatus.text = @"全部";
    state = @"-99";
}
- (IBAction)doSelectStatus2:(id)sender
{
    labelStatus.text = @"待执行";
    state = @"0";
}
- (IBAction)doSelectStatus3:(id)sender
{
    labelStatus.text = @"填纪要";
    state = @"1";
}
- (IBAction)doSelectStatus4:(id)sender
{
    labelStatus.text = @"已完成";
    state = @"2";
}
- (IBAction)doSelectStatus5:(id)sender
{
    labelStatus.text = @"已撤销";
    state = @"-1";
}

@end
