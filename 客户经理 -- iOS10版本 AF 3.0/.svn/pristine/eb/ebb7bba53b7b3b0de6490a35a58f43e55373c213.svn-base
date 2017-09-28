//
//  NewsContentViewController.m
//  MobileAssistant
//
//  Created by xy on 15/10/14.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController ()

@end

@implementation NewsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"公告详情";
    
    super.model = NSStringFromClass([self class]);
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    NSString *url = [NSString stringWithFormat:@"%@?id=%@",NEWS_URL,self.newsId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
}

#pragma mark - ButtonMethod
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
