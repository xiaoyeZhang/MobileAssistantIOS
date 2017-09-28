//
//  InformationViewViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "InformationViewViewController.h"
#import "PNChart.h"
#import "UIColor+Random.h"
#import "InformationTableViewCell.h"
#import "InformationHeadView.h"
#import "Information_visit_listEntity.h"
#import "MBProgressHUD.h"
#import "ViewCondition.h"
#import "ScreenHeadView.h"
#import "UserTaskListTableViewCell.h"

@interface InformationViewViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *background;
    UserEntity *userEntity;
    PNPieChart *unfinishedChart;
    PNPieChart *finishedChart;
    NSMutableArray *arrayCustomerTemp;
    NSMutableDictionary *real_timeDic;
    UIView *unfinishedLegend;
    UIView *finishedLegend;
    MBProgressHUD *HUD;
    NSString *dep_id;
    
    ViewCondition *ViewConditio;
    NSArray *sec_nameArr;
    ScreenHeadView *Headview;
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
    
    NSString *swipeType;
}

@property(nonatomic, strong) NSArray *itemsArr;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end


@implementation InformationViewViewController

@synthesize labelStatus;
@synthesize time_type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实时信息查看";
    
    userEntity = [UserEntity sharedInstance];
    
    arrayCustomerTemp = [NSMutableArray array];
    real_timeDic = [NSMutableDictionary dictionary];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"筛选"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.25;
    
    [self.view addSubview:background];
    
//    _viewCondition.frame = CGRectMake(SCREEN_WIDTH, 0, 200, self.view.frame.size.height);
//    
//    [self.view addSubview:_viewCondition];

    [self addTapGesture];
    
    sec_nameArr = [NSArray arrayWithObjects:@"全部",@"今日",@"本周",@"本月", nil];
    
    labelStatus.text = @"全部";
    
    ViewConditio = [[[NSBundle mainBundle] loadNibNamed:@"ViewCondition" owner:nil options:nil] firstObject];
    
    ViewConditio.frame = CGRectMake(SCREEN_WIDTH, 0, 200, self.view.frame.size.height);
    
    ViewConditio.ConditionTabelView.delegate = self;
    ViewConditio.ConditionTabelView.dataSource = self;
    ViewConditio.ConditionTabelView.tableFooterView = [UIView new];
    [ViewConditio.HideSearchBtn addTarget:self action:@selector(doHideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [ViewConditio.ResetBtn addTarget:self action:@selector(doReset:) forControlEvents:UIControlEventTouchUpInside];
    [ViewConditio.ComfirmBtn addTarget:self action:@selector(doComfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ViewConditio];

    
    background.hidden = YES;
    
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHideSearchView:)];
    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [background addGestureRecognizer:singleRecognizer];//添加一个手势监测

    swipeType = @"1";
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.tableView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.tableView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    time_type = @"0";
    
    dep_id = @"1001001";
    
    [self ChartView];
    
    [self getReal_timeData];

}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == ViewConditio.ConditionTabelView) {
        
        return sec_nameArr.count;
        
    }
    
    return arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == ViewConditio.ConditionTabelView) {
        
        return 30;
        
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == ViewConditio.ConditionTabelView) {
        
        if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
            
            return 50;
            
        }
        
        return 0;
        
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == ViewConditio.ConditionTabelView) {
        
        Headview = [[[NSBundle mainBundle] loadNibNamed:@"ScreenHeadView" owner:nil options:nil] firstObject];
        
        Headview.titleLbl.text = @"时间段";
        
        Headview.label.text = labelStatus.text;
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
        singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
        [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
        [Headview addGestureRecognizer:singleRecognizer];//添加一个手势监测
        
        return Headview;
        
    }else{
        InformationHeadView *view = [[[NSBundle mainBundle] loadNibNamed:@"InformationHeadView" owner:nil options:nil] firstObject];
        view.backgroundColor = RGBA(247, 247, 247, 1);
        
        if ([swipeType isEqualToString:@"1"]) {
            view.LabelThree.text = @"集团名称";
        }else{
            view.LabelThree.text = @"拜访内容";
        }
        
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == ViewConditio.ConditionTabelView) {
        
        static NSString *taskIdentifier = @"UserTaskListTableViewCell";
        
        UserTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:taskIdentifier owner:nil options:nil] firstObject];
            cell.separatorInset = UIEdgeInsetsZero;
            cell.clipsToBounds = YES;
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLbl.text = sec_nameArr[indexPath.row];
        cell.titleLbl.textColor = [UIColor blackColor];
        cell.subTitleLbl.alpha = 0;
        
        return cell;
    }else{

        static NSString *identifier = @"InformationTableViewCell";
        InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        Information_visit_listEntity *entity = arrayCustomerTemp[indexPath.row];
        
        cell.nameLabel.text = entity.user_name;
        cell.stateLabel.text = @"已完成";
        
        
        if ([swipeType isEqualToString:@"1"]) {
            cell.addressLabel.text = entity.company_name;

        }else{
            cell.addressLabel.text = entity.title;
        }
        
        return cell;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == ViewConditio.ConditionTabelView) {
        labelStatus.text = sec_nameArr[indexPath.row];
        
        time_type = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        [self SingleTop:nil];
    }

}

