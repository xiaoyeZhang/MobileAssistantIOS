//
//  Focus_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Focus_ListViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Focus_ListEntity.h"
#import "New_ContactsTableViewCell.h"
#import "XYStartEndDatePicker.h"
#import "Utilies.h"
#import "DataSql.h"
#import "Contract_expries_DetailViewController.h"
#import "Birthday_DetailViewController.h"
#import "Arrears_DetailViewController.h"

@interface Focus_ListViewController ()<MBProgressHUDDelegate,NIDropDownDelegate,XYStartEndDatePickerDelegate>
{
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    NSString *type_id;
    DataSql *Sql;
    NSNumber *stateNum;
}
@property (strong, nonatomic) NSMutableArray *cateArr;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@end

@implementation Focus_ListViewController

@synthesize dropDown;

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"集中化管理";
    
    userEntity = [UserEntity sharedInstance];
    
    _arrayCustomerTemp = [NSMutableArray array];
    
    Sql = [[DataSql alloc]init];
    
    self.cateArr = [[NSMutableArray alloc]init];
    
    [self.cateArr addObject:@"全部"];
    [self.cateArr addObject:@"合同到期提醒"];
    [self.cateArr addObject:@"生日提醒"];
    [self.cateArr addObject:@"欠费任务提醒"];
    
    [self.typeBtn setTitle:_cateArr[0] forState:UIControlStateNormal];
    
    [self.typeBtn addTarget:self action:@selector(cateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.start_time = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.end_time = [dateFormatter stringFromDate:[NSDate date]];;
    
    [_dateBtn setTitle:[NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time]
              forState:UIControlStateNormal];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    type_id = @"";
    [self getData:0];
    
    [self addRefreshView];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf getData:0];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getData:weakSelf.arrayCustomerTemp.count];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *couponTableViewCellIdentifier=@"New_ContactsTableViewCell";
    New_ContactsTableViewCell *cell = (New_ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"New_ContactsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.Btn.alpha = 0;
        cell.tel.alpha = 0;
    }
    Focus_ListEntity *entity = [_arrayCustomerTemp objectAtIndex:indexPath.row];

    NSString *typeStr = @"";
    switch ([entity.type_id intValue]) {
        case 0:
            typeStr = @"合同到期提醒";
            break;
        case 1:
            typeStr = @"生日提醒";
            break;
        case 2:
            typeStr = @"欠费任务提醒";
            break;
        default:
            break;
    }
    
    if (entity.company_name.length > 12) {
        cell.level.text =    [NSString stringWithFormat:@"%@(%@)",[entity.company_name substringToIndex:12],typeStr];
    }else{
        cell.level.text =    [NSString stringWithFormat:@"%@(%@)",entity.company_name,typeStr];
    }

    cell.name.text =     [NSString stringWithFormat:@"姓       名： %@",entity.user_name];
    cell.position.text = [NSString stringWithFormat:@"推送时间： %@",entity.create_time];
    
    NSString *is_readStr = [Sql selectFocus:entity.focus_id];
    
    if ([is_readStr intValue] == 0) {
        cell.level.textColor = [UIColor blackColor];
        cell.name.textColor = [UIColor blackColor];
        cell.position.textColor = [UIColor blackColor];
    }else if ([is_readStr intValue] == 1){
        cell.level.textColor = RGBA(120, 120, 120, 1);
        cell.name.textColor = RGBA(120, 120, 120, 1);
        cell.position.textColor = RGBA(120, 120, 120, 1);
    }else{
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Focus_ListEntity *entity = [_arrayCustomerTemp objectAtIndex:indexPath.row];

    [Sql changeFocus:entity.focus_id];
    
    if ([entity.type_id intValue] == 0) {
        
        Contract_expries_DetailViewController *vc = [[Contract_expries_DetailViewController alloc]init];
        
        vc.contract_id = entity.target_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([entity.type_id intValue] == 1){
        
        Birthday_DetailViewController *vc = [[Birthday_DetailViewController alloc]init];
        
        vc.birthday_id = entity.target_id;
        [vc getData];
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if ([entity.type_id intValue] == 2){
        
        Arrears_DetailViewController *vc = [[Arrears_DetailViewController alloc]init];
        
        vc.arrearage_id = entity.target_id;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
    }
    
    [self.tableView reloadData];
    
    [self setIconBadgeNumber];
}


- (IBAction)cateBtnClicked:(UIButton *)sender {

    
    [self cateBtnClicked:self.typeBtn andWith:_cateArr];
    
}

- (void)cateBtnClicked:(UIButton * )sender andWith:(NSArray *)arr
{
    CGFloat height = 40*self.cateArr.count;
    
    if (!dropDown) {
        dropDown = [[NIDropDown alloc] showDropDown:sender height:&height titleArr:arr imgArr:nil direction:@"down"];
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void)niDropDownDelegateMethod:(NIDropDown *)sender didSelectIndex:(int)index
{
    
    [self.typeBtn setTitle:self.cateArr[index] forState:UIControlStateNormal];
    
    switch (index) {
        case 0:
            
            type_id = @"";
            break;

        default:
            
            type_id = [NSString stringWithFormat:@"%d",index - 1];
            
            break;
    }

    
    [dropDown hideDropDown:self.typeBtn];

    dropDown = nil;

    [self getData:0];
}

- (IBAction)dateBtnClicked:(UIButton *)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.start_time];
    NSDate *endDate = [dateFormatter dateFromString:self.end_time];
    
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
    
    self.start_time = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.end_time = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.start_time,self.end_time];
    [_dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    [self getData:0];
}

- (void)getData:(NSUInteger)location{
  /*
    user_id
    local
    type_id = 0,1,2表示筛选类型
    start_time   end_time 格式YYYY-MM-DD
  */
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"focus_list",
                           @"user_id":userEntity.user_id,
                           @"local":@(location),
                           @"type_id":type_id,
                           @"start_time":self.start_time?self.start_time:@"",
                           @"end_time":self.end_time?self.end_time:@"",
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if (location == 0) {
            [self.arrayCustomerTemp removeAllObjects];
        }
        
        stateNum = state;
        
        [self setIconBadgeNumber];
        
        
        if ([state intValue]> 0) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                
                Focus_ListEntity *entity = [[Focus_ListEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                
                [Sql addFocus:attributes];
                
                [self.arrayCustomerTemp addObject:entity];
            }
            
            
        }
        else
        {
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    }];

    
}

- (void)setIconBadgeNumber{
    
    int num = [Sql countFocus];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[stateNum intValue]- num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
