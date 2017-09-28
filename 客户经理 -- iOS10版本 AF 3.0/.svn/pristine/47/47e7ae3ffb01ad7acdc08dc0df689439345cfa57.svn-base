//
//  CoustomerMainNewsViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-5.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CoustomerMainNewsViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "MBProgressHUD.h"
#import "ContactEntity.h"
#import "NewsTableViewCell.h"
#import "CoustomerDetailViewController.h"
#import "ConditionViewController.h"
#import "MJRefresh.h"
#import "CoustomerAddViewController.h"

@interface CoustomerMainNewsViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, strong) MJRefreshBaseView *refreshView;
@end

@implementation CoustomerMainNewsViewController
@synthesize mutableArry, arrayCutomer, tableView, mainVC;
@synthesize searchBar;
@synthesize viewCondition;
@synthesize lable1, lable2, lable3, lable4;
@synthesize condition1, condition2, condition3, condition4;
@synthesize strSearchKey;
@synthesize background;
@synthesize refreshView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 57, 44);
    [backBtn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    mutableArry = [[NSMutableArray alloc] init];
    arrayCutomer = [[NSMutableArray alloc]init];
    
    [self.view addSubview:viewCondition];
    viewCondition.frame = CGRectMake(320, 0, 200, 300);
    
    [self initConditionValue];
    [self setConditionView];
    background.hidden = YES;
    self.doSearch.hidden = YES;
    [self loadData];
//    [self addFooter];
}

- (void)backBtnClicked:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setConditionView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"CoustomerMainNewsViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"CoustomerMainNewsViewController"];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search clicked");
    [searchBar resignFirstResponder];
    strSearchKey = searchBar.text;

//    [self getDataByCondition];
    [mutableArry removeAllObjects];
    if (strSearchKey == nil || strSearchKey.length == 0) {
        for (int i = 0; i < [arrayCutomer count]; i++) {
            CompEntity *entity = [arrayCutomer objectAtIndex:i];
            [mutableArry addObject:entity];
        }
        [tableView reloadData];
        return;
    }
    
    for (int i = 0; i < [arrayCutomer count]; i++) {
        CompEntity *entity = [arrayCutomer objectAtIndex:i];
        
        NSRange range = [entity.name rangeOfString:strSearchKey];//判断字符串是否包含
        
        if (range.length > 0)//包含
        {
            [mutableArry addObject:entity];
        } else//不包含
        {
        }
    }
    
    [tableView reloadData];

    
}


- (IBAction)allButtonClicked:(id)sender{
    NSLog(@"search clicked");
    [mutableArry removeAllObjects];
    [self getData];
}
//
//- (IBAction)doSearchByCondition:(id)sender
//{
//    background.hidden = NO;
//    [searchBar resignFirstResponder];
//    viewCondition.frame = CGRectMake(100, 0, 220, self.view.frame.size.height);
//}

- (IBAction)doHideSearchView:(id)sender
{
    background.hidden = YES;
    [searchBar resignFirstResponder];
    viewCondition.frame = CGRectMake(320, 0, 220, self.view.frame.size.height);
}

- (void) addCompObj:(CompEntity *)entity
{
    [mutableArry addObject:entity];
    [tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mutableArry count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier = @"NewsTableViewCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];

    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CompEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = entity.name;
    cell.labelDate.text = entity.update_time;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [searchBar resignFirstResponder];

}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompEntity * entity = [mutableArry objectAtIndex:indexPath.row];
    CoustomerDetailViewController *vc = [[CoustomerDetailViewController alloc]init];
    vc.compEntity = entity;
    vc.mainVC = mainVC;
    if ([self.type isEqualToString:@"1"]) {
        
        vc.message = self.message;
        vc.type = self.type;
        [self.navigationController pushViewController:vc animated:YES];
    
    }else{
        
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
   
}

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
    
//    NSString *from = [NSString stringWithFormat:@"%d", [mutableArry count]];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @"group", @"method",
//                           entity.user_id, @"user_id",
//                           from, @"from",
//                           nil];
//
    NSDictionary *param = @{@"method":@"company_list",
                            @"user_num":entity.num,
                            };;
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *array = [entity objectForKey:@"content"];
            [mutableArry removeAllObjects];
            [arrayCutomer removeAllObjects];
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArry addObject:entity];
                [arrayCutomer addObject:entity];
            }
            [self doneWithView:refreshView];
             [HUD hide:YES];
            //[self.tableView reloadData];
        }
        else
        {
            
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"加载客户失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [HUD hide:YES];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];

}

- (void) getDataByCondition
{
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    /*
     [titleDataArray count], @"level",
     [titleDataArray count], @"visit",
     [titleDataArray count], @"type",
     [titleDataArray count], @"scope",
     */
    NSString *strFrom = [NSString stringWithFormat:@"%d", [mutableArry count] ];
    
  
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"group", @"method",
                           entity.user_id, @"user_id",
                           strFrom, @"from",
                           searchBar.text, @"name",
                           condition1.ID, @"level",
                           condition2.ID, @"visit",
                           condition3.ID, @"type",
                           condition4.ID, @"scope",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
            [self.tableView reloadData];
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else
        {
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArry addObject:entity];
            }
            [self.tableView reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (IBAction)doComfirm:(id)sender
{
    background.hidden = YES;
    [mutableArry removeAllObjects];
    viewCondition.frame = CGRectMake(320, 0, 220, self.view.frame.size.height);
    
    HUD.labelText = @"努力加载中...";
    [self getDataByCondition];
    //[HUD showWhileExecuting:@selector(getDataByCondition) onTarget:self withObject:nil animated:YES];
}

- (IBAction)doReset:(id)sender
{
    [self initConditionValue];
    [self setConditionView];
}

- (IBAction)doSelectCustomerLevel:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 0;
    vc.enter_type = 0;
    vc.cmn = self;
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectTask:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 1;
    vc.enter_type = 0;
    vc.cmn = self;
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectCustomerType:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 2;
    vc.enter_type = 0;
    vc.cmn = self;
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectCustomerScope:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 3;
    vc.enter_type = 0;
    vc.cmn = self;
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction) doAddCoustomer:(id)sender
{
    CoustomerAddViewController *vc = [[CoustomerAddViewController alloc]init];
    vc.cmvc = self;
    [mainVC.navigationController pushViewController:vc animated:YES];
}

- (void) initConditionValue
{
    //初始化筛选条件
    condition1 = [[ConditionEntity alloc] init];
    condition1.ID = @"-1";
    condition1.name = @"全部";
    condition2 = [[ConditionEntity alloc] init];
    condition2.ID = @"-1";
    condition2.name = @"全部";
    condition3 = [[ConditionEntity alloc] init];
    condition3.ID = @"-1";
    condition3.name = @"全部";
    condition4 = [[ConditionEntity alloc] init];
    condition4.ID = @"-1";
    condition4.name = @"全部";
    //
}

- (void) setConditionView
{
    lable1.text = condition1.name;
    lable2.text = condition2.name;
    lable3.text = condition3.name;
    lable4.text = condition4.name;
}

- (void) loadData
{
    [self select_logmodel:NSStringFromClass([self class])];
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [mutableArry removeAllObjects];
    HUD.labelText = @"努力加载中...";
    [self getData];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)addFooter
{
    //__unsafe_unretained OAAnnoViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        //++page;
        //[self loadDataTask:page RefreshView:refreshView];
        [self getData];
        self.refreshView = refreshView;
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

@end


