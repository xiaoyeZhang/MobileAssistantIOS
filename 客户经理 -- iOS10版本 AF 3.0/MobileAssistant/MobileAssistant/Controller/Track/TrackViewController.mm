//
//  TrackViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-8.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "TrackViewController.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "VisiteTask.h"

@interface TrackViewController ()<MBProgressHUDDelegate>
{
    BMKPointAnnotation* pointAnnotation;
    BMKAnnotationView* newAnnotation;
    
    MBProgressHUD *HUD;
}
@end

@implementation TrackViewController
@synthesize mapView;
@synthesize annotationArray;
@synthesize mutableArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"拜访轨迹";
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    mutableArray = [[NSMutableArray alloc] init];
    
    mapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //设置地图缩放级别
    [mapView setZoomLevel:12];

    
    [self.view addSubview:mapView];
    mapView.showMapScaleBar=YES;
    mapView.mapScaleBarPosition=CGPointMake(3, self.view.frame.size.height-64);
    mapView.delegate=self;
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    //[mapView setCenterCoordinate:CLLocationCoordinate2DMake([@"28.123034" doubleValue],[@"113.014507" doubleValue]) animated:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self loadDataTask];
    
    //[HUD showWhileExecuting:@selector(loadDataTask) onTarget:self withObject:nil animated:YES];
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
- (void)loadDataTask {
    // Do something usefull in here instead of sleeping ...
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    //{{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"lastMonth=%@",lastMonth);
    NSString * strLastMonth = [dateformat stringFromDate:lastMonth];
    NSString * strLasWeek = [dateformat stringFromDate:lastWeek];
    //}}
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"getTraceTask", @"method",
                           entity.type_id, @"type_id",
                           entity.user_id, @"actor_id",
                           strLastMonth, @"time",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
        }
        else {
            NSMutableArray *array = [entity objectForKey:@"content"];
            NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
            
            for (NSDictionary* attributes in array) {
                VisiteTask *entity = [[VisiteTask alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayTemp addObject:entity];
            }
            mutableArray = [NSMutableArray arrayWithArray:arrayTemp];
            [self setAnnotionsWithList:mutableArray];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];

}

-(void)setAnnotionsWithList:(NSArray *)list
{
    for (VisiteTask *entity in list) {
        int num = [entity.visit_id intValue];
        NSArray *listarray = nil;//[dic objectForKey:@"array"];
        
        NSNull *nullLat = (NSNull *)entity.lat;
        if (nullLat == [NSNull null]) {
            continue;
        }
        NSNull *nullLon = (NSNull *)entity.lont;
        if (nullLon == [NSNull null]) {
            continue;
        }
        
        CLLocationDegrees latitude=[entity.lat doubleValue];
        CLLocationDegrees longitude=[entity.lont doubleValue];
        
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        NSString *type = entity.state;
        //        BMKCoordinateRegion region=BMKCoordinateRegionMakeWithDistance(location, spandelta, spandelta);
        //        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
        //        [mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude
                                                                         andLongitude:longitude
                                                                                 Type:type
                                                                              VisiteTask:entity
                                                                                 Name:entity.name
                                                                          BigImageUrl:@""
                                                                        andInfoNumber:num
                                                                             andArray:listarray];
        
        [mapView addAnnotation:annotation];
    }
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    static NSString *indentifier=@"basicMapAnnotation";
    if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        BMKAnnotationView *annView=[mapView dequeueReusableAnnotationViewWithIdentifier:indentifier];
        if (!annView) {
            annView=[[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:indentifier];
            
        }
        annView.canShowCallout=NO;//在点击大头针的时候会弹出那个黑框框
        annView.draggable=NO;//这里决定annView能不能拖动，应该经常会把它设为NO
        
        BasicMapAnnotation *  basic = annotation;
        if ([basic.type isEqualToString:@"1"] == YES) {
            annView.image=[UIImage imageNamed:@"a"];
        } else if ([basic.type isEqualToString:@"2"] == YES) {
            annView.image=[UIImage imageNamed:@"b"];
        }
        
        for (UIView *view in [annView subviews]) {
            [view removeFromSuperview];
        }
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(basic.latitude,basic.longitude) animated:YES];
        return annView;
    }
    return nil;
    
}
////添加标注
//- (void)addPointAnnotation
//{
//    pointAnnotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    pointAnnotation.coordinate = coor;
//    pointAnnotation.title = @"test";
//    pointAnnotation.subtitle = @"此Annotation可拖拽!";
//    [mapView addAnnotation:pointAnnotation];
//
//}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    BasicMapAnnotation *basicAnnotation=(BasicMapAnnotation *)view.annotation;
    NSString *strContent = [NSString stringWithFormat:@"执行人：%@\r\n客户：%@\r\n联系人：%@ \r\n拜访时间：%@ ",
                            basicAnnotation.visiteTask.actor_name,
                            basicAnnotation.visiteTask.company_name,
                            basicAnnotation.visiteTask.name,
                            basicAnnotation.visiteTask.time];
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:basicAnnotation.visiteTask.title contentText:strContent leftButtonTitle:nil rightButtonTitle:@"确定" TextAlignment:0 FontSize:13.0f];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"deselect");
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
