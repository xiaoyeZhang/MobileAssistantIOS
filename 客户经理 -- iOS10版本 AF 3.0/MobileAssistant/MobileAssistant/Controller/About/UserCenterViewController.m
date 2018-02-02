//
//  UserCenterViewController.m
//  MobileAssistant
//
//  Created by xy on 15/10/15.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserTaskListTableViewCell.h"
#import "UserTableCellHeaderView.h"
#import "MBProgressHUD.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "SummaryEntity.h"
#import "LocationEntity.h"
#import "UserTableCellHeaderView.h"
#import "UIActionSheet+Block.h"
#import "SuggestViewController.h"
#import "ProvinceVIPViewController.h"
#import "ChangePwdViewController.h"

#import "P_SpecialListViewController.h"
#import "P_AppointListViewController.h"
#import "P_TerminalListViewController.h"
#import "P_StockListViewController.h"
#import "P_RepairListViewController.h"
#import "P_BookListViewController.h"
#import "P_CardListViewController.h"
#import "P_BillListViewController.h"
#import "Product_LineViewController.h"

#import "TaskCreateViewController.h"

#import "Product_imformationViewController.h"

#import "P_TerminalStockListViewController.h"
#import "UIColor+Hex.h"
#import "PushSettingViewController.h"
#import "P_MarketingPlanViewController.h"
#import "ChangePhoneViewController.h"
#import "shareViewController.h"
#import "recommendedViewController.h"
#import "Birthday_listViewController.h"
#import "Contract_expiresViewController.h"
#import "Markeing_classificationViewController.h"
#import "Payment_arrears_listViewController.h"
#import "No_visit_listViewController.h"
#import "White_list_queryViewController.h"
#import "No_visit_baselistViewController.h"
#import "P_Household_divisionViewController.h"
#import "P_RefundViewController.h"
#import "Performance_displayViewController.h"

#import "AppDelegate.h"
#import "UserLogoutBtnView.h"
#import "MainCell.h"

#import "News_ProvinceVipEntity.h"
#import "News_ProviceVIP_ListViewController.h"

#import "This_month_unvisitEntity.h"
#import "This_month_unvisitTableViewCell.h"

#import "small_piece_paperViewController.h"
#import "data_statisticsWebViewController.h"
#import "goP_Vertical_industry_collaborationViewController.h"
#import "P_Marketing_PlanListViewController.h"
#import "Basic_business_moduleListViewController.h"
#import "Houston_queryViewController.h"

#import "Visit_listViewController.h"

@interface UserCenterViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    SummaryEntity *summaryEntity;
    
    NSArray *unfinishedArray;
    
    NSMutableArray *visitArray;
    NSArray *iconArray;
    
    NSArray *sectionArray;
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
    NSInteger i;
    UserTableCellHeaderView *view;

    NSString *ProvinceVIP_State;
    
    NSMutableDictionary *selectedCellDic;//二级cell列表是否展开状态
    
    NSMutableArray *this_month_unvisitArr;
    
    NSMutableArray *this_month_visitArr;
    
    NSString *this_month_visit_total_num;
    NSString *this_month_visited_num;
    NSString *this_month_unvisit_num;
    
    BOOL isCellOneClick;
    BOOL isCellTwoClick;
    
    NSString *tape_num;
    NSArray *data_statisticsArr;

}
//@property(nonatomic, copy) NSString *enableStr;
@property(nonatomic, strong) NSDictionary *unfinishedDict;
@property(nonatomic, copy) NSString *specialConfigStr;
@property (copy, nonatomic) NSString *push_starttime;
@property (copy, nonatomic) NSString *push_endtime;
@property (copy, nonatomic) NSString *birthday_num;

@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation UserCenterViewController


