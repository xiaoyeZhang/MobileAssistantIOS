//
//  Marking_CenterDetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/14.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Marking_CenterDetailViewController.h"

@interface Marking_CenterDetailViewController ()

@end

@implementation Marking_CenterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.Title;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
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
