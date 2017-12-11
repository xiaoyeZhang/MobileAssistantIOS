//
//  P_NextUserListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "P_NextUserListViewController.h"
#import "MJExtension.h"

@interface P_NextUserListViewController ()
{
    NSMutableArray *listMuArr;
}
@end

@implementation P_NextUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下级执行人列表";

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    listMuArr = [[NSMutableArray alloc] init];
    
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

    NSDictionary *dict = @{@"method":@"getnextprocessorlist"/*@"getuserlist"*/,
                           @"dep_id":userinfo.dep_id,
                           @"user_id":userinfo.user_id,
                           @"business_id":self.business_id?self.business_id:@""};
    
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
    }
    
    UserListModel *model = nil;
    
    model = listMuArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.tel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserListModel *model = nil;
    
    model = listMuArr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(NextuserListViewController:didSelectUser:)]) {
        [self.delegate NextuserListViewController:self didSelectUser:model];
        
        [self backBtnClicked:nil];
    }
}

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