-(void)getData_ProvinceVIP{
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
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
            [self.arrayCutomer removeAllObjects];
            
            int num = 0;
            
            for (NSDictionary* attributes in array) {
                News_ProvinceVipEntity *entity = [[News_ProvinceVipEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
                
                num += [attributes[@"count"] intValue];
            }
            
            if (num > 0) {
                
                [self.mainVC.btnAbout showBadgeWithStyle:WBadgeStyleNumber
                                                   value:num
                                           animationType:WBadgeAnimTypeNone];
            }else{
                
                [self.mainVC.btnAbout clearBadge];
            }
            
            [_tableView reloadData];
            
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    tape_num = @"0";
    
    self.birthday_num = @"0";
    
    isCellOneClick = NO;
    isCellTwoClick = NO;
    
    visitArray = [[NSMutableArray alloc]init];
    
    [self settableviewARR];
    
    unfinishedArray = @[@{@"title":@" 特号办理",@"num":@"t1+t2"},
//                        @{@"title":@" 公司领导预约拜访",@"num":@"t3"},
                        @{@"title":@" 终端办理",@"num":@"t4"},
                        @{@"title":@" 终端退库",@"num":@"t5"},
//                        @{@"title":@" 售后维修单",@"num":@"t6+t7"},
                        @{@"title":@" 台账登记",@"num":@"t8+t9+t16"},
//                        @{@"title":@" 办卡",@"num":@"t10+t11"},
                        @{@"title":@" 开具发票",@"num":@"t12+t13+t14"},
                        @{@"title":@" 终端出库",@"num":@"t15+t17"},
//                        @{@"title":@" 营销方案更改",@"num":@"t18"},
//                        @{@"title":@" 退款",@"num":@"t20"},
//                        @{@"title":@" 分合户",@"num":@"t21"},
//                        @{@"title":@" 纵向行业任务协同",@"num":@"t-1"},
//                        @{@"title":@" 进账查询",@"num":@"t22"},
                        @{@"title":@" 营销方案确认",@"num":@"t23"},
                        @{@"title":@" 基础业务受理",@"num":@"t24"},
                        ];

    data_statisticsArr = @[@"CRM业务办理情况",@"统一下单业务办理情况"];
//    ,@"拜访任务查看",@"统一下单工单查看"];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
//    if([userInfo.dep_id rangeOfString:@"10010"].location != NSNotFound){
//        
//        data_statisticsArr = @[@"欠费催缴",@"CRM业务办理情况",@"统一下单业务办理情况",@"拜访任务工单查看"];
//        
//    }
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _tableView.tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [visitArray addObject:@{@"title":@" 今天走访任务数",@"finish":@"today_finish",@"total":@"today"}];
    [visitArray addObject:@{@"title":@" 本周走访任务数",@"finish":@"this_week_finish",@"total":@"this_week"}];
    [visitArray addObject:@{@"title":@" 本月走访任务数",@"finish":@"this_month_finish",@"total":@"this_month"}];
    [visitArray addObject:@{@"title":@" 上月走访任务数",@"finish":@"last_month_finish",@"total":@"last_month"}];
    [visitArray addObject:@{@"title":@" 本月已走访集团客户",@"finish":@"last_month_finish",@"total":@"last_month"}];
    [visitArray addObject:@{@"title":@" 本月未走访集团客户",@"finish":@"last_month_finish",@"total":@"last_month"}];

    [self getSettingFromServer];
    
    [self getBirthdayNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)settableviewARR{
    
    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    ProvinceVIP_State = [locationDefaults objectForKey:@"ProvinceVIP_State"];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    if ([userInfo.type_id intValue] != ROLE_CUSTOMER) {
        
        if ([ProvinceVIP_State isEqualToString:@"old"]) {
            //@"小纸条"
            sectionArray = [NSArray arrayWithObjects:@"待办事项",@"运营分析数据统计",@"欠费任务提醒",@"合同到期提醒推送",@"客户生日提醒",@"2017全省班组成绩展示",@"APP应用推荐",@"推送设置",@"修改密码",@"修改手机号码",@"意见反馈",@"App下载地址分享",@"当前版本",@"退出登录", nil];					//13
            //@"小纸条工单icon"
            iconArray = [NSArray arrayWithObjects:@"待办事项",@"运营信息统计icon",@"催缴任务",@"合同到期-2",@"生日提醒(1)",@"指标",@"业内应用推荐",@"设置推送时间",@"修改密码",@"my_phone",@"意见反馈",@"my_share",@"当前版本号", nil];
            
        }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
            
            sectionArray = [NSArray arrayWithObjects:@"待办事项",@"运营分析数据统计",@"欠费任务提醒",@"合同到期提醒推送",@"客户生日提醒",@"2017全省班组成绩展示",@"APP应用推荐",@"推送设置",@"修改密码",@"修改手机号码",@"意见反馈",@"App下载地址分享",@"当前版本",@"退出登录", nil];					//12
            iconArray = [NSArray arrayWithObjects:@"待办事项",@"运营信息统计icon",@"催缴任务",@"合同到期-2",@"生日提醒(1)",@"指标",@"业内应用推荐",@"设置推送时间",@"修改密码",@"my_phone",@"意见反馈",@"my_share",@"当前版本号", nil];
            
        }else{
            
        }
        
    }else{
        
        if ([ProvinceVIP_State isEqualToString:@"old"]) {
            //@"小纸条"
            sectionArray = [NSArray arrayWithObjects:@"待办事项",@"走访情况",@"运营分析数据统计",@"欠费任务提醒",@"合同到期提醒推送",@"客户生日提醒",@"2017全省班组成绩展示",@"APP应用推荐",@"推送设置",@"修改密码",@"修改手机号码",@"意见反馈",@"App下载地址分享",@"当前版本",@"退出登录", nil];					//14
            //,@"小纸条工单icon"
            iconArray = [NSArray arrayWithObjects:@"待办事项",@"走访任务执行情况",@"运营信息统计icon",@"催缴任务",@"合同到期-2",@"生日提醒(1)",@"指标",@"业内应用推荐",@"设置推送时间",@"修改密码",@"my_phone",@"意见反馈",@"my_share",@"当前版本号", nil];
            
        }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
            
            sectionArray = [NSArray arrayWithObjects:@"待办事项",@"走访情况",@"运营分析数据统计",@"欠费任务提醒",@"合同到期提醒推送",@"客户生日提醒",@"2017全省班组成绩展示",@"APP应用推荐",@"推送设置",@"修改密码",@"修改手机号码",@"意见反馈",@"App下载地址分享",@"当前版本",@"退出登录", nil];					//13
            iconArray = [NSArray arrayWithObjects:@"待办事项",@"走访任务执行情况",@"运营信息统计icon",@"催缴任务",@"合同到期-2",@"生日提醒(1)",@"指标",@"业内应用推荐",@"设置推送时间",@"修改密码",@"my_phone",@"意见反馈",@"my_share",@"当前版本号", nil];
            
        }else{
            
        }
    }
    
}

#pragma mark -

//- (BOOL)checkIfFunctionDisabledWithIndex:(int)index
//{
//    if (self.enableStr.length == 0) {
//        return NO; //此处应为YES默认禁用  他人不听建议默认开启
//    }else{
//        NSString *indexStr = [NSString stringWithFormat:@"%d",index+1];
//        
//        NSRange range = [self.enableStr rangeOfString:indexStr
//                                              options:NSCaseInsensitiveSearch];
//        if (range.length > 0) {
//            return NO;
//        }else{
//            return YES;
//        }
//    }
//    
//    return NO; //此处应为YES默认禁用  他人不听建议默认开启
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if ([userInfo.type_id intValue] == ROLE_CUSTOMER) { //客户经理才获取走访执行情况
//        return 3;
//    }
    return sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        if ([ProvinceVIP_State isEqualToString:@"old"]) {
            return unfinishedArray.count;
        }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
            
            return self.arrayCutomer.count;
        }else{
            return 0;
        }
        
    }else if(section == 1){
        if ([sectionArray[section] isEqualToString:@"运营分析数据统计"]) {
           return data_statisticsArr.count;
        }
         return visitArray.count;
    }else if(section == 2){
        return data_statisticsArr.count;
    }else{
        return 0;
    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskIdentifier = @"UserTaskListTableViewCell";
    
    UserTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:taskIdentifier owner:nil options:nil] firstObject];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.clipsToBounds = YES;
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        NSDictionary *dict;
        News_ProvinceVipEntity *entity;
        int num = 0;
        if ([ProvinceVIP_State isEqualToString:@"old"]) {
            
            dict = unfinishedArray[indexPath.row];
        
            cell.titleLbl.text = dict[@"title"];
            
            NSArray *arr = [dict[@"num"] componentsSeparatedByString:@"+"];
            
            for (NSString *key in arr) {
                num += [self.unfinishedDict[key] intValue];
            }
            
            
        }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
            
            entity = [self.arrayCutomer objectAtIndex:indexPath.row];
            
            cell.titleLbl.text = entity.name;
            
            num = [entity.count intValue];
            
        }else{
            
        }
        
        
        cell.subTitleLbl.text = [NSString stringWithFormat:@"%d",num];
        
        if (num > 0) {
            cell.subTitleLbl.textColor = [UIColor redColor];
        
        }else{
            cell.subTitleLbl.textColor = [UIColor lightGrayColor];
        }
    }else if(indexPath.section == 1){
        
        if ([sectionArray[indexPath.section] isEqualToString:@"运营分析数据统计"]) {
        
            cell.titleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
            cell.subTitleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *Str = [data_statisticsArr objectAtIndex:indexPath.row];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:Str];
            
            NSRange contentRange = {0,Str.length};
            
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            
            cell.titleLbl.attributedText = str;
            cell.subTitleLbl.text = @"";
        
        }else{
            
            cell.titleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
            cell.subTitleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *dict = visitArray[indexPath.row];
            
            NSString *str;
            
            if ([visitArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
                str = @"1";
            }
            
            //        if ([[dict allKeys] containsObject:@"finish"]){
            //            str = @"1";
            //        }
            
            if ([str isEqualToString:@"1"]) {
                
                cell.titleLbl.text = dict[@"title"];
                NSString *subTitle;
                
                if ([cell.titleLbl.text isEqualToString:@" 本月已走访集团客户"]) {
                    
                    subTitle = [NSString stringWithFormat:@"%d/%d",[this_month_visited_num intValue],\
                                [this_month_visit_total_num intValue]];
                    
                }else if ([cell.titleLbl.text isEqualToString:@" 本月未走访集团客户"]) {
                    
                    subTitle = [NSString stringWithFormat:@"%d/%d",[this_month_unvisit_num intValue],\
                                [this_month_visit_total_num intValue]];
                    
                }else{
                    subTitle = [NSString stringWithFormat:@"%d/%d",[[summaryEntity valueForKey:dict[@"finish"]] intValue],\
                                [[summaryEntity valueForKey:dict[@"total"]] intValue]];
                }
                
                cell.subTitleLbl.text = subTitle;
                
            }else{
                static NSString *identifier = @"This_month_unvisitTableViewCell";
                This_month_unvisitTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell1) {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
                    //                cell.separatorInset = UIEdgeInsetsZero;
                    //                cell.clipsToBounds = YES;
                }
                
                //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                //            if (!cell) {
                //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                //                                              reuseIdentifier:identifier];
                //
                //                cell.textLabel.font = [UIFont systemFontOfSize:15];
                //            }
                //
                
                This_month_unvisitEntity *model = visitArray[indexPath.row];
                
                cell1.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
                cell1.sumbetTextLabel.text = [NSString stringWithFormat:@"%@",model.last_time];
                
                
                return cell1;
            }

        }
        
        
    }else if(indexPath.section == 2){
        
        cell.titleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
        cell.subTitleLbl.textColor = [UIColor colorWithHexString:@"#1E9ACC"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *Str = [data_statisticsArr objectAtIndex:indexPath.row];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:Str];
        
        NSRange contentRange = {0,Str.length};
        
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        
        cell.titleLbl.attributedText = str;
        cell.subTitleLbl.text = @"";
        
    }else{
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     view = [[[NSBundle mainBundle] loadNibNamed:@"UserTableCellHeaderView" owner:nil options:nil] firstObject];
    
    if (sectionArray.count == 15) {
        if (section == 14) {
            
        }else{
            
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
        }
        
        NSString *title = sectionArray[section];
        view.titleLbl.text = [NSString stringWithFormat:@"%@",title];
        view.backgroundColor = [UIColor whiteColor];
        view.down_rightImage.image = [UIImage imageNamed:@"right"];
        view.tag = section;
        
        
        if (section == 0 || section == 1) {
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
            int num = 0;
            
            if ([ProvinceVIP_State isEqualToString:@"old"]) {
                
                for (NSString *key in [self.unfinishedDict allKeys]) {
                    num += [self.unfinishedDict [key] intValue];
                }
                
            }else if ([ProvinceVIP_State isEqualToString:@"new"] ||[ProvinceVIP_State isEqualToString:@"close"]){
                
                for (News_ProvinceVipEntity *entity in self.arrayCutomer) {
                    num += [entity.count intValue];
                }
                
            }
            
            if(section == 0){
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%d)",sectionArray[section],num];
            }
            
            if (i == 1) {
                if (section == 0) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            if (i == 2) {
                if (section == 1) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 2) {
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
//        else if (section == 3) {
//
//            NSMutableAttributedString *tape_numStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"小纸条 (%@)",tape_num?tape_num:@"0"]];
//
//            [tape_numStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, tape_num.length)];
//
//            view.titleLbl.attributedText = tape_numStr;
//
//            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(small_piece_paperBtnClicked:)];
//            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
//            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
//            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
//        }
        else if (section == 3) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Payment_arrearsBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 4) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Contract_expiresBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 5) {
            
            view.titleLbl.text = [NSString stringWithFormat:@"%@(本月%@条提醒)",title,self.birthday_num?self.birthday_num:@"0"];
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BirthdayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 6) {//2017全省班组成绩展示
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Performance_displayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 7) {//应用推荐
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendedBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 8) {
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBtnClicked:)];
            
            if (self.push_starttime.length > 0 && self.push_endtime.length > 0) {
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%@--%@)",sectionArray[section],self.push_starttime,self.push_endtime];
            }
            
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 9) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePwdBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 10) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoneBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 11) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedBackBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 12) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
        if(section == 14){
            
            UserLogoutBtnView *logoutView = [[[NSBundle mainBundle]loadNibNamed:@"UserLogoutBtnView" owner:nil options:nil]firstObject];
            logoutView.subTitleLbl.layer.borderWidth = 1;
            logoutView.subTitleLbl.clipsToBounds = YES;
            logoutView.subTitleLbl.font = [UIFont systemFontOfSize:14];
            logoutView.subTitleLbl.layer.cornerRadius = 10;
            logoutView.subTitleLbl.layer.borderColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1].CGColor;
            logoutView.subTitleLbl.text = @"退出登录";
            logoutView.subTitleLbl.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [logoutView addGestureRecognizer:singleRecognizer];//添加一个手势监测
            
            return logoutView;
        }
        
        if (section == 13) {
            view.down_rightImage.hidden = YES;
            NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
            NSString *clientVersion = clientInfoDict[@"CFBundleShortVersionString"];
            
            view.label.text = [NSString stringWithFormat:@"%@",clientVersion];
        }else{
            view.label.hidden = YES;
        }
    }else if(sectionArray.count == 14 && [ProvinceVIP_State isEqualToString:@"old"]){
        
        if (section == 13) {
            
        }else{
            
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
        }
        
        NSString *title = sectionArray[section];
        view.titleLbl.text = [NSString stringWithFormat:@"%@",title];
        view.backgroundColor = [UIColor whiteColor];
        view.down_rightImage.image = [UIImage imageNamed:@"right"];
        view.tag = section;
        
        
        if (section == 0) {
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
            int num = 0;
            for (NSString *key in [self.unfinishedDict allKeys]) {
                num += [self.unfinishedDict [key] intValue];
            }
            view.titleLbl.text = [NSString stringWithFormat:@"%@(%d)",sectionArray[section],num];
            
            if (i == 1) {
                if (section == 0) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 1) {
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
//        else if (section == 2) {
//
//            NSMutableAttributedString *tape_numStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"小纸条 (%@)",tape_num?tape_num:@"0"]];
//
//            [tape_numStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, tape_num.length)];
//
//            view.titleLbl.attributedText = tape_numStr;
//
//            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(small_piece_paperBtnClicked:)];
//            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
//            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
//            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
//        }
        else if (section == 2) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Payment_arrearsBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 3) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Contract_expiresBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 4) {
            
            view.titleLbl.text = [NSString stringWithFormat:@"%@(本月%@条提醒)",title,self.birthday_num?self.birthday_num:@"0"];
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BirthdayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 5) {//2017全省班组成绩展示
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Performance_displayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 6) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendedBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 7) {
            
            if (self.push_starttime.length > 0 && self.push_endtime.length > 0) {
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%@--%@)",sectionArray[section],self.push_starttime,self.push_endtime];
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 8) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePwdBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 9) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoneBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 10) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedBackBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 11) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
        if(section == 13){
            
            UserLogoutBtnView *logoutView = [[[NSBundle mainBundle]loadNibNamed:@"UserLogoutBtnView" owner:nil options:nil]firstObject];
            logoutView.subTitleLbl.layer.borderWidth = 1;
            logoutView.subTitleLbl.clipsToBounds = YES;
            logoutView.subTitleLbl.font = [UIFont systemFontOfSize:14];
            logoutView.subTitleLbl.layer.cornerRadius = 10;
            logoutView.subTitleLbl.layer.borderColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1].CGColor;
            logoutView.subTitleLbl.text = @"退出登录";
            logoutView.subTitleLbl.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [logoutView addGestureRecognizer:singleRecognizer];//添加一个手势监测
            
            return logoutView;
        }
        
        if (section == 12) {
            view.down_rightImage.hidden = YES;
            NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
            NSString *clientVersion = clientInfoDict[@"CFBundleShortVersionString"];
            
            view.label.text = [NSString stringWithFormat:@"%@",clientVersion];
        }else{
            view.label.hidden = YES;
        }
        
    }else if (sectionArray.count == 15 && ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"])) {
        if (section == 14) {
            
        }else{
            
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
        }
        
        NSString *title = sectionArray[section];
        view.titleLbl.text = [NSString stringWithFormat:@"%@",title];
        view.backgroundColor = [UIColor whiteColor];
        view.down_rightImage.image = [UIImage imageNamed:@"right"];
        view.tag = section;
        
        
        if (section == 0 || section == 1) {
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
            int num = 0;
            
            if ([ProvinceVIP_State isEqualToString:@"old"]) {
                
                for (NSString *key in [self.unfinishedDict allKeys]) {
                    num += [self.unfinishedDict [key] intValue];
                }
                
            }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
                
                for (News_ProvinceVipEntity *entity in self.arrayCutomer) {
                    num += [entity.count intValue];
                }
                
            }
            
            if(section == 0){
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%d)",sectionArray[section],num];
            }
            
            if (i == 1) {
                if (section == 0) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            if (i == 2) {
                if (section == 1) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 2) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 3) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Payment_arrearsBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 4) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Contract_expiresBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 5) {
            
            view.titleLbl.text = [NSString stringWithFormat:@"%@(本月%@条提醒)",title,self.birthday_num?self.birthday_num:@"0"];
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BirthdayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 6) {//2017全省班组成绩展示
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Performance_displayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 7) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendedBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 8) {
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBtnClicked:)];
            
            if (self.push_starttime.length > 0 && self.push_endtime.length > 0) {
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%@--%@)",sectionArray[section],self.push_starttime,self.push_endtime];
            }
            
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 9) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePwdBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 10) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoneBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 11) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedBackBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 12) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
        if(section == 14){
            
            UserLogoutBtnView *logoutView = [[[NSBundle mainBundle]loadNibNamed:@"UserLogoutBtnView" owner:nil options:nil]firstObject];
            logoutView.subTitleLbl.layer.borderWidth = 1;
            logoutView.subTitleLbl.clipsToBounds = YES;
            logoutView.subTitleLbl.font = [UIFont systemFontOfSize:14];
            logoutView.subTitleLbl.layer.cornerRadius = 10;
            logoutView.subTitleLbl.layer.borderColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1].CGColor;
            logoutView.subTitleLbl.text = @"退出登录";
            logoutView.subTitleLbl.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [logoutView addGestureRecognizer:singleRecognizer];//添加一个手势监测
            
            return logoutView;
        }
        
        if (section == 13) {
            view.down_rightImage.hidden = YES;
            NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
            NSString *clientVersion = clientInfoDict[@"CFBundleShortVersionString"];
            
            view.label.text = [NSString stringWithFormat:@"%@",clientVersion];
        }else{
            view.label.hidden = YES;
        }
    }else if(sectionArray.count == 14){
        
        if (section == 13) {
            
        }else{
            
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
        }
        
        NSString *title = sectionArray[section];
        view.titleLbl.text = [NSString stringWithFormat:@"%@",title];
        view.backgroundColor = [UIColor whiteColor];
        view.down_rightImage.image = [UIImage imageNamed:@"right"];
        view.tag = section;
        
        
        if (section == 0) {
            NSString *icon = iconArray[section];
            view.iconImage.image = [UIImage imageNamed:icon];
            int num = 0;
            for (NSString *key in [self.unfinishedDict allKeys]) {
                num += [self.unfinishedDict [key] intValue];
            }
            view.titleLbl.text = [NSString stringWithFormat:@"%@(%d)",sectionArray[section],num];
            
            if (i == 1) {
                if (section == 0) {
                    view.down_rightImage.image = [UIImage imageNamed:@"down"];
                }
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 1) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 2) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Payment_arrearsBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 3) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Contract_expiresBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 4) {
            
            view.titleLbl.text = [NSString stringWithFormat:@"%@(本月%@条提醒)",title,self.birthday_num?self.birthday_num:@"0"];
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BirthdayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 5) {//2017全省班组成绩展示
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Performance_displayBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 5) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendedBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 7) {
            
            if (self.push_starttime.length > 0 && self.push_endtime.length > 0) {
                view.titleLbl.text = [NSString stringWithFormat:@"%@(%@--%@)",sectionArray[section],self.push_starttime,self.push_endtime];
            }
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 8) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePwdBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 9) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoneBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 10) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedBackBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }else if (section == 11) {
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
        }
        if(section == 13){
            
            UserLogoutBtnView *logoutView = [[[NSBundle mainBundle]loadNibNamed:@"UserLogoutBtnView" owner:nil options:nil]firstObject];
            logoutView.subTitleLbl.layer.borderWidth = 1;
            logoutView.subTitleLbl.clipsToBounds = YES;
            logoutView.subTitleLbl.font = [UIFont systemFontOfSize:14];
            logoutView.subTitleLbl.layer.cornerRadius = 10;
            logoutView.subTitleLbl.layer.borderColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1].CGColor;
            logoutView.subTitleLbl.text = @"退出登录";
            logoutView.subTitleLbl.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutBtnClicked:)];
            singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
            [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
            [logoutView addGestureRecognizer:singleRecognizer];//添加一个手势监测
            
            return logoutView;
        }
        
        if (section == 12) {
            view.down_rightImage.hidden = YES;
            NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
            NSString *clientVersion = clientInfoDict[@"CFBundleShortVersionString"];
            
            view.label.text = [NSString stringWithFormat:@"%@",clientVersion];
        }else{
            view.label.hidden = YES;
        }
        
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (sectionArray.count == 14) {
        if (section == 13) {
            return 80;
        }
        
    }
    if (sectionArray.count == 16) {
        if (section == 15) {
            return 80;
        }
    }
    
    if (sectionArray.count == 15) {
        if (section == 14) {
            return 80;
        }
    }
    
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        
//        if ([visitArray[indexPath.row] isKindOfClass:[NSDictionary class]] && indexPath.section == 1) {
//            return 44;
//        }else{
            return 50;
