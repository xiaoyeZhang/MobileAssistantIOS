//
//  News_Select_Next_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/6.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "News_Select_Next_listViewController.h"
#import "News_CustomerTableViewCell.h"

@interface News_Select_Next_listViewController ()

@end

@implementation News_Select_Next_listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下级处理人";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayCutomer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"News_CustomerTableViewCell";
    News_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:couponTableViewCellIdentifier owner:nil options:nil] firstObject];
        
    }
    
    News_PtovinceVip_Next_CustomerEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row]
    ;
    
    cell.titleLabel.text = entity.name;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        
    News_PtovinceVip_Next_CustomerEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(News_Select_Next_listViewControllerViewController:didSelectCompany:)]) {
        
        [self.delegate News_Select_Next_listViewControllerViewController:self didSelectCompany:entity];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
