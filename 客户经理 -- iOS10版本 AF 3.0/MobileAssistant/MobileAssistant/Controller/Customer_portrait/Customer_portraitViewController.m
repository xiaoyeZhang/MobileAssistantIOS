//
//  Customer_portraitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/9/6.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Customer_portraitViewController.h"
#import "UserEntity.h"

@interface Customer_portraitViewController ()

@end

@implementation Customer_portraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户画像信息";
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *UrlStr = [NSString stringWithFormat:@"http://sw.avatek.com.cn/gzcms/group.php?user_id=%@",userEntity.user_id];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:UrlStr]];
    
    [self.webView loadRequest:request];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