- (IBAction)change_State_Btn:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        dep_id = @"1001001";
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.Btn1 setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.Btn2 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            [self.Btn3 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
        }];
        
    }else if (sender.tag == 2){

        dep_id = @"1001002";
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.Btn1 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            [self.Btn2 setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.Btn3 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            
        }];
    }else if (sender.tag == 3){

        dep_id = @"1001003";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.Btn1 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            [self.Btn2 setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            [self.Btn3 setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
        }];
    }else{
        
    }
    
    [self getReal_timeData];
}

- (void)getReal_timeData{
    
//    time_type:0,1,2,3,4  分别表示当月（默认）、全部、今日、本周、本月
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"real_time",
                           @"time_type":time_type,
                           @"user_id":userEntity.user_id,
                           @"dep_id":dep_id
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *states = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [states intValue]];
        
        [arrayCustomerTemp removeAllObjects];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"visit_list"];
            
            for (NSDictionary* attributes in array) {
                Information_visit_listEntity *entity = [[Information_visit_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayCustomerTemp addObject:entity];
            }

            if ([[[entity objectForKey:@"content"] objectForKey:@"nums"] count] >= 5) {
                self.Call_todayLabel.text = [NSString stringWithFormat:@"今日拜访：%@",[[entity objectForKey:@"content"] objectForKey:@"nums"][0]];
                self.Visit_weekLabel.text = [NSString stringWithFormat:@"本周拜访：%@",[[entity objectForKey:@"content"] objectForKey:@"nums"][1]];
                self.Visit_last_weekLabel.text = [NSString stringWithFormat:@"上周拜访：%@",[[entity objectForKey:@"content"] objectForKey:@"nums"][2]];
                self.Visit_month.text = [NSString stringWithFormat:@"本月拜访：%@",[[entity objectForKey:@"content"] objectForKey:@"nums"][3]];
                self.Last_month_visit.text = [NSString stringWithFormat:@"上月拜访：%@",[[entity objectForKey:@"content"] objectForKey:@"nums"][4]];

            }
            
            if (real_timeDic.count == 0) {
                
                real_timeDic = [entity objectForKey:@"content"];

                [self ChartView];
            
            }
            
        }
        else
        {
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
    
}

- (void)ChartView{
    
    if (unfinishedChart) {
        [unfinishedChart removeFromSuperview];
        unfinishedChart = nil;
    }
    if (finishedChart) {
        [finishedChart removeFromSuperview];
        finishedChart = nil;
    }
    if (unfinishedLegend) {
        [unfinishedLegend removeFromSuperview];
        unfinishedLegend = nil;
    }
    if (finishedLegend) {
        [finishedLegend removeFromSuperview];
        finishedLegend = nil;
    }
    
    NSMutableArray *unfinishedItems = [NSMutableArray array];
    
    _itemsArr = @[@"要客一部",@"要客二部",@"要客三部"];
    
    //    for (DepListModel *model in self.itemsArr) {
    for (int i = 0; i < _itemsArr.count ; i++) {
        
        PNPieChartDataItem *unfinishedItem;
        
        if ([real_timeDic[@"pie"] count] > 2) {
           unfinishedItem = [PNPieChartDataItem dataItemWithValue:[real_timeDic[@"pie"][i] intValue]
                                                                                 color:[UIColor randomColor]
                                                                           description:[NSString stringWithFormat:@"%@",_itemsArr[i]]];


        }else{
            unfinishedItem = [PNPieChartDataItem dataItemWithValue:0
                                                                                 color:[UIColor randomColor]
                                                                           description:[NSString stringWithFormat:@"%@",_itemsArr[i]]];
        }
        
        [unfinishedItems addObject:unfinishedItem];
        
    }
    
    
    unfinishedChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.Last_month_visit.frame.size.width + self.Last_month_visit.frame.origin.x + 30, 28, _CenterView.bounds.size.height - 40, _CenterView.bounds.size.height - 40)
                                                  items:unfinishedItems];
    unfinishedChart.descriptionTextColor = [UIColor whiteColor];
    unfinishedChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    unfinishedChart.showOnlyValues = YES;
    unfinishedChart.legendFontColor = [UIColor blackColor];
    
    [unfinishedChart strokeChart];
    [_CenterView addSubview:unfinishedChart];
    
    
    unfinishedLegend = [unfinishedChart getLegendWithMaxWidth:100];
    [unfinishedLegend setFrame:CGRectMake(unfinishedChart.frame.size.width + unfinishedChart.frame.origin.x + 10, 28, unfinishedLegend.frame.size.width, unfinishedLegend.frame.size.height)];
    [_CenterView addSubview:unfinishedLegend];

}
- (void)submitBtnClicked:(id)sender
{
    ViewConditio.frame = CGRectMake(100, 0, 220, self.view.frame.size.height);
    background.hidden = NO;
}

