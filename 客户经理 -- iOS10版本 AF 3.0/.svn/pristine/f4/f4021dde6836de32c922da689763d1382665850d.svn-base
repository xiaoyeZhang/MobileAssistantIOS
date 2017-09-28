//
//  NewsDetailViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-22.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize newsEntity;
@synthesize labelTitle, labelTime, textViewContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (newsEntity != nil) {
        labelTime.text = newsEntity.time;
        labelTitle.text = newsEntity.title;
        textViewContent.text = newsEntity.content;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"公告详情";
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"NewsDetailViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"NewsDetailViewController"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
