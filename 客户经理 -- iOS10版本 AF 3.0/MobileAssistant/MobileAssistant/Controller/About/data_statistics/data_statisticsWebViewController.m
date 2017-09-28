//
//  data_statisticsWebViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "data_statisticsWebViewController.h"
#import "MBProgressHUD.h"
#import "Payment_arrears_listViewController.h"
#import "Utilies.h"

//#define WEBURL @"http://sw.avatek.com.cn/gzcms/"
#define WEBURL @"http://gzcmm.dayo.net.cn/cmm/"

@interface data_statisticsWebViewController ()<NIDropDownDelegate,MBProgressHUDDelegate,UIWebViewDelegate>
{
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    UIButton *dataBtn;
    UIButton *One_Btn;
    UIButton *Two_Btn;
    UIButton *three_Btn;
    NSInteger type;
    NSString *select_dep_id_two;
    NSString *select_dep_id_three;
    NSString *dep_id;
}
@property (strong, nonatomic) NSMutableArray *cateArr;
@property (strong, nonatomic) NSArray *searchArr;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation data_statisticsWebViewController

@synthesize dropDown;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userEntity = [UserEntity sharedInstance];
    
    dep_id = userEntity.dep_id;
    
    self.cateArr = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = self.name;
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setFISTdata];
    
    [self setHeadView];
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {

            type = 3;
    }else{
            type = 0;
    }
    


//    [self get_search_list:nil];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)get_search_list:(UIButton *)sender{
    
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@"get_search_list" forKey:@"method"];
//    [dic setObject:userEntity.type_id forKey:@"type_id"];
    [dic setObject:userEntity.user_id forKey:@"user_id"];
    
    
    if (sender.tag == 1) {
        [dic setObject:userEntity.dep_id forKey:@"select_dep_id"];
        [dic setObject:@"1" forKey:@"level"];
    }
    
    if (sender.tag == 2) {
        if (select_dep_id_two.length == 0) {
            
            return;
        }
        [dic setObject:select_dep_id_two forKey:@"select_dep_id"];
        [dic setObject:@"2" forKey:@"level"];

    }

    if (sender.tag == 3) {
        if ( select_dep_id_three == 0) {
            
            return;
        }
        
        [dic setObject:select_dep_id_three forKey:@"select_dep_id"];
        [dic setObject:@"3" forKey:@"level"];
      
    }

    
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        [self.cateArr removeAllObjects];
        
        if ([strState isEqualToString:@"0"]) {
            
//            [self.cateArr removeAllObjects];
            
            [self cateBtnClicked:sender andWith:nil];
            
        }else{
            
            [self.cateArr addObjectsFromArray: [entity valueForKey:@"content"]];
            
            NSMutableArray *MuArr = [[NSMutableArray alloc]init];
            
//            [MuArr addObject:@"请选择"];
            
            for (NSDictionary *dic in self.cateArr) {
                
                [MuArr addObject:[dic objectForKey:@"name"]];
            }
            
            self.searchArr = MuArr;
            
            [self cateBtnClicked:sender andWith:MuArr];
            
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
    
}

