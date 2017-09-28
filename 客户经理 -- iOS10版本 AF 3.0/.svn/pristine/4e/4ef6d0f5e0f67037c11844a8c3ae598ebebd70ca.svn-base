//
//  Marking_detailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Marking_detailViewController.h"
#import "Marking_detail_ListViewController.h"

@interface Marking_detailViewController ()

@end

@implementation Marking_detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销活动方案";
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    [rightBtn setTitle:@"营销活动ID" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self action:@selector(sumBitCickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.field isEqualToString:@"content"]) {
       
        [self setNaviBarRightView:rightBtn];
    
    }else{
        
    }
    
    
//    method = common_page
//    page= marketing
//    id = 唯一的ID
//    field = content或者faq（对应内容和FAQ）

    
    NSString *url = [NSString stringWithFormat:@"%@?method=%@&page=%@&id=%@&field=%@",BASEURL,@"common_page",@"marketing",self.entity.marketing_id,self.field];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sumBitCickBtn:(UIButton *)sender{
    
    Marking_detail_ListViewController *vc = [[Marking_detail_ListViewController alloc]init];
    
    vc.marketing_id = self.entity.marketing_id;
    vc.name = self.entity.name;
    vc.num = self.entity.num;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
