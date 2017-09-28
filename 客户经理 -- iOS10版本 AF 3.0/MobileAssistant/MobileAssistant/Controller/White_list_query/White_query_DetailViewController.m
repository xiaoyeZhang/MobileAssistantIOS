//
//  White_query_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "White_query_DetailViewController.h"
#import "LineTwoLabelTableViewCell.h"

@interface White_query_DetailViewController ()
{
    LineTwoLabelTableViewCell *cell;
    
}
@property(strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation White_query_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"可办理的营销活动查询";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataArr = [[NSMutableArray alloc] initWithObjects:
//                    @{@"title":@"工单编号：" ,@"message":@""},
                    @{@"title":@"大活动名称：",@"message":[self.DicCustomerTemp objectForKey:@"BigActivityName"]},
                    @{@"title":@"大活动编号：",@"message":[self.DicCustomerTemp objectForKey:@"BigActivityId"]},
                    @{@"title":@"子活动名称：",@"message":[self.DicCustomerTemp objectForKey:@"SubActivityName"]},
                    @{@"title":@"子活动编号：",@"message":[self.DicCustomerTemp objectForKey:@"SubActivityId"]},nil];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 50;
    }
    return size.height + 33;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier2 = @"LineTwoLabelTableViewCell";
    

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titLabel.text = self.dataArr[indexPath.row][@"title"];
    cell.subTitleLbl.text = self.dataArr[indexPath.row][@"message"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
