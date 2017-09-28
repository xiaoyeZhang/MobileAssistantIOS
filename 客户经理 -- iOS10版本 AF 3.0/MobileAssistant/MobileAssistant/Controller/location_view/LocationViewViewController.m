//
//  LocationViewViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "LocationViewViewController.h"
#import "Information_visit_listEntity.h"
#import "MBProgressHUD.h"
#import "BasicMapAnnotation.h"
#import "ViewCondition.h"
#import "ScreenHeadView.h"
#import "UserTaskListTableViewCell.h"

@interface LocationViewViewController ()<BMKMapViewDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayCustomerTemp;
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    ViewCondition *ViewConditio;
    NSArray *sec_nameArr;
    ScreenHeadView *Headview;
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
}
@end

@implementation LocationViewViewController

@synthesize labelStatus;
@synthesize time_type;
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实时定位查看";
    
    userEntity = [UserEntity sharedInstance];
    
    arrayCustomerTemp = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"筛选"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.Map_View.frame.size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    
    //设置地图缩放级别
    [mapView setZoomLevel:12];
    
    [self.Map_View addSubview:mapView];
    mapView.showMapScaleBar=NO;
//    mapView.mapScaleBarPosition=CGPointMake(3, self.view.frame.size.height-64);
    mapView.delegate=self;
    mapView.showsUserLocation = NO;//先关闭显示的定位图层

//    _viewCondition.frame = CGRectMake(SCREEN_WIDTH, 0, 200, self.view.frame.size.height);
//    
//    [self.view addSubview:_viewCondition];

    
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
    
    time_type = @"0";
    
    [self getReal_timeData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
//                           @"dep_id":userEntity.dep_id
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
            
            
            [mapView removeAnnotations:mapView.annotations];
            
            if (arrayCustomerTemp.count > 0) {
                [self setAnnotionsWithList:arrayCustomerTemp];
                
                Information_visit_listEntity *entity = [arrayCustomerTemp firstObject];
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake([entity.lat doubleValue], [entity.lont doubleValue]);
                [mapView setCenterCoordinate:center animated:YES];
                
                self.personLadbel.text = entity.company_name;
                self.person_name.text = [NSString stringWithFormat:@"姓名：%@",entity.user_name];
                
                self.person_time.text = [NSString stringWithFormat:@"时间：%@",entity.create_time];
                self.person_address.text = [NSString stringWithFormat:@"地址：%@",entity.baidu_addr];
                self.person_loction.text = [NSString stringWithFormat:@"经度：%@   纬度：%@",entity.lont,entity.lat];
            }else{

                CLLocationCoordinate2D center = CLLocationCoordinate2DMake(26.653667, 106.632716);
                [mapView setCenterCoordinate:center animated:YES];

            }
            
        }
        else
        {
            
            
        }
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
    
}

-(void)setAnnotionsWithList:(NSArray *)list
{
    
    for (Information_visit_listEntity *entity in list) {

        NSNull *nullLat = (NSNull *)entity.lat;
        if (nullLat == [NSNull null]) {
            continue;
        }
        NSNull *nullLon = (NSNull *)entity.lont;
        if (nullLon == [NSNull null]) {
            continue;
        }
        
        CLLocationDegrees latitude = [entity.lat doubleValue];
        CLLocationDegrees longitude = [entity.lont doubleValue];
        
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];

        annotation.coordinate = location;
        annotation.title = entity.user_name;
        annotation.subtitle = [NSString stringWithFormat:@"time=%@;address=%@;company_name= %@;longitude=%@;latitude=%@",entity.create_time,entity.baidu_addr,entity.company_name,entity.lont,entity.lat];
        [mapView addAnnotation:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.image=[UIImage imageNamed:@"a"];
        newAnnotationView.canShowCallout=NO;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    
    NSArray *imagesNameArr = [view.annotation.subtitle componentsSeparatedByString:@";"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < imagesNameArr.count; i++) {
        
        if ([imagesNameArr[i] rangeOfString:@"="].location != NSNotFound){
            NSArray *arr = [imagesNameArr[i] componentsSeparatedByString:@"="];
            
            [dic setObject:arr[1] forKey:arr[0]];
        }
        
    }
    
    self.personLadbel.text = [dic objectForKey:@"company_name"];
    self.person_name.text = [NSString stringWithFormat:@"姓名：%@",view.annotation.title];
    
    self.person_time.text = [NSString stringWithFormat:@"时间：%@",[dic objectForKey:@"time"]];
    self.person_address.text = [NSString stringWithFormat:@"地址：%@",[dic objectForKey:@"address"]];
    self.person_loction.text = [NSString stringWithFormat:@"经度：%@   纬度：%@",[dic objectForKey:@"longitude"],[dic objectForKey:@"latitude"]];

    
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"deselect");
}

- (void)submitBtnClicked:(id)sender
{
    ViewConditio.frame = CGRectMake(100, 0, 220, self.view.frame.size.height);
}

- (IBAction)doHideSearchView:(id)sender
{
    ViewConditio.frame = CGRectMake(SCREEN_WIDTH, 0, 220, self.view.frame.size.height);

    [self SingleTop:nil];
    
}

- (IBAction)doComfirm:(id)sender
{
    
    ViewConditio.frame = CGRectMake(SCREEN_WIDTH, 0, 220, self.view.frame.size.height);
    
    self.personLadbel.text = @"暂无";
    self.person_name.text = [NSString stringWithFormat:@"姓名：无"];
    
    self.person_time.text = [NSString stringWithFormat:@"时间：无"];
    self.person_address.text = [NSString stringWithFormat:@"地址：无"];
    self.person_loction.text = [NSString stringWithFormat:@"经度：无   纬度：无"];
    
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
}
- (IBAction)doSelectStatus3:(id)sender
{
    labelStatus.text = @"本周";
    time_type = @"3";
}
- (IBAction)doSelectStatus4:(id)sender
{
    labelStatus.text = @"本月";
    time_type = @"4";
}
- (IBAction)doSelectStatus5:(id)sender
{
    labelStatus.text = @"本月";
    time_type = @"4";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        
        return 50;
        
    }
    
    return 0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sec_nameArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Headview = [[[NSBundle mainBundle] loadNibNamed:@"ScreenHeadView" owner:nil options:nil] firstObject];
 
    Headview.titleLbl.text = @"时间段";
    
    Headview.label.text = labelStatus.text;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [Headview addGestureRecognizer:singleRecognizer];//添加一个手势监测
    
    return Headview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    labelStatus.text = sec_nameArr[indexPath.row];
    
    time_type = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    [self SingleTop:nil];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
