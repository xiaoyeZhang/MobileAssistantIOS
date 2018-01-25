//
//  Manangement_detailListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/1/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Manangement_detailListViewController.h"
#import "ThreeLabelsTableViewCell.h"

@interface Manangement_detailListViewController ()

@end

@implementation Manangement_detailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商机查看";
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _business_info.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ThreeLabelsTableViewCell";

    ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
 
    NSDictionary *deviceDic = _business_info[indexPath.row];

    cell.leftLbl.text = deviceDic[@"opportunity_type"];
    cell.middleLbl.text = deviceDic[@"opportunity_content"];
    cell.rightLbl.text = deviceDic[@"opportunity_strength"];
   
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
