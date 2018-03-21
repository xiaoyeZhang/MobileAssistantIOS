//
//  WebViewViewController.m
//  Plus
//
//  Created by 房 国生 on 14-12-12.
//  Copyright (c) 2014年 thinkland. All rights reserved.
//

#import "WebViewViewController.h"
#import "MBProgressHUD.h"

@interface WebViewViewController ()<MBProgressHUDDelegate, UIWebViewDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController
@synthesize strTitle;
@synthesize url;
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = strTitle;
    
    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"数据加载中...";
    [HUD show:YES];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"WebViewViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"WebViewViewController"];
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

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [HUD hide:YES];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    [HUD hide:YES];
}

@end
