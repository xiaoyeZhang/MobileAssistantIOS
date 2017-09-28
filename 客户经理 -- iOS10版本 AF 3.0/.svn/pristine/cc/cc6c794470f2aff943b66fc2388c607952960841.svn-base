//
//  Bussiness_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Bussiness_ListViewController.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "Business_DetailViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "UserEntity.h"
#import "CompEntity.h"

@interface Bussiness_ListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *selectArray;
    NSString *str;
    NSTimer *timer1;
    int count;
}

@end

@implementation Bussiness_ListViewController

- (void)dealloc
{
    [refreshHeader free];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textFieldKey.returnKeyType = UIReturnKeyDone;
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.arrayCutomer = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];
    selectArray = [[NSMutableArray alloc]init];
    self.title = @"集团产品列表";

    self.CononentName.text = self.entity.name;
    self.CononentNum.text = self.entity.num;
    
    self.output.alpha = 0;
    [self loadData];
    
    [self addRefreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.arrayCustomerTemp removeAllObjects];
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableViewList;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf doTask];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCustomerTemp count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GroupOrderModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    cell.CustomerName.text = entity.OfferName;
    
//    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
//    [formater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [formater setDateFormat:@"yyyyMMdd"];
//    NSDate* EffectiveDate = [formater dateFromString:entity.EffectiveDate];
    NSString *EffectiveDate = @"";
    NSString *ExpireDate = @"";
    if (entity.EffectiveDate.length != 0) {
        EffectiveDate=[NSString stringWithFormat:@"生效时间：%@-%@-%@",
                           [entity.EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                           [entity.EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                           [entity.EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
    }
    if (entity.EffectiveDate.length != 0) {
        ExpireDate=[NSString stringWithFormat:@"失效时间：%@-%@-%@",
                       [entity.ExpireDate substringWithRange:NSMakeRange(0, 4)],
                       [entity.ExpireDate substringWithRange:NSMakeRange(4, 2)],
                       [entity.ExpireDate substringWithRange:NSMakeRange(6, 2)]];
    }
    
    cell.CustomerNum.text = EffectiveDate;
    cell.CustomerAddress.text = ExpireDate;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_DetailViewController *vc = [[Business_DetailViewController alloc]init];
    vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    vc.GroupId = self.entity.num;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void) doTask
{

    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance]; 
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_GetGroupOrder",
                           @"user_id":userEntity.user_id,
                           @"GroupId":self.entity.num,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"OfferInstInfo"];
            [self.arrayCutomer removeAllObjects];
            [self.arrayCustomerTemp removeAllObjects];
            for (NSDictionary* attributes in array) {
                GroupOrderModel *GroupOrderentity = [[GroupOrderModel alloc] init];
                GroupOrderentity = [GroupOrderentity initWithAttributes:attributes];
                [self.arrayCutomer addObject:GroupOrderentity];
                [self.arrayCustomerTemp addObject:GroupOrderentity];
            }
            [self.tableViewList reloadData];

        }
        else
        {
        
            ALERT_ERR_MSG(entity[@"msg"]);
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
}

//- (void)aleartShow:(NSString *)message{
//    
//    if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
//        ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 1;
//        }];
//        
//        timer1 = [NSTimer scheduledTimerWithTimeInterval:1
//                                                  target:self
//                                                selector:@selector(show)
//                                                userInfo:nil
//                                                 repeats:YES];
//        [timer1 fire];
//    }
//}
//
//- (void)show{
//    
//    if (count++ >= 2) {
//        [timer1 invalidate];
//        count = 0;
//        
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
//        if (![str isEqualToString:self.textFieldKey.text]) {
            [selectArray removeAllObjects];
            for (int i = 0; i < [self.arrayCutomer count]; i++) {
                GroupOrderModel *entity = [self.arrayCutomer objectAtIndex:i];
                
                if ([entity.OfferName rangeOfString:self.textFieldKey.text].location != NSNotFound) {
                    [selectArray addObject:entity];
                }
            }
            if ([selectArray count] == 0) {
                
                ALERT_ERR_MSG(@"没有你想要的！");
                return;
            }
            self.arrayCustomerTemp = selectArray;
            [self.tableViewList reloadData];
//        }else{
//            
//        }
        str = self.textFieldKey.text;
    }else{
        
        [self.arrayCustomerTemp removeAllObjects];
        [self loadData];
    }
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [refreshHeader beginRefreshing];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self.arrayCustomerTemp removeAllObjects];
    [self doTask];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
