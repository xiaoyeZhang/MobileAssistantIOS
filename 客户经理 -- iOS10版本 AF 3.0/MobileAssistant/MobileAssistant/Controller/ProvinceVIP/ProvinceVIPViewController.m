    //
//  ProvinceVIPViewController.m
//  MobileAssistant
//
//  Created by xy on 15/9/29.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "ProvinceVIPViewController.h"
#import "ShortcutItemCollectionViewCell.h"
#import "ImageCollectionReusableView.h"
#import "FunctionListModel.h"
#import "MJExtension.h"
//#import "P_APPointViewController.h"
#import "P_SpecialListViewController.h"
#import "P_AppointListViewController.h"
#import "P_TerminalListViewController.h"
#import "P_StockListViewController.h"
#import "P_RepairListViewController.h"
#import "P_BookListViewController.h"
#import "P_CardListViewController.h"
#import "P_BillListViewController.h"
#import "P_MarketingPlanViewController.h"
#import "Product_LineViewController.h"
//#import "WZLBadgeImport.h"
#import "UIColor+Hex.h"
#import "P_TerminalStockListViewController.h"
#import "UserEntity.h"
#import "Matching_ListViewController.h"
#import "Payment_ListViewController.h"
#import "P_RefundViewController.h"
#import "P_Household_divisionViewController.h"
#import "goP_Vertical_industry_collaborationViewController.h"
#import "Houston_queryViewController.h"
#import "News_ProviceVIP_ListViewController.h"

#define COLLECTIONVIEWHEIGHT (_collectionView.bounds.size.height-5*5-135 - 50)/3
#define COLLECTIONVIEWWIDTH (_collectionView.bounds.size.width - 4)/3

static NSString *cellIdentifier = @"ShortcutItemCollectionViewCell";
static NSString *headerIdentifier = @"ImageCollectionReusableView";

@interface ProvinceVIPViewController ()
{
    NSMutableArray *funcMuArr;
    FunctionListModel *APPointmodel;
    FunctionListModel *Cardmodel;
    FunctionListModel *Billmodel;
    FunctionListModel *MarketingPlanmodel;
    
    UILabel *APPointLabel;
    UILabel *BillLabel;
    UILabel *CardLabel;
    UILabel *MarketingPlanLabel;
    
    UIImageView *APPointImage;
    UIImageView *CardImage;
    UIImageView *BillImage;
    UIImageView *MarketingPlanImage;
    int i;
}
@property(nonatomic, copy) NSString *enableStr;
@property(nonatomic, strong) NSDictionary *unfinishedDict;
@property(nonatomic, copy) NSString *specialConfigStr;
@end

@implementation ProvinceVIPViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    self.navigationItem.title = @"统一下单业务受理";
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.isClick = NO;

    super.model = NSStringFromClass([self class]);

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *nib = [UINib nibWithNibName:headerIdentifier bundle:nil];
    [_collectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerIdentifier];
    
    nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    [self initDisplayData];
    
    [self getEnableFunction];
    
    [self getUnfinishedNum];
    
    [self getSpecialConfig];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - ButtonMethod

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)initDisplayData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FunctionList" ofType:@"plist"];
    
    funcMuArr = [[NSMutableArray alloc] initWithArray:[FunctionListModel objectArrayWithFile:filePath]];
    
//    [funcMuArr removeLastObject];
    
    [_collectionView reloadData];
}


- (BOOL)checkIfFunctionDisabledWithIndex:(NSInteger)index
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    if (index == 2|
        index == 3|
        index == 4|
        index == 5) {
        if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
            return YES;
        }
    }
    
    NSArray *strArray = [[NSArray alloc] init];
    NSString *indexStr = nil;
    
    
    strArray = [self.enableStr componentsSeparatedByString:@","];
    if (self.enableStr.length == 0) {
        return NO; //此处应为YES默认禁用  他人不听建议默认开启
    }else{
        
        switch (index) {
            case 0:
                indexStr = @"1";
                break;
            case 1:
                indexStr = @"6";
                break;
            case 2:
                indexStr = @"3";
                break;
            case 3:
                indexStr = @"4";
                break;
            case 4:
                indexStr = @"9";
                break;
            case 5:
                indexStr = @"5";
                break;
            case 6:
                indexStr = @"2";
                break;
            case 7:
                indexStr = @"7";
                break;
            case 8:
                indexStr = @"8";
                break;
            case 9:
                indexStr = @"10";
                break;
            case 10:
                indexStr = @"11";
                break;
            case 11:
                indexStr = @"11";
                break;
            case 12:
                indexStr = @"12";
                break;
            case 13:
                indexStr = @"13";
                break;
            case 15:
                indexStr = @"14";
                break;
            default:
                break;

        }
        for (i = 0 ; i < strArray.count ; i++) {
            
            NSString *str = strArray[i];
            
            if ([str isEqualToString:indexStr]) {
                
                return NO;
            }else{
                if (i == strArray.count -1) {
                    return YES;
                }else{
                    
                }
                
            }
        }
        
    }
    
    return NO; //此处应为YES默认禁用  他人不听建议默认开启
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
                          self.unfinishedDict = content;
                          [_collectionView reloadData];
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

- (void)getEnableFunction
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"getmodulelist",
                           @"user_type":userInfo.type_id,
                           @"user_id":userInfo.user_id};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          id content = entity[@"content"];
                          
                          self.enableStr = content;
                          
                          [_collectionView reloadData];
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}