//        }
        
    }

    return 0;

}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (sectionArray.count == 15) {
        if (section == 2) {
            return 10;
        }else{
            return 0.5;
        }
    }else if(sectionArray.count == 14 && [ProvinceVIP_State isEqualToString:@"old"]){
        
        if (section == 1) {
            return 10;
        }else{
            return 0.5;
        }
    }else if(sectionArray.count == 15 && ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"])){
        
        if (section == 2) {
            return 10;
        }else{
            return 0.5;
        }
    }else if(sectionArray.count == 13){
        
        if (section == 1) {
            return 10;
        }else{
            return 0.5;
        }
    }
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![sectionArray[indexPath.section] isEqualToString:@"运营分析数据统计"]) {
        if ((sectionArray.count == 16 || (sectionArray.count == 15 && ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"])))&& indexPath.section == 1) {
            
            NSDictionary *dict = visitArray[indexPath.row];
            
            if ([visitArray[indexPath.row] isKindOfClass:[NSDictionary class]]){
                
                if ([dict[@"title"] isEqualToString:@" 本月已走访集团客户"]) {
                    
                    if (!isCellOneClick) {
                        
                        //                    NSArray *array = @[@{@"title":@"姓      名：",@"type":@"Change"},
                        //                                       @{@"title":@"姓      名：",@"type":@"Change"}];
                        NSRange range = NSMakeRange(indexPath.row+1, [this_month_visitArr count]);
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                        [visitArray insertObjects:this_month_visitArr atIndexes:indexSet];
                        
                        NSLog(@"本月已走访集团客户");
                        isCellOneClick = YES;
                    }else{
                        
                        NSDictionary *dict = visitArray[indexPath.row];
                        
                        if ([[dict allKeys] containsObject:@"finish"]){
                            
                            if ([visitArray[indexPath.row+1] isKindOfClass:[NSDictionary class]]) {
                                
                            }else{
                                //                            This_month_unvisitEntity *entity = visitArray[indexPath.row+1];
                                //
                                //                            if ([visitArray[indexPath.row+1] isEqualToString:@" 本月未走访集团客户"]) {
                                //
                                //                            }else{
                                NSRange range = NSMakeRange(indexPath.row+1, this_month_visitArr.count);
                                //                            [visitArray removeObjectAtIndex:indexPath.row + 1];
                                [visitArray removeObjectsInRange:range];
                                //                            }
                            }
                            
                        }
                        isCellOneClick = NO;
                    }
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    
                }else{
                    if ([dict[@"title"] isEqualToString:@" 本月未走访集团客户"]) {
                        if (!isCellTwoClick) {
                            
                            //                        NSArray *array = @[@{@"title":@"姓      名：",@"type":@"Change"}];
                            NSRange range = NSMakeRange(indexPath.row+1, [this_month_unvisitArr count]);
                            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                            [visitArray insertObjects:this_month_unvisitArr atIndexes:indexSet];
                            
                            NSLog(@"本月已走访集团客户");
                            isCellTwoClick = YES;
                        }else{
                            
                            NSDictionary *dict = visitArray[indexPath.row];
                            
                            if ([[dict allKeys] containsObject:@"finish"]){
                                
                                if ([dict[@"title"] isEqualToString:@" 本月未走访集团客户"]) {
                                    
                                    //                                [visitArray removeObjectAtIndex:indexPath.row + 1];
                                    NSRange range = NSMakeRange(indexPath.row+1, this_month_unvisitArr.count);
                                    
                                    [visitArray removeObjectsInRange:range];
                                }
                            }
                            
                            
                            isCellTwoClick = NO;
                        }
                        
                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }else{
                This_month_unvisitEntity *model = visitArray[indexPath.row];
                
                TaskCreateViewController *vc = [[TaskCreateViewController alloc]init];
                
                vc.entity = model;
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];
                
            }
            
        }
   
    }else{
        UserEntity *userInfo = [UserEntity sharedInstance];
        if ([userInfo.type_id intValue] == ROLE_CUSTOMER) {
            
//            if(indexPath.row == 0){
//                
//                [self Payment_arrearsBtnClicked:nil];
//                
//            }else
            if (indexPath.row == 0){
                
                data_statisticsWebViewController *vc = [[data_statisticsWebViewController alloc]init];
                
                vc.name = data_statisticsArr[indexPath.row];
                
                vc.select_type = @"2";
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 1){
                
                data_statisticsWebViewController *vc = [[data_statisticsWebViewController alloc]init];
                
                vc.select_type = @"3";
                
                vc.name = data_statisticsArr[indexPath.row];
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 2){
                
                Visit_listViewController  *vc = [[Visit_listViewController alloc]init];
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([userInfo.type_id intValue] == ROLE_THREE || [userInfo.type_id intValue] == ROLE_TWO){
            
            data_statisticsWebViewController *vc = [[data_statisticsWebViewController alloc]init];
            vc.name = data_statisticsArr[indexPath.row];
//
//            if(indexPath.row == 0){
//                
//                vc.select_type = @"1";
//                
//            }else
            if (indexPath.row == 0){
                
                vc.select_type = @"2";
                
            }else if (indexPath.row == 1){
                
                vc.select_type = @"3";
                
            }else if(indexPath.row == 2){
                
                Visit_listViewController  *vc = [[Visit_listViewController alloc]init];
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];
            }
            
            if (indexPath.row == 0 || indexPath.row == 1) {
                
                [self.mainVC.navigationController pushViewController:vc animated:YES];

            }
            
            
        }else{
            
        }
    }
    
    if (indexPath.section == 0) {
        UserTaskListTableViewCell *cell = (UserTaskListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (![cell isMemberOfClass:[UserTaskListTableViewCell class]]) {
            return;
        }

        if ([ProvinceVIP_State isEqualToString:@"old"]) {

            if ([cell.subTitleLbl.text intValue] > 0) {

                switch (indexPath.row) {
                    case 0:
                    {
                        [self goSpecialViewController:nil];
                        break;
                    }
//                    case 1:
//                    {
//                        [self goAPPointViewController:nil];
//                        break;
//                    }
                    case 1:
                    {
                        [self goTerminalViewController:nil];
                        break;
                    }
                    case 2:
                    {
                        [self goStockViewController:nil];
                        break;
                    }
//                    case 4:
//                    {
//                        [self goRepairViewController:nil];
//                        break;
//                    }
                    case 3:
                    {
                        [self goBookViewController:nil];
                        break;
                    }
//                    case 6:
//                    {
//                        [self goCardViewController:nil];
//                        break;
//                    }
                    case 4:
                    {
                        [self goBillViewController:nil];
                        break;
                    }
                    case 5:
                    {
                        [self goTerminalStockViewController:nil];
                        break;
                    }
//                    case 9:
//                    {
//                        [self goMarketingPlanViewController:nil];
//                        break;
//                    }
//                    case 10:
//                    {
//                        [self goProduct_LineViewController:nil];
//                        break;
//                    }
//                    case 10:
//                    {
//                        [self goRefundViewController:nil];
//                        break;
//                    }
//                    case 11:
//                    {
//                        [self goP_Household_divisionViewController:nil];
//                        break;
//                    }
//                    case 12:
//                    {
//                        [self goP_Vertical_industry_collaborationViewController:nil];
//                        break;
//                    }
//                    case 13:
//                    {
//                        [self goHouston_queryViewController:nil];
//                        break;
//                    }
                    case 6:
                    {
                        [self goP_Marketing_PlanViewController:nil];
                        break;
                    }
                    case 7:
                    {
                        [self goBasic_business_moduleListViewController:nil];
                        break;
                    }
                    default:
                        break;
                }
            }
            
        }else if ([ProvinceVIP_State isEqualToString:@"new"] || [ProvinceVIP_State isEqualToString:@"close"]){
            
             if ([cell.subTitleLbl.text intValue] > 0) {
                 
                 if([cell.titleLbl.text rangeOfString:@"纵向行业"].location != NSNotFound){
                     [self goP_Vertical_industry_collaborationViewController:nil];
                 }else{
                     
                     News_ProviceVIP_ListViewController *vc = [[News_ProviceVIP_ListViewController alloc]init];
                     News_ProvinceVipEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
                     vc.module_id = entity.module_id;
                     vc.name = entity.name;
                     [self.mainVC.navigationController pushViewController:vc animated:YES];
                 }
                
             }
        }
        
       
    }else{
        
    }
}

#pragma mark -

- (void)settingBtnClicked:(id)sender
{
    PushSettingViewController *vc = [[PushSettingViewController alloc] init];
    vc.delegate = self;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)feedBackBtnClicked:(id)sender
{
    SuggestViewController *vc = [[SuggestViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

- (void)logoutBtnClicked:(id)sender
{
    [UIActionSheet showInView:self.view
                    withTitle:@"确认退出登录?"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:@"退出登录"
            otherButtonTitles:nil
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex != actionSheet.cancelButtonIndex) {
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserEntity"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                             [appDelegate chnageRootToLoginVC];
                             //[self.mainVC.navigationController popViewControllerAnimated:YES];
                         }
                     }];
}

- (void)Performance_displayBtnClicked:(id)sender{
    
    UserEntity *entity = [UserEntity sharedInstance];
    
    if (![entity.num isEqualToString:@""]) {
        
        Performance_displayViewController *vc = [[Performance_displayViewController alloc] init];
        vc.user_num = entity.num;
        [self.mainVC.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 业内应用推荐
- (void)recommendedBtnClicked:(id)sender{
    
    //业内应用推荐
    recommendedViewController *vc = [[recommendedViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

#pragma  mark - 小纸条
- (void)small_piece_paperBtnClicked:(id)sender{
    
    small_piece_paperViewController *vc = [[small_piece_paperViewController alloc]init];
    
    vc.tape_num = tape_num;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 欠费缴费提醒
- (void)Payment_arrearsBtnClicked:(id)sender{
    
    Payment_arrears_listViewController *vc = [[Payment_arrears_listViewController alloc]init];
    
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 客户生日提醒
- (void)BirthdayBtnClicked:(id)sender{

    Birthday_listViewController *vc = [[Birthday_listViewController alloc]init];
    
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 合同到期
- (void)Contract_expiresBtnClicked:(id)sender{
  
    Contract_expiresViewController *vc = [[Contract_expiresViewController alloc]init];

    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - APP下载地址分享
- (void)shareBtnClicked:(id)sender
{
    shareViewController *vc = [[shareViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 修改密码
- (void)changePwdBtnClicked:(id)sender
{
    ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 修改手机号码
- (void)changePhoneBtnClicked:(id)sender
{
    ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//进入省要客业务办理
- (void)doP_VIP:(id)sender
{
    ProvinceVIPViewController *vc = [[ProvinceVIPViewController alloc] init];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

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
//        [self setViewValue];
        [HUD hide:YES];
        
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
//                  withRowAnimation:UITableViewRowAnimationNone];
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
                          
                          self.unfinishedDict = entity[@"content"];
                          id content = entity[@"content"];
                          int num = 0;
                          for (NSString *key in [content allKeys]) {
                              num += [content[key] intValue];
                          }
                          if (num > 0) {

                              [self.mainVC.btnAbout showBadgeWithStyle:WBadgeStyleNumber
                                                            value:num
                                                    animationType:WBadgeAnimTypeNone];
                              
                          }else{
                              
                              [self.mainVC.btnAbout clearBadge];
                          }
//                          [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
//                                    withRowAnimation:UITableViewRowAnimationNone];
                          [_tableView reloadData];
                      }
                      [HUD hide:YES];
                  } Failed:^(int errorCode, NSString *message) {
                      [HUD hide:YES];
                  }];
}

//- (void)getEnableFunction
//{
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    NSDictionary *dict = @{@"method":@"getmodulelist",
//                           @"user_type":userInfo.type_id,
//                           @"user_id":userInfo.user_id};
//    
//    CommonService *service = [[CommonService alloc] init];
//    
//    [service getNetWorkData:dict
//                  Successed:^(id entity) {
//                      int state = [entity[@"state"] intValue];
//                      
//                      if (state == 1) {
//                          id content = entity[@"content"];
//                          
//                          self.enableStr = content;
//                          
//                          [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
//                                    withRowAnimation:UITableViewRowAnimationNone];
//                      }
//                  } Failed:^(int errorCode, NSString *message) {
//                      
//                  }];
//}

//特号配置
- (void)getSpecialConfig
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"special_config",
                           @"user_id":userInfo.user_id};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          id content = entity[@"content"];
                          
                          self.specialConfigStr = content;
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

//- (void) setViewValue
//{
//    UserEntity *entity = [UserEntity sharedInstance];
//    
//    //NSString *city =[[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
//    LocationEntity *locationEntity = [LocationEntity sharedInstance];
//    
////    NSString *name = [NSString stringWithFormat:@"%@ (%@)",entity.tel, locationEntity.name];
////    labelName.text = name;
//    
//    
//    
////    NSString *today = [NSString stringWithFormat:@"%d/%d", [summaryEntity.today_finish intValue], [summaryEntity.today intValue]];
////    labelToday.text = today;
////    NSString *week = [NSString stringWithFormat:@"%d/%d", [summaryEntity.this_week_finish intValue], [summaryEntity.this_week intValue]];
////    labelWeek.text = week;
////    NSString *month = [NSString stringWithFormat:@"%d/%d", [summaryEntity.this_month_finish intValue], [summaryEntity.this_month intValue]];
////    labelMonth.text = month;
////    NSString *lastMonth = [NSString stringWithFormat:@"%d/%d", [summaryEntity.last_month_finish intValue], [summaryEntity.last_month intValue]];
////    labelLastMonth.text = lastMonth;
//}

- (void) loadData
{
    this_month_unvisitArr = [[NSMutableArray alloc]init];
    this_month_visitArr = [[NSMutableArray alloc]init];
    
//    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
//    //读取整型int类型的数据
//    ProvinceVIP_State = [locationDefaults objectForKey:@"ProvinceVIP_State"];
    
    [HUD hide:YES];
    super.model = NSStringFromClass([self class]);
    [self set_logmodel];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    if ([userInfo.type_id intValue] == ROLE_CUSTOMER) { //客户经理才获取走访执行情况
        [self getData];
    }
    
    [self settableviewARR];
    
    if ([ProvinceVIP_State isEqualToString:@"new"]) {
        [self getData_ProvinceVIP];
    }else{
        [self getUnfinishedNum];
    }
    
//    [self getUnfinishedNum];
    
//    [self getEnableFunction];
    
    [self getSpecialConfig];
    
//    [self getData_ProvinceVIP];
    
    [self getThis_month_unvisit];
    
//    [self gettape_num];
}


#pragma mark - 进入子页面

//特号列表
- (void)goSpecialViewController:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_SpecialListViewController *vc = [[P_SpecialListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//预约列表
- (void)goAPPointViewController:(id)sender
{
    P_AppointListViewController *vc = [[P_AppointListViewController alloc]  initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//终端列表
- (void)goTerminalViewController:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_TerminalListViewController *vc = [[P_TerminalListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//退库列表
- (void)goStockViewController:(id)sender
{
    P_StockListViewController *vc = [[P_StockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//终端出库
- (void)goTerminalStockViewController:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_TerminalStockListViewController *vc = [[P_TerminalStockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//维修单列表
- (void)goRepairViewController:(id)sender
{
    P_RepairListViewController *vc = [[P_RepairListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//台账列表
- (void)goBookViewController:(id)sender
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_BookListViewController *vc = [[P_BookListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//办卡列表
- (void)goCardViewController:(id)sender
{
    P_CardListViewController *vc = [[P_CardListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//发票列表
- (void)goBillViewController:(id)sender
{
    P_BillListViewController *vc = [[P_BillListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//营销方案
- (void)goMarketingPlanViewController:(id)sender
{
    P_MarketingPlanViewController *vc = [[P_MarketingPlanViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//产品专线/ims故障处理
- (void)goProduct_LineViewController:(id)sender
{
    Product_LineViewController *vc = [[Product_LineViewController alloc]  initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
}

//退款
- (void)goRefundViewController:(id)sender{
    
    P_RefundViewController *vc = [[P_RefundViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

//分合户
- (void)goP_Household_divisionViewController:(id)sender{
    
    P_Household_divisionViewController *vc = [[P_Household_divisionViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

//纵向行业任务协同
- (void)goP_Vertical_industry_collaborationViewController:(id)sender{
    
    goP_Vertical_industry_collaborationViewController *vc = [[goP_Vertical_industry_collaborationViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

//进账查询     Houston_queryViewController
- (void)goHouston_queryViewController:(id)sender{
    
    Houston_queryViewController *vc = [[Houston_queryViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

//营销方案确认     P_Marketing_PlanListViewController
- (void)goP_Marketing_PlanViewController:(id)sender{
    
    P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}
//基础业务受理     Basic_business_moduleListViewController
- (void)goBasic_business_moduleListViewController:(id)sender{
    
    Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.mainVC.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    if ([ProvinceVIP_State isEqualToString:@"new"]) {
        [self getData_ProvinceVIP];
    }else{
        [self getUnfinishedNum];
    }
    
//    [self gettape_num];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)SingleTop:(UITapGestureRecognizer *)recognizer{
    
    view = [[[NSBundle mainBundle] loadNibNamed:@"UserTableCellHeaderView" owner:nil options:nil] firstObject];
    
    NSInteger didsection = recognizer.view.tag;
    if (!selectedDic) {
        selectedDic = [[NSMutableDictionary alloc]init];
    }

    NSString *key = [NSString stringWithFormat:@"%ld",(long)didsection];
    
    if (![selectedDic objectForKey:key]) {
        [selectedDic setObject:@"1" forKey:key];
        view.down_rightImage.image = [UIImage imageNamed:@"xiala"];
        i = didsection + 1;
    }else{
        [selectedDic removeObjectForKey:key];
        view.down_rightImage.image = [UIImage imageNamed:@"right"];
        i = 0;
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:didsection] withRowAnimation:UITableViewRowAnimationFade];

    
}

- (void)getSettingFromServer
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"push_state"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      if (state == 1) {
                          
                          NSDictionary *dic = entity[@"content"];
                          self.push_starttime = [dic objectForKey:@"push_starttime"];
                          self.push_endtime = [dic objectForKey:@"push_endtime"];

                          [_tableView reloadData];
                      }
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

#pragma mark - 小纸条脚标
- (void)gettape_num
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"tape_num"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      
                      tape_num = entity[@"state"];
                      [_tableView reloadData];
                      
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

- (void)getBirthdayNum
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_num":userInfo.num,
                           @"method":@"get_birthday_num"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      if (state == 1) {
                          
                          self.birthday_num = entity[@"content"];

                          [_tableView reloadData];
                      }
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

- (void)getThis_month_unvisit{
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"this_month_unvisit"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      if (state == 1) {
                          
                          NSDictionary *dic = [entity objectForKey:@"content"];

                          this_month_visit_total_num = [dic objectForKey:@"total_num"];
                          this_month_visited_num = [dic objectForKey:@"visited_num"];
                          this_month_unvisit_num = [dic objectForKey:@"unvisit_num"];
                          
                          NSArray *visitedArr = [dic objectForKey:@"visited"];
                          
                          NSArray *unvisitedArr = [dic objectForKey:@"unvisit"];
                          
                          if (visitedArr.count > 0) {
                              for (NSDictionary *attributes in visitedArr) {
                                  This_month_unvisitEntity *entity = [[This_month_unvisitEntity alloc]init];
                                  entity = [entity initWithAttributes:attributes];
   
                                [this_month_visitArr addObject:entity];

                              }
                          }
                          
                          if (unvisitedArr.count > 0) {
                              for (NSDictionary *attributes in unvisitedArr) {
                                  This_month_unvisitEntity *entity = [[This_month_unvisitEntity alloc]init];
                                  entity = [entity initWithAttributes:attributes];
                                  
                                  [this_month_unvisitArr addObject:entity];
                                  
                              }
                          }
                          
                          [_tableView reloadData];

                      }
                      
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];

}

- (void)successDelegate:(NSString *)push_starttime andWithEndtime:(NSString *)push_endtime{
    
    self.push_starttime = push_starttime;
    self.push_endtime = push_endtime;
    
    [_tableView reloadData];
}

@end
