//
//  P_TerminalStockLViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalStockLViewController.h"
#import "StringHelper.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "P_TerminalStockSubmitViewController.h"

@interface P_TerminalStockLViewController ()
{
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
}
@property(nonatomic, assign) int currentPage;
@property(nonatomic, copy) NSString *company_name;
@end

@implementation P_TerminalStockLViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"请选择已完成的订货工单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    _tableView.tableHeaderView = _searchBar;
    [self select_logmodel:NSStringFromClass([self class])];
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    listMuArr = [[NSMutableArray alloc] init];
    
    [self addRefreshView];
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - ButtonMethod

//返回
- (void)backBtnClicked:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(terminalStockLViewControllerDidCancel:)]) {
//        [self.navigationController popViewControllerAnimated:NO];
//        
//        [self.delegate terminalStockLViewControllerDidCancel:self];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.currentPage = 0;
        [weakSelf getBusinessListWithPage:weakSelf.currentPage];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf getBusinessListWithPage:++weakSelf.currentPage];
    };
}

#pragma mark -

- (void)getBusinessListWithPage:(int)page
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"getbusiness_list",
                           @"unfinish":@"3",
                           @"page":@(page),
                           @"type_id":@"3",
                           @"user_type":userInfo.type_id,
                           @"dep_id":userInfo.dep_id,
                           @"company_name":self.company_name?self.company_name:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict Successed:^(id entity) {
        id content = entity[@"content"];
        NSArray *arr = [BusinessListModel objectArrayWithKeyValuesArray:content];
        
        if (page == 0) {
            [listMuArr removeAllObjects];
            [listMuArr addObjectsFromArray:arr];
            
            [_tableView reloadData];
        }else{
            [listMuArr addObjectsFromArray:arr];
            
            NSInteger rows = [_tableView numberOfRowsInSection:0];
            NSInteger insertRows = [arr count];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (NSInteger i = rows; i < rows+insertRows; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            //插入数据
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        }
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listMuArr count];
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
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    NSString *title = model.title;
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = model.create_time;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
//    if ([self.delegate respondsToSelector:@selector(terminalStockLViewController:didSelectModel:)]) {
//        [self.delegate terminalStockLViewController:self didSelectModel:model];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    P_TerminalStockSubmitViewController *vc = [[P_TerminalStockSubmitViewController alloc] initWithNibName:@"P_TerminalSubmitViewController" bundle:nil];
    vc.bListModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.company_name = searchBar.text;
    if (self.company_name.length == 0) {
        self.currentPage = 0;
        
        [self getBusinessListWithPage:self.currentPage];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.company_name = searchBar.text;
    self.currentPage = 0;
    
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark -

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

@end