- (void)setHeadView{
    
    
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = RGBA(241, 241, 241, 1);

    if ([self.select_type isEqualToString:@"1"]) {
        headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        
        One_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04, 5, SCREEN_WIDTH * 0.84 / 3, 35)];
        
        Two_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04 * 2 + SCREEN_WIDTH * 0.84 / 3, 5, SCREEN_WIDTH * 0.84 / 3, 35)];
        
        three_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04 *3 + SCREEN_WIDTH * 0.84 / 3* 2, 5, SCREEN_WIDTH * 0.84 / 3, 35)];
    }else{
        
        if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
            
            headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38);
            
            dataBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            
            [dataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [dataBtn setImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
            
            [headView addSubview:dataBtn];
            
            [dataBtn addTarget:self action:@selector(dateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
//            self.startTime = [Utilies getLastMonth];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
            
            [dataBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime]
                     forState:UIControlStateNormal];
            
        }else{
            
            headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
            
            dataBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            
            [dataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [dataBtn setImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
            
//            self.startTime = [Utilies getLastMonth];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
            
            [dataBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime]
                     forState:UIControlStateNormal];

            
            [dataBtn addTarget:self action:@selector(dateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [headView addSubview:dataBtn];
            
            One_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04, 40, SCREEN_WIDTH * 0.84 / 3, 35)];
            
            Two_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04 * 2 + SCREEN_WIDTH * 0.84 / 3, 40, SCREEN_WIDTH * 0.84 / 3, 35)];
            
            three_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.04 *3 + SCREEN_WIDTH * 0.84 / 3* 2, 40, SCREEN_WIDTH * 0.84 / 3, 35)];
            
        }

        
    }
   
    
    One_Btn.tag = 1;
    
    One_Btn.layer.cornerRadius = 5;
    
    One_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    One_Btn.backgroundColor = [UIColor whiteColor];
    
    [One_Btn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
    
    [One_Btn setTitle:@"请选择" forState:UIControlStateNormal];
    
    
    Two_Btn.tag = 2;
    
    Two_Btn.layer.cornerRadius = 5;
    
    Two_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    Two_Btn.backgroundColor = [UIColor whiteColor];
    
    [Two_Btn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
    
    [Two_Btn setTitle:@"请选择" forState:UIControlStateNormal];
    
    three_Btn.layer.cornerRadius = 5;
    
    three_Btn.tag = 3;
    
    three_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    three_Btn.backgroundColor = [UIColor whiteColor];
    
    [three_Btn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
    
    [three_Btn setTitle:@"请选择" forState:UIControlStateNormal];
    
    [One_Btn addTarget:self action:@selector(get_search_list:) forControlEvents:UIControlEventTouchUpInside];
    [Two_Btn addTarget:self action:@selector(get_search_list:) forControlEvents:UIControlEventTouchUpInside];
    [three_Btn addTarget:self action:@selector(get_search_list:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:One_Btn];
    [headView addSubview:Two_Btn];
    [headView addSubview:three_Btn];
    
    [self.view  addSubview:headView];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - headView.frame.size.height)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSString *url;
    
    if (![self.select_type isEqualToString:@"1"]) {
        
        if ([userEntity.type_id intValue] == ROLE_CUSTOMER) {
            if ([self.select_type isEqualToString:@"2"]) {
                url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=3&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,userEntity.dep_id,self.startTime,self.endTime];
            }
            
            if ([self.select_type isEqualToString:@"3"]) {
                url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=3&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,userEntity.dep_id,self.startTime,self.endTime];
            }
            
        }else{
            
           if ([self.select_type isEqualToString:@"2"]) {
                url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=0&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,userEntity.dep_id,self.startTime,self.endTime];
           }
            
            if ([self.select_type isEqualToString:@"3"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=0&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,userEntity.dep_id,self.startTime,self.endTime];
                
            }
        }

    }else{
        
        url = [NSString stringWithFormat:@"%@statistics_arrearage.php?select_dep_id=%@&level=0&user_id=%@",WEBURL,userEntity.dep_id,userEntity.user_id];
        
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
}

