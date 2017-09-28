//
//  Rule_descriptionViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/29.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Rule_descriptionViewController.h"
#import "MBProgressHUD.h"

@interface Rule_descriptionViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation Rule_descriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"规则说明";
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSString *url = [NSString stringWithFormat:@"%@",@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