- (IBAction)doHideSearchView:(id)sender
{
    ViewConditio.frame = CGRectMake(SCREEN_WIDTH, 0, 220, self.view.frame.size.height);
    background.hidden = YES;
    
    [self SingleTop:nil];
    
}

- (IBAction)doComfirm:(id)sender
{

    ViewConditio.frame = CGRectMake(SCREEN_WIDTH, 0, 220, self.view.frame.size.height);
    
    background.hidden = YES;
    
    [self getReal_timeData];
}
// time_type:0,1,2,3,4  分别表示当月（默认）、全部、今日、本周、本月
- (IBAction)doReset:(id)sender
{
    labelStatus.text = @"全部";
    time_type = @"1";
    
    [self SingleTop:nil];
}

- (IBAction)doSelectStatus1:(id)sender
{
    labelStatus.text = @"全部";
    time_type = @"1";
}
- (IBAction)doSelectStatus2:(id)sender
{
    labelStatus.text = @"今日";
    time_type = @"2";
    
    [self getReal_timeData];
    
}
- (IBAction)doSelectStatus3:(id)sender
{
    labelStatus.text = @"本周";
    time_type = @"3";
    
    [self getReal_timeData];
}
- (IBAction)doSelectStatus4:(id)sender
{
    labelStatus.text = @"本月";
    time_type = @"4";
    
    [self getReal_timeData];
}
- (IBAction)doSelectStatus5:(id)sender
{
    labelStatus.text = @"本月";
    time_type = @"4";
    
    [self getReal_timeData];
}
- (IBAction)doSelectStatus6:(id)sender
{
    labelStatus.text = @"上周";
    time_type = @"5";
    
    [self getReal_timeData];
}
- (IBAction)doSelectStatus7:(id)sender
{
    labelStatus.text = @"上月";
    time_type = @"6";
    
    [self getReal_timeData];
}

- (void)SingleTop:(UITapGestureRecognizer *)recognizer{
    
    Headview = [[[NSBundle mainBundle] loadNibNamed:@"ScreenHeadView" owner:nil options:nil] firstObject];
    
    NSInteger didsection = recognizer.view.tag;
    if (!selectedDic) {
        selectedDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)didsection];
    
    if (![selectedDic objectForKey:key]) {
        [selectedDic setObject:@"1" forKey:key];
        Headview.down_rightImage.image = [UIImage imageNamed:@"xiala"];
    }else{
        [selectedDic removeObjectForKey:key];
        Headview.down_rightImage.image = [UIImage imageNamed:@"right"];
    }
    [ViewConditio.ConditionTabelView reloadSections:[NSIndexSet indexSetWithIndex:didsection] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

- (void)addTapGesture{
    self.Call_todayLabel.userInteractionEnabled = YES;
    self.Visit_weekLabel.userInteractionEnabled = YES;
    self.Visit_last_weekLabel.userInteractionEnabled = YES;
    self.Visit_month.userInteractionEnabled = YES;
    self.Last_month_visit.userInteractionEnabled = YES;
    
    //今日
    UITapGestureRecognizer *Call_todaySingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectStatus2:)];
    Call_todaySingleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [Call_todaySingleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [self.Call_todayLabel addGestureRecognizer:Call_todaySingleRecognizer];//添加一个手势监测
    //本周
    UITapGestureRecognizer *Visit_weekSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectStatus3:)];
    Visit_weekSingleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [Visit_weekSingleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [self.Visit_weekLabel addGestureRecognizer:Visit_weekSingleRecognizer];//添加一个手势监测
    //上周
    UITapGestureRecognizer *Visit_last_weekSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectStatus6:)];
    Visit_last_weekSingleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [Visit_last_weekSingleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [self.Visit_last_weekLabel addGestureRecognizer:Visit_last_weekSingleRecognizer];//添加一个手势监测
    //本月
    UITapGestureRecognizer *Visit_monthSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectStatus4:)];
    Visit_monthSingleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [Visit_monthSingleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [self.Visit_month addGestureRecognizer:Visit_monthSingleRecognizer];//添加一个手势监测
    //上月
    UITapGestureRecognizer *Last_month_visitSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelectStatus7:)];
    Last_month_visitSingleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [Last_month_visitSingleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [self.Last_month_visit addGestureRecognizer:Last_month_visitSingleRecognizer];//添加一个手势监测
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
//        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
//        self.swipeLabel.text = @"尼玛的, 你在往左边跑啊....";
        
        if ([swipeType isEqualToString:@"1"]) {
            
            swipeType = @"-1";
            
            [self.tableView reloadData];
            
        }else{
            

        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
//        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
//        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
//        self.swipeLabel.text = @"尼玛的, 你在往右边跑啊....";
        
        if ([swipeType isEqualToString:@"1"]) {

            
        }else{
            swipeType = @"1";
            
            [self.tableView reloadData];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