- (void)cateBtnClicked:(UIButton * )sender andWith:(NSArray *)arr
{
    CGFloat height = 40*self.cateArr.count;
    
    if (sender.tag == type) {
        
    }else{
        [dropDown hideDropDown:sender];
        
        dropDown = nil;
    }
    
    type = sender.tag;
    
    if (!dropDown) {
        dropDown = [[NIDropDown alloc] showDropDown:sender height:&height titleArr:arr imgArr:nil direction:@"down"];
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}


#pragma mark - NIDropDownDelegate

- (void)niDropDownDelegateMethod:(NIDropDown *)sender didSelectIndex:(int)index
{
    NSString *url;
    
    switch (type) {
        case 1:
            [One_Btn setTitleColor:RGBA(20, 20, 20, 1) forState:UIControlStateNormal];
            
            [One_Btn setTitle:self.searchArr[index] forState:UIControlStateNormal];
            [Two_Btn setTitle:@"请选择" forState:UIControlStateNormal];
            [three_Btn setTitle:@"请选择" forState:UIControlStateNormal];
            
            if (![self.searchArr[index] isEqualToString:@"请选择"]) {
                select_dep_id_two = self.cateArr[index][@"id"];
                
            }else{
                select_dep_id_two = userEntity.dep_id;
                
                [One_Btn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
            }
            
            
            dep_id = select_dep_id_two;
            
            if ([self.select_type isEqualToString:@"1"]) {
                 url = [NSString stringWithFormat:@"%@statistics_arrearage.php?select_dep_id=%@&level=1&user_id=%@",WEBURL,select_dep_id_two,userEntity.user_id];
            }else if ([self.select_type isEqualToString:@"2"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=1&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,select_dep_id_two,self.startTime,self.endTime];
                
            }else if ([self.select_type isEqualToString:@"3"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=1&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,select_dep_id_two,self.startTime,self.endTime];
                
            }else{
                
            }
           
            
            [dropDown hideDropDown:One_Btn];
            break;
        case 2:
            [Two_Btn setTitleColor:RGBA(20, 20, 20, 1) forState:UIControlStateNormal];
            
            [Two_Btn setTitle:self.searchArr[index] forState:UIControlStateNormal];
            
            [three_Btn setTitle:@"请选择" forState:UIControlStateNormal];
            
            if (![self.searchArr[index] isEqualToString:@"请选择"]) {
                
                select_dep_id_three = self.cateArr[index][@"id"];
                
                
            }else{
                
                [Two_Btn setTitleColor:RGBA(80, 80, 80, 1) forState:UIControlStateNormal];
                select_dep_id_three = select_dep_id_two;
                
            }
            
            dep_id = select_dep_id_three;
            if ([self.select_type isEqualToString:@"1"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_arrearage.php?select_dep_id=%@&level=2&user_id=%@",WEBURL,select_dep_id_three,userEntity.user_id];
            }else if ([self.select_type isEqualToString:@"2"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=2&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,select_dep_id_three,self.startTime,self.endTime];
                
            }else if ([self.select_type isEqualToString:@"3"]) {
                
                url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=2&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,select_dep_id_three,self.startTime,self.endTime];
                
            }
            
            [dropDown hideDropDown:Two_Btn];
            break;
        case 3:
            [three_Btn setTitleColor:RGBA(20, 20, 20, 1) forState:UIControlStateNormal];
            
            [three_Btn setTitle:self.searchArr[index] forState:UIControlStateNormal];
            
            dep_id = self.cateArr[index][@"id"];
            
            if ([self.select_type isEqualToString:@"1"]) {
                
                if ([userEntity.type_id intValue] != ROLE_CUSTOMER) {
                    
                    [self Payment_arrearsBtnClicked:self.cateArr[index][@"num"]];
                    
                    dropDown = nil;
                    
                    return;
                    
                }else{
        
                    url = [NSString stringWithFormat:@"%@statistics_arrearage.php?select_dep_id=%@&level=3&user_id=%@",WEBURL,self.cateArr[index][@"id"],userEntity.user_id];
   
                }
                
            }else if ([self.select_type isEqualToString:@"2"]){
                
                 url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=3&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,self.cateArr[index][@"id"],self.startTime,self.endTime];
            }else if ([self.select_type isEqualToString:@"3"]){
                
                url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=3&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,self.cateArr[index][@"id"],self.startTime,self.endTime];
            }else{
                
            }

            [dropDown hideDropDown:three_Btn];
            break;
        default:
            break;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
    dropDown = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [HUD hide:YES];
}

#pragma mark - 欠费缴费提醒
- (void)Payment_arrearsBtnClicked:(NSString *)sender{
    
    Payment_arrears_listViewController *vc = [[Payment_arrears_listViewController alloc]init];
    
    vc.user_num = sender;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//时间区间选择
- (void)dateBtnClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.startTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.date = startDate;
    picker.endDatePicker.date = endDate;
    picker.delegate = self;
    [picker show];
}

#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.startTime = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.endTime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime];
    [dataBtn setTitle:dateStr forState:UIControlStateNormal];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    NSString *url;
    
    if ([self.select_type isEqualToString:@"2"]){
        
        url = [NSString stringWithFormat:@"%@statistics_crm.php?user_id=%@&level=%ld&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,(long)type,dep_id,self.startTime,self.endTime];
        
    }else if ([self.select_type isEqualToString:@"3"]){
        
        url = [NSString stringWithFormat:@"%@statistics_orders.php?user_id=%@&level=%ld&select_id=%@&start_time=%@&end_time=%@",WEBURL,userEntity.user_id,(long)type,dep_id,self.startTime,self.endTime];
        
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
}

- (void)setFISTdata{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit |NSDayCalendarUnit fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *destDateString = [dateFormatter stringFromDate:firstDay];
    
    self.startTime = destDateString;
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
