//
//  Centralized_managementViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/10/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Centralized_managementViewController.h"
#import "UserEntity.h"
#import "Central_manageCollectionViewCell.h"
#import "MainCollectionReusableViewHeadView.h"
#import "News_ProviceVIP_ListViewController.h"
#import "Business_InternationalViewController.h"
#import "CustomerViewController.h"

#import "P_SpecialListViewController.h"
#import "P_AppointListViewController.h"
#import "P_TerminalListViewController.h"
#import "P_StockListViewController.h"
#import "P_RepairListViewController.h"
#import "P_BookListViewController.h"
#import "P_CardListViewController.h"
#import "P_BillListViewController.h"
#import "P_MarketingPlanViewController.h"
#import "P_TerminalStockListViewController.h"
#import "P_RefundViewController.h"
#import "P_Household_divisionViewController.h"
#import "goP_Vertical_industry_collaborationViewController.h"
#import "Houston_queryViewController.h"
#import "Matching_ListViewController.h"
#import "Payment_ListViewController.h"
#import "P_Marketing_PlanListViewController.h"
#import "Basic_business_moduleListViewController.h"

#import "News_ProvinceVip_ListTwoViewController.h"
#import "Marking_CenterDetailViewController.h"

static NSString *cellIdentifier = @"Central_manageCollectionViewCell";
static NSString *HeaderIdentifier = @"headerView";

@interface Centralized_managementViewController ()
{
    NSMutableArray *MainBusinessArr;
    UserEntity *userEntity;
}
@end

