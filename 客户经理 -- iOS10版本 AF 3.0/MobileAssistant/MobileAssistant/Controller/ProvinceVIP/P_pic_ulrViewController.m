
//
//  P_pic_ulrViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/13.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "P_pic_ulrViewController.h"

@interface P_pic_ulrViewController ()

@end

@implementation P_pic_ulrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片查看";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"保存"];
    [submitBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_pic_url]];
    
    [_Pic_ulrWebView loadRequest:request];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnClicked:(id)sender{
    
    UIImageView *gtp = [[UIImageView alloc] init];
    [gtp setImageWithURL:[NSURL URLWithString:_pic_url]];
    UIImageWriteToSavedPhotosAlbum(gtp.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
