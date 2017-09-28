//
//  P_UserListViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/7.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_UserListViewController.h"
#import "CommonService.h"
#import "MJExtension.h"

@interface P_UserListViewController ()
{
    NSMutableArray *listMuArr;
    NSMutableArray *searchMuArr;
    
    BOOL isSearch;
}

@end

@implementation P_UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"二级经理列表";
    if ([self.model_id isEqualToString:@"9"]) {
        self.title = @"活动受理人员列表";
    }
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    listMuArr = [[NSMutableArray alloc] init];
    searchMuArr = [[NSMutableArray alloc] init];
    
    [self getUserList];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)getUserList
{
    UserEntity *userinfo = [UserEntity sharedInstance];
    
    if (userinfo.area_id.intValue == 8) {
        self.model_id = @"-1";
    }else{
        
    }
    
    NSDictionary *dict = @{@"method":@"getprocessorlist"/*@"getuserlist"*/,
                           @"dep_id":self.dep_id?self.dep_id:@"",
                           @"type_id":self.type_id?self.type_id:@"",
                           @"model_id":self.model_id?self.model_id:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            id content = entity[@"content"];
            NSArray *arr = [UserListModel objectArrayWithKeyValuesArray:content];
            
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
    
    UserListModel *model = nil;
    if (!isSearch) {
        model = listMuArr[indexPath.row];
    }else{
        model = searchMuArr[indexPath.row];
    }
    
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.tel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserListModel *model = nil;
    if (!isSearch) {
        model = listMuArr[indexPath.row];
    }else{
        model = searchMuArr[indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(userListViewController:didSelectUser:)]) {
        [self.delegate userListViewController:self didSelectUser:model];
        
        [self backBtnClicked:nil];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearch = NO;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
        
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchBar.text];
        
        NSArray *arr = [listMuArr filteredArrayUsingPredicate:predicate];
        
        [searchMuArr removeAllObjects];
        [searchMuArr addObjectsFromArray:arr];
        
        isSearch = YES;
    }
    
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
