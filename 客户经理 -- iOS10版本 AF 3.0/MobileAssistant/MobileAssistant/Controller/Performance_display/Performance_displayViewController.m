//
//  Performance_displayViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/10/30.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Performance_displayViewController.h"
#import "MBProgressHUD.h"

@interface Performance_displayViewController ()<MBProgressHUDDelegate,UIWebViewDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation Performance_displayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"2017全省班组成绩展示";

    UIButton *backBtn = [self setNaviCommonBackBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    NSString *url = [NSString stringWithFormat:@"%@?user_num=%@",PER_DIS,_user_num];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.delegate = self;
    
    [_webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [HUD hide:YES];
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    [HUD hide:YES];
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