#pragma mark -

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

#pragma mark -

- (int)showUnfinishedNumWithIndex:(NSInteger)index
{
    int num = 0;
    UserEntity *userEntity = [UserEntity sharedInstance];
    switch (index) {
        case 0: //特号
            num = [self.unfinishedDict[@"t1"] intValue] + [self.unfinishedDict[@"t2"] intValue];
            break;
        case 1: //台账登记
            num = [self.unfinishedDict[@"t8"] intValue] + [self.unfinishedDict[@"t9"] intValue] + [self.unfinishedDict[@"t16"] intValue];
            break;
        case 2: //终端订货
            num = [self.unfinishedDict[@"t4"] intValue];
            
            break;
        case 3: //终端退库
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
                num = [self.unfinishedDict[@"t5"] intValue];
            }
            
            break;
        case 4: //终端出库
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
                num = [self.unfinishedDict[@"t15"] intValue] + [self.unfinishedDict[@"t17"] intValue];
            }
            break;
        case 5: //售后维修
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
                num = [self.unfinishedDict[@"t6"] intValue] + [self.unfinishedDict[@"t7"] intValue];
            }
            break;
            
        case 6: //公司领导预约拜访
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
                num = [self.unfinishedDict[@"t19"] intValue];
                
            }else{
                num = [self.unfinishedDict[@"t3"] intValue];
            }
            
            break;
        case 7: //办卡
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
               num = [self.unfinishedDict[@"t10"] intValue] + [self.unfinishedDict[@"t11"] intValue];
            }
            break;
            
            
        case 8: //开具发票
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
                num = [self.unfinishedDict[@"t12"] intValue] + [self.unfinishedDict[@"t13"] intValue] + [self.unfinishedDict[@"t14"] intValue];
            }
            break;
            
        case 9: //营销方案更改
            if ([userEntity.dep_id rangeOfString:@"10007"].location != NSNotFound) {
                
            }else{
                num = [self.unfinishedDict[@"t18"] intValue];
            }
            break;
            
        case 10: //银行入账匹配

            break;
            
        case 11: //资金回款

            break;
        case 12: //退款

            num = [self.unfinishedDict[@"t20"] intValue];
            
            break;
        case 13: //分合户
            
            num = [self.unfinishedDict[@"t21"] intValue];
            
            break;
        case 14: //纵向行业任务协同
            
            num = [self.unfinishedDict[@"t-1"] intValue];
            
            break;
        case 15: //进账
            
            num = [self.unfinishedDict[@"t22"] intValue];
            
            break;
        default:
            break;

    }
    
    return num;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [funcMuArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionListModel *model = funcMuArr[indexPath.row];
    
    ShortcutItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.titleLbl.text = model.title;
    cell.titleLbl.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    
    if (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 14 || indexPath.row == 16) {
        cell.iconImageView.image = [UIImage imageNamed:model.normalImageName];
    }else{
         model.isDisabled = [self checkIfFunctionDisabledWithIndex:indexPath.row];
        
        if (!model.isDisabled) {
            cell.iconImageView.image = [UIImage imageNamed:model.normalImageName];
        }else{
            cell.iconImageView.image = [UIImage imageNamed:model.disabledImageName];
        }
    }
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundColor = [UIColor whiteColor];
    int num = [self showUnfinishedNumWithIndex:indexPath.row];

    [cell.iconImageView showBadgeWithStyle:WBadgeStyleNumber
                                     value:num
                             animationType:WBadgeAnimTypeNone];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]){
        ImageCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:headerIdentifier
                                                                                      forIndexPath:indexPath];
        
        return view;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    FunctionListModel *model = funcMuArr[indexPath.row];
    if (model.isDisabled) {
        return;
    }
    
    switch (indexPath.row) {
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
        }
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width-4)/3, (collectionView.bounds.size.height-5*5-135-50)/3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 135);
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
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_TerminalListViewController *vc = [[P_TerminalListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
    [self.navigationController pushViewController:vc animated:YES];
}

//退库列表
- (void)goStockViewController:(id)sender
{
    P_StockListViewController *vc = [[P_StockListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    UserEntity *userInfo = [UserEntity sharedInstance];
    if (!self.specialConfigStr && [userInfo.type_id intValue] == ROLE_COMMON) {
        ALERT_ERR_MSG(@"未获取到可执行状态请重试!");
        return;
    }
    
    P_BookListViewController *vc = [[P_BookListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    vc.specialConfigStr = self.specialConfigStr;
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
    P_BillListViewController *vc = [[P_BillListViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//营销方案
- (void)goMarketingPlanViewController:(id)sender
{
    P_MarketingPlanViewController *vc = [[P_MarketingPlanViewController alloc] initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//产品专线/ims故障处理
- (void)goProduct_LineViewController:(id)sender
{
    Product_LineViewController *vc = [[Product_LineViewController alloc]  initWithNibName:@"P_BusinessBaseViewController" bundle:nil];
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

//动态配置     News_ProviceVIP_ListViewController
- (void)goNews_ProviceVIP_ListViewController:(id)sender{
    
    News_ProviceVIP_ListViewController *vc = [[News_ProviceVIP_ListViewController alloc]init];
    vc.module_id = @"80";
    vc.name = @"集团划拨";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [self getUnfinishedNum];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
