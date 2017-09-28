//
//  P_ContractListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/5.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_ContractListViewController.h"
#import "CommonService.h"
#import "MJExtension.h"

@interface P_ContractListViewController ()
{
    NSMutableArray *listMuArr;
    NSMutableArray *searchMuArr;
    
    BOOL isSearch;
}

@end

@implementation P_ContractListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"合同列表";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    listMuArr = [[NSMutableArray alloc] init];
    searchMuArr = [[NSMutableArray alloc] init];
    
    [self getBillList];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)getBillList
{
    NSDictionary *dict = @{@"method":@"getbilllist"};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            id content = entity[@"content"];
            NSArray *arr = [BillListModel objectArrayWithKeyValuesArray:content];
            
            [listMuArr removeAllObjects];
            [listMuArr addObjectsFromArray:arr];
            
            [_tableView reloadData];
        }
    } Failed:^(int errorCode, NSString *message) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isSearch) {
        return [listMuArr count];
    }else{
        return [searchMuArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    BillListModel *model = nil;
    if (!isSearch) {
        model = listMuArr[indexPath.row];
    }else{
        model = searchMuArr[indexPath.row];
    }
    
    
    cell.textLabel.text = model.bill_contract;
    cell.detailTextLabel.text = model.bill_project;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BillListModel *model = nil;
    if (!isSearch) {
        model = listMuArr[indexPath.row];
    }else{
        model = searchMuArr[indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(contractListViewController:didSelectedModel:)]) {
        [self.delegate contractListViewController:self didSelectedModel:model];
        
        [self backBtnClicked:nil];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearch = NO;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bill_contract contains[c] %@",searchText];
        
        NSArray *arr = [listMuArr filteredArrayUsingPredicate:predicate];
        
        [searchMuArr removeAllObjects];
        [searchMuArr addObjectsFromArray:arr];
        
        isSearch = YES;
    }
    
    
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        isSearch = NO;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bill_contract contains[c] %@",searchBar.text];
        
        NSArray *arr = [listMuArr filteredArrayUsingPredicate:predicate];
        
        [searchMuArr removeAllObjects];
        [searchMuArr addObjectsFromArray:arr];
        
        isSearch = YES;
    }
    
    [_tableView reloadData];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