@implementation Centralized_managementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _name;
    
    MainBusinessArr = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
 
    userEntity = [UserEntity sharedInstance];
    
    if ([_name isEqualToString:@"集中化管理"] || [_name isEqualToString:@"集中调度"]) {
        [MainBusinessArr addObject:@{@"section":@"1",@"sectionName":@"策略效果评估",@"list":
                                         @[@{@"title":@"欠费回收评估",@"icon":@"营销",@"viewController":@"Marking_CenterDetailViewController",@"VCbool":@"1"}]}];
        [MainBusinessArr addObject:@{@"section":@"2",@"sectionName":@"学习集中管理",@"list":
                                         @[@{@"title":@"资料库",@"icon":@"资料2",@"viewController":@"Product_imformationViewController",@"VCbool":@"1"},
                                           @{@"title":@"祝福短信库",@"icon":@"短信",@"viewController":@"SMS_MessageViewController",@"VCbool":@"1"},
                                           @{@"title":@"案例库",@"icon":@"案例",@"viewController":@"CaseViewController",@"VCbool":@"1"},
//                                           @{@"title":@"营销活动信息库",@"icon":@"营销",@"viewController":@"Markeing_classificationViewController",@"VCbool":@"1"}
                                           ]}];
        if ([userEntity.type_id intValue]== ROLE_CUSTOMER || [userEntity.type_id intValue]== ROLE_PRODUCT) {
            [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"策略集中分发",@"list":
                                            @[@{@"title":@"策略集中分发",@"icon":@"我的订单",@"viewController":@"Policy_distributionListViewController",@"VCbool":@"1"},
                                              @{@"title":@"欠费提醒",@"icon":@"欠费-icon",@"viewController":@"Payment_arrears_listViewController",@"VCbool":@"1"},
                                              @{@"title":@"后付费审批",@"icon":@"p_bill3",@"viewController":@"Postpaid_Create_listViewController",@"VCbool":@"1"},
                                              @{@"title":@"合同到期提醒",@"icon":@"合同",@"viewController":@"Contract_expiresViewController",@"VCbool":@"1"},
                                              @{@"title":@"客户生日提醒",@"icon":@"生日",@"viewController":@"Birthday_listViewController",@"VCbool":@"1"},
                                              @{@"title":@"长期未拜访",@"icon":@"拜访记录",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"}
                                              
                                              ]}];
            
            [MainBusinessArr addObject:@{@"section":@"3",@"sectionName":@"业绩集中测评",@"list":
                                             @[@{@"title":@"在线考试",@"icon":@"在线考试-(1)",@"viewController":@"Examination_SeconViewController",@"VCbool":@"1"},
                                               @{@"title":@"历史试卷",@"icon":@"试卷",@"viewController":@"Exam_historylistViewController",@"VCbool":@"1"},
                                               @{@"title":@"自测",@"icon":@"考试",@"viewController":@"Exam_self_testingViewController",@"VCbool":@"1"},
                                               @{@"title":@"积分排行",@"icon":@"积分",@"viewController":@"Integral_rankingViewController",@"VCbool":@"1"}]}];
    }else{
        if ([userEntity.type_id intValue]== ROLE_THREE || [userEntity.type_id intValue]== ROLE_TWO) {
            [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"策略集中制定",@"list":
                                             @[@{@"title":@"策略集中分发",@"icon":@"我的订单",@"viewController":@"Policy_distributionListViewController",@"VCbool":@"1"},
                                               @{@"title":@"欠费延期任务",@"icon":@"欠费-icon",@"viewController":@"Arrears_task_ListViewController",@"VCbool":@"1"},
                                               @{@"title":@"后付费审批",@"icon":@"p_bill3",@"viewController":@"Postpaid_Create_listViewController",@"VCbool":@"1"},
                                               @{@"title":@"合同到期提醒",@"icon":@"合同",@"viewController":@"Contract_expiresViewController",@"VCbool":@"1"},
                                               @{@"title":@"客户生日提醒",@"icon":@"生日",@"viewController":@"Birthday_listViewController",@"VCbool":@"1"},
                                               @{@"title":@"长期未拜访",@"icon":@"拜访记录",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"},
                                               ]}];
        }else{
            [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"策略集中制定",@"list":
                                             @[@{@"title":@"策略集中分发",@"icon":@"我的订单",@"viewController":@"Policy_distributionListViewController",@"VCbool":@"1"},
                                               @{@"title":@"欠费提醒",@"icon":@"欠费-icon",@"viewController":@"Payment_arrears_listViewController",@"VCbool":@"1"},
//                                               @{@"title":@"欠费延期任务",@"icon":@"欠费-icon",@"viewController":@"Arrears_task_ListViewController",@"VCbool":@"1"},
                                               @{@"title":@"后付费审批",@"icon":@"p_bill3",@"viewController":@"Postpaid_Create_listViewController",@"VCbool":@"1"},
                                               @{@"title":@"合同到期提醒",@"icon":@"合同",@"viewController":@"Contract_expiresViewController",@"VCbool":@"1"},
                                               @{@"title":@"客户生日提醒",@"icon":@"生日",@"viewController":@"Birthday_listViewController",@"VCbool":@"1"},
                                               @{@"title":@"长期未拜访",@"icon":@"拜访记录",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"},
                                               ]}];
        }
        [MainBusinessArr addObject:@{@"section":@"3",@"sectionName":@"业绩集中测评",@"list":
                                         @[@{@"title":@"在线考试",@"icon":@"在线考试-(1)",@"viewController":@"Examination_SeconViewController",@"VCbool":@"1"},
                                           @{@"title":@"历史试卷",@"icon":@"试卷",@"viewController":@"Exam_historylistViewController",@"VCbool":@"1"},
                                           @{@"title":@"积分排行",@"icon":@"积分",@"viewController":@"Integral_rankingViewController",@"VCbool":@"1"}]}];
        
        }
    }else if ([_name isEqualToString:@"统一下单业务"]){
        
        [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"财务管理",@"list":
                                         @[@{@"title":@"开具发票",@"icon":@"p_bill3",@"viewController":@"8",@"VCbool":@"1"},
//                                           @{@"title":@"银行入账匹配",@"icon":@"bank",@"viewController":@"10",@"VCbool":@"1"},
//                                           @{@"title":@"资金回款",@"icon":@"money",@"viewController":@"11",@"VCbool":@"1"},
//                                           @{@"title":@"退款",@"icon":@"退款",@"viewController":@"12",@"VCbool":@"1"},
//                                           @{@"title":@"进账查询",@"icon":@"book",@"viewController":@"15",@"VCbool":@"1"},
                                           @{@"title":@"台账登记",@"icon":@"p_book3",@"viewController":@"1",@"VCbool":@"1"}]}];
        [MainBusinessArr addObject:@{@"section":@"1",@"sectionName":@"基础业务受理",@"list":
                                         @[@{@"title":@"特号办理",@"icon":@"p_special3",@"viewController":@"0",@"VCbool":@"1"},
//                                           @{@"title":@"办卡",@"icon":@"p_card3",@"viewController":@"7",@"VCbool":@"1"},
                                           @{@"title":@"终端订货",@"icon":@"p_terminal3",@"viewController":@"2",@"VCbool":@"1"},
                                           @{@"title":@"终端退库",@"icon":@"p_stock3",@"viewController":@"3",@"VCbool":@"1"},
                                           @{@"title":@"终端出库",@"icon":@"p_terminale3",@"viewController":@"4",@"VCbool":@"1"},
                                           @{@"title":@"终端售后维修",@"icon":@"p_repair3",@"viewController":@"5",@"VCbool":@"1"},
//                                           @{@"title":@"领导预约拜访",@"icon":@"p_appoint3",@"viewController":@"6",@"VCbool":@"1"},
//                                           @{@"title":@"营销方案更改",@"icon":@"p_marking",@"viewController":@"9",@"VCbool":@"1"},
//                                           @{@"title":@"分合户",@"icon":@"分合户",@"viewController":@"13",@"VCbool":@"1"},
//                                           @{@"title":@"纵向行业任务协同",@"icon":@"纵向行业任务协同",@"viewController":@"14",@"VCbool":@"1"},
//                                           @{@"title":@"集团划拨",@"icon":@"p_stock3",@"viewController":@"16",@"VCbool":@"1"},
                                           @{@"title":@"营销方案确认",@"icon":@"确认方案",@"viewController":@"17",@"VCbool":@"1"},
                                           @{@"title":@"基础业务受理",@"icon":@"24-业务受理列表",@"viewController":@"18",@"VCbool":@"1"}]}];

    }else if ([_name isEqualToString:@"走访任务系统"]){
        
//        if ([userEntity.type_id intValue] == ROLE_CUSTOMER || [userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE ){
//
//            [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"",@"list":
//                                             @[@{@"title":@"制定走访任务",@"icon":@"新建",@"viewController":[userEntity.is_first isEqual:@"1"]?@"Task_Two_CreateViewController":@"TaskCreateViewController",@"VCbool":@"1"},
//                                               @{@"title":@"走访任务列表",@"icon":@"查找表单列表",@"viewController":@"TaskListViewController",@"VCbool":@"1"},
//                                               @{@"title":@"长期未拜访",@"icon":@"时间",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"},
//                                               @{@"title":@"实时定位查看",@"icon":@"定位(1)",@"viewController":@"LocationViewViewController",@"VCbool":@"1"},
//                                               @{@"title":@"信息实时查看",@"icon":@"订单详情",@"viewController":@"InformationViewViewController",@"VCbool":@"1"}]}];
//        }
//
//        if ([userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE || [userEntity.type_id intValue] == ROLE_PRODUCT){
//
//            [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"",@"list":
//                                             @[@{@"title":@"制定走访任务",@"icon":@"新建",@"viewController":[userEntity.is_first isEqual:@"1"]?@"Task_Two_CreateViewController":@"TaskCreateViewController",@"VCbool":@"1"},
//                                               @{@"title":@"走访任务列表",@"icon":@"查找表单列表",@"viewController":@"TaskListViewController",@"VCbool":@"1"},
//                                               @{@"title":@"长期未拜访",@"icon":@"时间",@"viewController":@"No_visit_baselistViewController",@"VCbool":@"1"},
//                                               @{@"title":@"产品经理走访",@"icon":@"bm_directory",@"viewController":@"Product_VisitListViewController",@"VCbool":@"1"}]}];
//
//        }
        [MainBusinessArr addObject:@{@"title":@"制定走访任务",@"icon":@"新建",@"viewController":[userEntity.is_first isEqual:@"1"]?@"Task_Two_CreateViewController":@"TaskCreateViewController"}];  //  首席看管
        
        [MainBusinessArr addObject:@{@"title":@"走访任务列表",@"icon":@"查找表单列表",@"viewController":@"TaskListViewController"}];
        [MainBusinessArr addObject:@{@"title":@"长期未拜访",@"icon":@"时间",@"viewController":@"No_visit_baselistViewController"}];
        
        if ([userEntity.type_id intValue] == ROLE_CUSTOMER || [userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE ){
            
            [MainBusinessArr addObject:@{@"title":@"实时定位查看",@"icon":@"定位(1)",@"viewController":@"LocationViewViewController"}];
            
            [MainBusinessArr addObject:@{@"title":@"信息实时查看",@"icon":@"订单详情",@"viewController":@"InformationViewViewController"}];
        }
        
        if ([userEntity.type_id intValue] == ROLE_TWO || [userEntity.type_id intValue] == ROLE_THREE || [userEntity.type_id intValue] == ROLE_PRODUCT){
            
            [MainBusinessArr addObject:@{@"title":@"产品经理走访",@"icon":@"bm_directory",@"viewController":@"Product_VisitListViewController"}];
            
        }
        
    }else if ([_name isEqualToString:@"订单中心"] | [_name isEqualToString:@"订单管理"]){

        [MainBusinessArr addObject:@{@"title":@"业务联系人",@"icon":@"联系人",@"viewController":@"Business_contacts_ListViewController",@"VCbool":@"1"}];
        
        if ([userEntity.type_id intValue] != ROLE_SOCOALCHANNEL) {
            
            if ([userEntity.type_id intValue]== ROLE_CUSTOMER || [userEntity.type_id intValue]== ROLE_THREE) {
                
                [MainBusinessArr addObject:@{@"title":@"订单需求发起",@"icon":@"订单需求发起",@"viewController":@"CustomerViewController",@"VCbool":@"1"}];
            }
            
            [MainBusinessArr addObject:@{@"title":@"我的订单",@"icon":@"我的订单",@"viewController":@"M_Order_demandViewController",@"VCbool":@"1"}];
            [MainBusinessArr addObject:@{@"title":@"故障投诉",@"icon":@"投诉",@"viewController":@"Trouble_callListViewController",@"VCbool":@"1"}];
            [MainBusinessArr addObject:@{@"title":@"业务变更",@"icon":@"业务变更",@"viewController":@"Business_change_listViewController",@"VCbool":@"1"}];
        }
        
        if ([userEntity.type_id intValue] != ROLE_CUSTOMER) {
            
            if ([userEntity.type_id intValue] == ROLE_SOCOALCHANNEL) {
                [MainBusinessArr addObject:@{@"title":@"SA专用发起",@"icon":@"p_book3",@"viewController":@"SA_ListViewController",@"VCbool":@"1"}];
            }
            
            [MainBusinessArr addObject:@{@"title":@"我的SA工单",@"icon":@"分合户",@"viewController":@"SA_SpecialViewController",@"VCbool":@"1"}];
        }
        
//        [MainBusinessArr addObject:@{@"title":@"专线平台工单",@"icon":@"联系人",@"viewController":@"Special_line_platformViewController",@"VCbool":@"1"}];
//        [MainBusinessArr addObject:@{@"title":@"超时工单",@"icon":@"联系人",@"viewController":@"Overtime_workListViewController",@"VCbool":@"1"}];
        
    }else if ([_name isEqualToString:@"CRM业务"] | [_name isEqualToString:@"业务受理"]){
        [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"",@"list":
                                         @[@{@"title":@"集团V网",@"icon":@"网络",@"viewController":@"Business_Group_V_NetViewController",@"VCbool":@"1"},
                                           @{@"title":@"彩铃",@"icon":@"彩铃",@"viewController":@"Business_Coloring_RingViewController",@"VCbool":@"1"},
                                           @{@"title":@"集团号簿",@"icon":@"电话本",@"viewController":@"Business_Group_DirectoruyViewController",@"VCbool":@"1"},
                                           @{@"title":@"国际漫游",@"icon":@"飞行漫游",@"viewController":@"Business_InternationalViewController",@"VCbool":@"1",@"VCNum":@"1"},
                                           @{@"title":@"成员管理",@"icon":@"成员",@"viewController":@"Bussiness_CustomerViewController",@"VCbool":@"1"},
                                           @{@"title":@"产品查询退订",@"icon":@"查询(3)",@"viewController":@"Bussiness_productViewController",@"VCbool":@"1"},
                                           @{@"title":@"集团账单",@"icon":@"账单",@"viewController":@"Business_groupBillViewController",@"VCbool":@"1"},
                                           @{@"title":@"营销活动",@"icon":@"活动2",@"viewController":@"Business_InternationalViewController",@"VCbool":@"1",@"VCNum":@"2"},
                                           @{@"title":@"白名单查询",@"icon":@"名单",@"viewController":@"White_list_queryViewController",@"VCbool":@"1"}]}];
    }else if ([_name isEqualToString:@"生产管理"]){
        [MainBusinessArr addObject:@{@"section":@"0",@"sectionName":@"走访任务管理",@"list":
                                         @[@{@"title":@"制定走访任务",@"icon":@"新建",@"viewController":[userEntity.is_first isEqual:@"1"]?@"Task_Two_CreateViewController":@"TaskCreateViewController"},
                                        
                                          @{@"title":@"走访任务列表",@"icon":@"查找表单列表",@"viewController":@"TaskListViewController"},
                                          @{@"title":@"长期未拜访",@"icon":@"时间",@"viewController":@"No_visit_baselistViewController"},
                                           @{@"title":@"实时定位查看",@"icon":@"定位(1)",@"viewController":@"LocationViewViewController"},
                                           @{@"title":@"信息实时查看",@"icon":@"订单详情",@"viewController":@"InformationViewViewController"},
                                           @{@"title":@"产品经理走访",@"icon":@"bm_directory",@"viewController":@"Product_VisitListViewController"}]}];
        [MainBusinessArr addObject:@{@"section":@"1",@"sectionName":@"嵌入式审批",@"list":
                                         @[@{@"title":@"开具发票",@"icon":@"p_bill3",@"viewController":@"8",@"VCbool":@"1"},
                                           @{@"title":@"台账登记",@"icon":@"p_book3",@"viewController":@"1",@"VCbool":@"1"},
                                           @{@"title":@"特号办理",@"icon":@"p_special3",@"viewController":@"0",@"VCbool":@"1"},
                                           @{@"title":@"营销方案确认",@"icon":@"确认方案",@"viewController":@"17",@"VCbool":@"1"},
                                           @{@"title":@"基础业务受理",@"icon":@"24-业务受理列表",@"viewController":@"18",@"VCbool":@"1"}]}];
        [MainBusinessArr addObject:@{@"section":@"2",@"sectionName":@"终端管理",@"list":
                                         @[@{@"title":@"终端订货",@"icon":@"p_terminal3",@"viewController":@"2",@"VCbool":@"1"},
                                           @{@"title":@"终端退库",@"icon":@"p_stock3",@"viewController":@"3",@"VCbool":@"1"},
                                           @{@"title":@"终端出库",@"icon":@"p_terminale3",@"viewController":@"4",@"VCbool":@"1"},
                                           @{@"title":@"终端售后维修",@"icon":@"p_repair3",@"viewController":@"5",@"VCbool":@"1"}]}];
        
    }else if ([_name isEqualToString:@"商机管理"]){
        [MainBusinessArr addObject:@{@"title":@"商机推送",@"icon":@"我的订单",@"viewController":@"",@"VCbool":@"1"}];
        [MainBusinessArr addObject:@{@"title":@"商机认领",@"icon":@"查询(3)",@"viewController":@"",@"VCbool":@"1"}];
        [MainBusinessArr addObject:@{@"title":@"商机确认",@"icon":@"活动2",@"viewController":@"",@"VCbool":@"1",@"VCNum":@"2"}];
    }else if ([_name isEqualToString:@"业务展示"]){
        [MainBusinessArr addObject:@{@"title":@"规章制度",@"icon":@"我的订单",@"viewController":@"",@"VCbool":@"1"}];
        [MainBusinessArr addObject:@{@"title":@"产品信息",@"icon":@"查询(3)",@"viewController":@"",@"VCbool":@"1"}];
        [MainBusinessArr addObject:@{@"title":@"营销活动",@"icon":@"活动2",@"viewController":@"",@"VCbool":@"1",@"VCNum":@"2"}];
    }else{
        
    }
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([MainCollectionReusableViewHeadView class])  bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];//注册加载头
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scorllorView代理

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (MainBusinessArr.count > 1 && !([_name isEqualToString:@"订单中心"] | [_name isEqualToString:@"订单管理"]) && ![_name isEqualToString:@"走访任务系统"] && ![_name isEqualToString:@"业务展示"] && ![_name isEqualToString:@"商机管理"]) {
        
        return MainBusinessArr.count;
    
    }else{
    
        return 1;
    
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!([_name isEqualToString:@"订单中心"] | [_name isEqualToString:@"订单管理"]) && ![_name isEqualToString:@"走访任务系统"] && ![_name isEqualToString:@"业务展示"] && ![_name isEqualToString:@"商机管理"]) {
        
        for (NSDictionary *dic in MainBusinessArr) {
            
            if ([[dic objectForKey:@"section"] intValue] == section) {
                 return [[dic objectForKey:@"list"] count];
            }
        }
        
//        for (int iC = 0; iC < MainBusinessArr.count; iC++) {
//
//            if (section == iC) {
//                return [[[MainBusinessArr objectAtIndex:iC] objectForKey:@"list"] count];
//            }
//
//        }
        return 0;
        
    }else{
        return MainBusinessArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Central_manageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([_name isEqualToString:@"订单中心"] || [_name isEqualToString:@"走访任务系统"] || [_name isEqualToString:@"订单管理"] || [_name isEqualToString:@"业务展示"] || [_name isEqualToString:@"商机管理"]) {
        cell.titleLable.text = [[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.iconImageView.image = [UIImage imageNamed:[[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"icon"]];
    }else{
        
        for (NSDictionary *dic in MainBusinessArr) {
            
            if ([[dic objectForKey:@"section"] intValue] == indexPath.section) {
                cell.titleLable.text = [[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"];
                cell.iconImageView.image = [UIImage imageNamed:[[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"icon"]];
//                cell.titleLable.text = [[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"];
//                cell.iconImageView.image = [UIImage imageNamed:[[[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"icon"]];
            }
        }
        
    }
   
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLable.font = [UIFont systemFontOfSize:12];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        MainCollectionReusableViewHeadView *headerView = (MainCollectionReusableViewHeadView *)view;
        
        headerView.backgroundColor = RGBCOLOR(247, 247, 247, 1);
        headerView.titilabel.font = [UIFont systemFontOfSize:13];
        headerView.titilabel.textColor = RGBCOLOR(130, 130, 130, 1);
        
        for (NSDictionary *dic in MainBusinessArr) {
            
            if ([[dic objectForKey:@"section"] intValue] == indexPath.section) {
                headerView.titilabel.text = [dic objectForKey:@"sectionName"];
            }
        }

        return headerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if ([_name isEqualToString:@"订单中心"] || [_name isEqualToString:@"走访任务系统"] || [_name isEqualToString:@"订单管理"] || [_name isEqualToString:@"业务展示"] || [_name isEqualToString:@"商机管理"]) {
    
        NSString *ControllerStr = [[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"viewController"];
        
        if ([ControllerStr isEqualToString:@"CustomerViewController"]) {
            
            CustomerViewController *vc = [[CustomerViewController alloc]init];
            
            vc.enter_type = 7;
            
            vc.info = @"订单需求发起";
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([ControllerStr isEqualToString:@"Business_InternationalViewController"]) {
            
            Business_InternationalViewController *vc = [[Business_InternationalViewController alloc] init];
            vc.num = [[[MainBusinessArr objectAtIndex:indexPath.row] objectForKey:@"VCNum"] intValue];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            UIViewController* viewController = [[NSClassFromString(ControllerStr) alloc] init];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else{
        
        for (NSDictionary *dic in MainBusinessArr) {
            
            if ([[dic objectForKey:@"section"] intValue] == indexPath.section) {
                
                NSString *ControllerStr = [[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"viewController"];
                
                [self Select_Frequency:[[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
                
                if ([ControllerStr isEqualToString:@"Business_InternationalViewController"]) {
                    
                    Business_InternationalViewController *vc = [[Business_InternationalViewController alloc] init];
                    vc.num = [[[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"VCNum"] intValue];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if ([ControllerStr isEqualToString:@"Marking_CenterDetailViewController"]) {
                    
                    Marking_CenterDetailViewController *vc = [[Marking_CenterDetailViewController alloc] init];
                    vc.Title = [[[dic objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"];
                    vc.url = [NSString stringWithFormat:@"http://sw.dayo.net.cn/gzcms/pay_back.php?id=%@",userEntity.user_id];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    
                    if ([_name isEqualToString:@"统一下单业务"] || [[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"sectionName"] isEqualToString:@"嵌入式审批"] || [[[MainBusinessArr objectAtIndex:indexPath.section] objectForKey:@"sectionName"] isEqualToString:@"终端管理"]) {
                        
                        [self goProvinceVip:[ControllerStr integerValue]];
                        
                    }else{
                        
                        UIViewController* viewController = [[NSClassFromString(ControllerStr) alloc] init];
                        
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    
                }
                
            }
        }
        
      
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 10)/4, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (MainBusinessArr.count > 1 && !([_name isEqualToString:@"订单中心"] | [_name isEqualToString:@"订单管理"])&& ![_name isEqualToString:@"走访任务系统"] && ![_name isEqualToString:@"业务展示"] && ![_name isEqualToString:@"商机管理"]) {
        
        return CGSizeMake(collectionView.bounds.size.width, 25);

    }else{
        
        return CGSizeMake(collectionView.bounds.size.width, 0);

    }
    
}

- (void)goProvinceVip:(NSInteger)num {
    switch (num) {
        case 0:
        {
            [self goSpecialViewController:nil];
            break;
        }
        case 1:
        {
            [self goBookViewController:nil];
            break;
        }
        case 2:
        {
            [self goTerminalViewController:nil];
            break;
        }
        case 3:
        {
            [self goStockViewController:nil];
            
            break;
        }
        case 4:
        {
            [self goTerminalStockViewController:nil];
            break;
        }
        case 5:
        {
            [self goRepairViewController:nil];
            break;
        }
        case 6:
        {
            [self goAPPointViewController:nil];
            break;
        }
        case 7:
        {
            [self goCardViewController:nil];
            break;
        }
        case 8:
        {
            [self goBillViewController:nil];
            break;
        }
        case 9:
        {
            [self goMarketingPlanViewController:nil];
            break;
        }
        case 10:
        {
            [self goMatching_ListViewController:nil];
            break;
        }
        case 11:
        {
            [self goPayment_ListViewController:nil];
            break;
        }
        case 12:
        {
            [self goRefundViewController:nil];
            break;
        }
        case 13:
        {
            [self goP_Household_divisionViewController:nil];
            break;
        }
        case 14:
        {
            [self goP_Vertical_industry_collaborationViewController:nil];
            break;
        }case 15:
        {
            [self goHouston_queryViewController:nil];
            break;
        }case 16:
        {
            [self goNews_ProviceVIP_ListViewController:nil];
            break;
        }case 17:
        {
            [self goP_Marketing_PlanViewController:nil];
            break;
        }case 18:
        {
            [self goBasic_business_moduleListViewController:nil];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 子界面的进入次数

- (void) Select_Frequency:(NSString *)title{
    
    NSString *info;
    
    if ([title isEqualToString:@"制定走访任务"]) {
        info = @"制定拜访任务";
    }else if ([title isEqualToString:@"国际漫游"]) {
        info = @"国际漫游";
    }else if ([title isEqualToString:@"营销活动"]) {
        info = @"营销活动查询";
    }else if ([title isEqualToString:@"白名单查询"]) {
        info = @"白名单查询";
    }
    
    if (info.length > 0) {
        
        [self frequency_statistics:info];
    
    }
    
}

#pragma mark - 进入子页面

//特号列表
- (void)goSpecialViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"1";
//    vc.titleName = @"特号列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    P_SpecialListViewController *vc = [[P_SpecialListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//预约列表
- (void)goAPPointViewController:(id)sender
{
    P_AppointListViewController *vc = [[P_AppointListViewController alloc]  initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//终端列表
- (void)goTerminalViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"3";
//    vc.titleName = @"终端列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_TerminalListViewController *vc = [[P_TerminalListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//退库列表
- (void)goStockViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"4";
//    vc.titleName = @"退库列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_StockListViewController *vc = [[P_StockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//终端出库
- (void)goTerminalStockViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"9";
//    vc.titleName = @"终端出库列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_TerminalStockListViewController *vc = [[P_TerminalStockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//维修单列表
- (void)goRepairViewController:(id)sender
{
    P_RepairListViewController *vc = [[P_RepairListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//台账列表
- (void)goBookViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"6";
//    vc.titleName = @"台账列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_BookListViewController *vc = [[P_BookListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//办卡列表
- (void)goCardViewController:(id)sender
{
    P_CardListViewController *vc = [[P_CardListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//发票列表
- (void)goBillViewController:(id)sender
{
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"8";
//    vc.titleName = @"发票列表";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_BillListViewController *vc = [[P_BillListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//营销方案
- (void)goMarketingPlanViewController:(id)sender
{
    P_MarketingPlanViewController *vc = [[P_MarketingPlanViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//银行入账匹配
- (void)goMatching_ListViewController:(id)sender{
    Matching_ListViewController *vc = [[Matching_ListViewController alloc]initWithNibName:@"Matching_ListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//资金回款
- (void)goPayment_ListViewController:(id)sender{
    
    Payment_ListViewController *vc = [[Payment_ListViewController alloc]initWithNibName:@"Payment_ListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//退款
- (void)goRefundViewController:(id)sender{
    
    P_RefundViewController *vc = [[P_RefundViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//分合户
- (void)goP_Household_divisionViewController:(id)sender{
    
    P_Household_divisionViewController *vc = [[P_Household_divisionViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//纵向行业协同     Vertical_industry_collaboration
- (void)goP_Vertical_industry_collaborationViewController:(id)sender{
    
    goP_Vertical_industry_collaborationViewController *vc = [[goP_Vertical_industry_collaborationViewController alloc]initWithNibName:@"goP_Vertical_industry_collaborationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//进账查询     Houston_queryViewController
- (void)goHouston_queryViewController:(id)sender{
    
    Houston_queryViewController *vc = [[Houston_queryViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//营销方案确认     P_Marketing_PlanListViewController
- (void)goP_Marketing_PlanViewController:(id)sender{
    
//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"15";
//    vc.titleName = @"营销方案确认";
//    [self.navigationController pushViewController:vc animated:YES];
    
    P_Marketing_PlanListViewController *vc = [[P_Marketing_PlanListViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//基础业务受理     Basic_business_moduleListViewController
- (void)goBasic_business_moduleListViewController:(id)sender{

//    News_ProvinceVip_ListTwoViewController *vc = [[News_ProvinceVip_ListTwoViewController alloc]init];
//    vc.typeId = @"16";
//    vc.titleName = @"基础业务受理";
//    [self.navigationController pushViewController:vc animated:YES];
    
    Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//动态配置     News_ProviceVIP_ListViewController
- (void)goNews_ProviceVIP_ListViewController:(id)sender{
    
    News_ProviceVIP_ListViewController *vc = [[News_ProviceVIP_ListViewController alloc]init];
    vc.module_id = @"80";
    vc.name = @"集团划拨";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
