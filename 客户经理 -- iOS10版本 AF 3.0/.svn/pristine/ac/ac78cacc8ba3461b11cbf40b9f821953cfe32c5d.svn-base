//
//  Business_AttrInstInfoViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_AttrInstInfoViewController.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "Business_ProductDetailViewController.h"

@interface Business_AttrInstInfoViewController ()

@end

@implementation Business_AttrInstInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
//    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    self.title = @"产品属性列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.AttrInstInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *CellIdentifier1 = @"Bussiness_CustomerTableViewCell";
    Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *AttrName;
    NSString *EffectiveDate;
    NSString *ExpireDate;
    
    if (![[self.AttrInstInfo[indexPath.row] objectForKey:@"AttrName"] isKindOfClass:[NSNull class]]){
        AttrName= [self.AttrInstInfo[indexPath.row] objectForKey:@"AttrName"];
    }else{
        AttrName = @"";
    }
    
    if (![[self.AttrInstInfo[indexPath.row] objectForKey:@"EffectiveDate"] isKindOfClass:[NSNull class]]){
        EffectiveDate= [self.AttrInstInfo[indexPath.row] objectForKey:@"EffectiveDate"];
        if (self.num == 1) {
            if (EffectiveDate.length != 0) {
                EffectiveDate=[NSString stringWithFormat:@"%@-%@-%@",
                               [EffectiveDate substringWithRange:NSMakeRange(0, 4)],
                               [EffectiveDate substringWithRange:NSMakeRange(4, 2)],
                               [EffectiveDate substringWithRange:NSMakeRange(6, 2)]];
            }

        }
    }else{
        EffectiveDate = @"";
    }
    
    if (![[self.AttrInstInfo[indexPath.row] objectForKey:@"ExpireDate"] isKindOfClass:[NSNull class]]){
        
        ExpireDate= [self.AttrInstInfo[indexPath.row] objectForKey:@"ExpireDate"];
        if (self.num == 1) {
            if (ExpireDate.length != 0) {
                ExpireDate=[NSString stringWithFormat:@"%@-%@-%@",
                               [ExpireDate substringWithRange:NSMakeRange(0, 4)],
                               [ExpireDate substringWithRange:NSMakeRange(4, 2)],
                               [ExpireDate substringWithRange:NSMakeRange(6, 2)]];
            }

        }
        
    }else{
        ExpireDate = @"";
    }
    
    cell.CustomerName.text = AttrName;
    cell.CustomerNum.text = [NSString stringWithFormat:@"生效时间：%@",EffectiveDate];
    cell.CustomerAddress.text = [NSString stringWithFormat:@"失效时间：%@",ExpireDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_ProductDetailViewController *vc = [[Business_ProductDetailViewController alloc]init];
    
    vc.AttrInstInfoDic = self.AttrInstInfo[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
