//
//  NewsViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "NewsViewController.h"
#import "MJRefresh.h"
#import "NewsDetailViewController.h"
#import "NewsEntity.h"
#import "NewsTableViewCell.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "UserEntity.h"
#import "NewsContentViewController.h"
#import "news_NewsTableViewCell.h"

@interface NewsViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *LineLabel;
    NSString *type_id;
}


@end

@implementation NewsViewController
@synthesize tableViewNews;
@synthesize mutableArryNews, page;
@synthesize mainVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    type_id = @"0";
    
    mutableArryNews = [[NSMutableArray alloc] init];
    //[self addHeader];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self loadData];
    
    tableViewNews.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //[self addFooter];
    
//    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.system_news_Btn.frame.size.height, self.view.frame.size.width, 1)];
//    lineLabel.backgroundColor = RGBA(242, 242, 242, 1);
//    
//    [self.view addSubview:lineLabel];
//    
    LineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/2, 1)];
    
    LineLabel.backgroundColor = RGBA(66, 187, 222, 1);
    
    [self.view addSubview:LineLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"NewsViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"NewsViewController"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) loadData
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"newsList", @"method",
                           userEntity.dep_id, @"dep_id",
                           type_id, @"type_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"加载公告失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [mutableArryNews removeAllObjects];
        }
        else
        {
            NSMutableArray *array = [entity objectForKey:@"content"];
            [mutableArryNews removeAllObjects];
            for (NSDictionary* attributes in array) {
                NewsEntity *entity = [[NewsEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArryNews addObject:entity];
            }
            
        }
        [self.tableViewNews reloadData];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)loadDataTask:(int) pageNo RefreshView:(MJRefreshBaseView *)refreshView{
    // Do something usefull in here instead of sleeping ...
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"newsList", @"method",
                           userEntity.dep_id, @"dep_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"加载公告失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else {
            NSMutableArray *array = [entity objectForKey:@"content"];
            [mutableArryNews removeAllObjects];
            for (NSDictionary* attributes in array) {
                NewsEntity *entity = [[NewsEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArryNews addObject:entity];
            }
            [self doneWithView:refreshView];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}
- (IBAction)change_State_Btn:(UIButton *)sender {
    
    if (sender.tag == 0) {
        type_id = @"0";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.system_news_Btn setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.company_news_Btn setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            LineLabel.frame = CGRectMake(0, self.system_news_Btn.frame.size.height, SCREEN_WIDTH/2, 1);
            
        }];
        
    }else if (sender.tag == 1){
        type_id = @"1";
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.company_news_Btn setTitleColor:RGBA(66, 187, 233, 1) forState:UIControlStateNormal];
            [self.system_news_Btn setTitleColor:RGBA(128, 128,128, 1) forState:UIControlStateNormal];
            LineLabel.frame = CGRectMake(SCREEN_WIDTH/2, self.system_news_Btn.frame.size.height, SCREEN_WIDTH/2, 1);
            
        }];
    }else{
        
    }
    
    [self loadData];
    
}

- (void)addFooter
{
    //__unsafe_unretained OAAnnoViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableViewNews;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        ++page;
        [self loadDataTask:page RefreshView:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    //__unsafe_unretained OAAnnoViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableViewNews;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [mutableArryNews removeAllObjects];
        [self loadDataTask:1 RefreshView:refreshView];
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return [mutableArryNews count];

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *couponTableViewCellIdentifier=@"NewsTableViewCell";
//    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
//    if (cell == nil) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
//        cell = [array objectAtIndex:0];
//    }
////    cell.bgView.layer.borderWidth = 1;
////    cell.bgView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
//    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    NewsEntity *entity = [mutableArryNews objectAtIndex:indexPath.row];
//    
//    cell.labelTitle.text = entity.title;
//
//    cell.labelDate.text = entity.time;
    
    
    
    static NSString *couponTableViewCellIdentifier=@"news_NewsTableViewCell";
    news_NewsTableViewCell *cell = (news_NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"news_NewsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
        cell.bgView.layer.cornerRadius = 5;
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
    }

    NewsEntity *entity = [mutableArryNews objectAtIndex:indexPath.row];
    
    if ([entity.type isEqualToString:@"0"]) {
        cell.Icon_State.image = [UIImage imageNamed:@"系统"];
        
    }else if ([entity.type isEqualToString:@"1"]) {
        
         cell.Icon_State.image = [UIImage imageNamed:@"通知"];
    }else{
        
    }
    
    cell.titleLabel.text = entity.title;
    
    cell.TimeLabel.text = entity.time;
    
    cell.countLabel.text = entity.count;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsEntity *entity = [mutableArryNews objectAtIndex:indexPath.row];
    
//    NewsDetailViewController *vc = [[NewsDetailViewController alloc]init];
//    vc.newsEntity = entity;
    
    [mainVC.navigationController setNavigationBarHidden:NO animated:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsContentViewController *vc = [[NewsContentViewController alloc] init];
    vc.newsId = entity.notice_id;
    
    [mainVC.navigationController pushViewController:vc animated:YES];
    
    [self loadData];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableViewNews reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void) reloadNewsData
{
    [HUD hide:YES];
    [self select_logmodel:NSStringFromClass([self class])];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [mutableArryNews removeAllObjects];
    HUD.labelText = @"努力加载中...";
    [self loadData];
}

@end
