//
//  goP_Vertical_industry_collaborationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/14.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "goP_Vertical_industry_collaborationViewController.h"
#import "P_Vertical_industry_collaborationSubmitViewController.h"
#import "P_Vertical_industry_collaborationDetailViewController.h"
#import "Vertical_ListEntity.h"
#import "Utilies.h"
#import "UIAlertView+Blocks.h"
#import "MBProgressHUD.h"

@interface goP_Vertical_industry_collaborationViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    NSMutableArray *arrayCutomer;
}
@end

@implementation goP_Vertical_industry_collaborationViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    userEntity = [UserEntity sharedInstance];
    arrayCutomer = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"纵向行业任务协同";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.startTime = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
    
    [dateBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime]
             forState:UIControlStateNormal];
    
    if ([userEntity.type_id intValue] == ROLE_CUSTOMER && [userEntity.dep_id rangeOfString:@"10010"].location != NSNotFound) {
        
        UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加
- (void)addBtnClicked:(UIButton *)sender{
    
    
    P_Vertical_industry_collaborationSubmitViewController *vc = [[P_Vertical_industry_collaborationSubmitViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayCutomer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    Vertical_ListEntity *model = arrayCutomer[indexPath.row];
    
    if ([model.is_new isEqualToString:@"1"]) {
        cell.badgeCenterOffset = CGPointMake(-15,20);
        [cell showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeNone];
    }else{
        [cell clearBadge];
    }
    

    NSString *title = [NSString stringWithFormat:@"%@(%@)",model.title,\
                       model.state_name];
//                       [StringHelper getBusinessStateString:model.state]];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = model.create_time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    P_Vertical_industry_collaborationDetailViewController *vc = [[P_Vertical_industry_collaborationDetailViewController alloc]init];
    Vertical_ListEntity *model = arrayCutomer[indexPath.row];
    
    vc.entity = model;
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"teamwork_list",
                           @"user_id":userEntity.user_id,
                           @"type":waitBtn.selected?@"0":@"2",
                           @"start_time":self.startTime,
                           @"end_time":self.endTime
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 0) {
            
            if (waitBtn.selected) {
                [arrayCutomer removeAllObjects];
                
                [_tableView reloadData];
            }
            
        }else{
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                Vertical_ListEntity *entity = [[Vertical_ListEntity alloc]init];
                entity = [entity initWithAttributes:dic];
                [arrayCutomer addObject:entity];
            }
            
        }
        
        [_tableView reloadData];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
    
}

//待办事项点击
- (IBAction)waitBtnClicked:(id)sender
{
    waitBtn.selected = !waitBtn.selected;
    
    [arrayCutomer removeAllObjects];
    
    [self getData];
}

//时间区间选择
- (IBAction)dateBtnClicked:(id)sender
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
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    [arrayCutomer removeAllObjects];
    
    [self getData];
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    //    [refreshHeader beginRefreshing];
    [arrayCutomer removeAllObjects];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
