//
//  Business_ProdInstInfoViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_ProdInstInfoViewController.h"
#import "Business_ProdInstInfoTableViewCell.h"

@interface Business_ProdInstInfoViewController ()

@end

@implementation Business_ProdInstInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    self.title = @"产品信息列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.ProdInstInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"Business_ProdInstInfoTableViewCell";
    Business_ProdInstInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    NSString *State;
    NSString *ProdType;
    NSString *OperType;
    NSString *ProdId;
    if (![[self.ProdInstInfo[indexPath.row] objectForKey:@"ProdId"] isKindOfClass:[NSNull class]]) {
        ProdId = [self.ProdInstInfo[indexPath.row] objectForKey:@"ProdId"];
        
    }else{
        ProdId = @"";
    }

    
    if (![[self.ProdInstInfo[indexPath.row] objectForKey:@"State"] isKindOfClass:[NSNull class]] &&[self.ProdInstInfo[indexPath.row] objectForKey:@"State"] != nil){
        if ([[self.ProdInstInfo[indexPath.row] objectForKey:@"State"] isEqualToString:@"1"]) {
            State = @"正常";
        }else{
            State = [self.ProdInstInfo[indexPath.row] objectForKey:@"State"];
        }
    }else{
        State = @"";
    }
    if (![[self.ProdInstInfo[indexPath.row] objectForKey:@"ProdType"] isKindOfClass:[NSNull class]]&&[self.ProdInstInfo[indexPath.row] objectForKey:@"ProdType"] != nil){
        ProdType= [self.ProdInstInfo[indexPath.row] objectForKey:@"ProdType"];
    }else{
        ProdType = @"";
    }
    
    if (![[self.ProdInstInfo[indexPath.row] objectForKey:@"OperType"] isKindOfClass:[NSNull class]]&&[self.ProdInstInfo[indexPath.row] objectForKey:@"OperType"] != nil) {
       OperType = [self.ProdInstInfo[indexPath.row] objectForKey:@"OperType"];

    }else{
         OperType = @"";
    }
    
    cell.titleLable.text = [self.ProdInstInfo[indexPath.row] objectForKey:@"ProdName"];
    cell.ProdNumLable.text = [NSString stringWithFormat:@"产品编号：%@",ProdId];
    cell.SypeLable.text = [NSString stringWithFormat:@"状态：%@",State];
    cell.KindLable.text = [NSString stringWithFormat:@"操作类型：%@",ProdType];
    cell.DoSypeLable.text = [NSString stringWithFormat:@"产品类型：%@",OperType];
    return cell;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
