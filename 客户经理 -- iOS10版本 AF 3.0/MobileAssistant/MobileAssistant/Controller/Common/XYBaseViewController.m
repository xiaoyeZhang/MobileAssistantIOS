//
//  BaseViewController.m
//  SnailNetHallO2O
//
//  Created by xy on 15/7/9.
//  Copyright (c) 2015年 snailgames. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYBaseViewController ()

@end

@implementation XYBaseViewController

- (void)dealloc
{

}

- (void)viewDidLoad {
    [super viewDidLoad];

    
   
}

- (UIButton *)setNaviCommonBackBtn
{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    leftBtn.backgroundColor = [UIColor lightGrayColor];
//    leftBtn.frame = CGRectMake(0, 0, 57, 44);
//    [leftBtn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
////    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
////    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self setNaviBarLeftView:leftBtn];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 70, 44);
    
    [leftBtn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *leftBarButon = [[ UIBarButtonItem alloc ] initWithCustomView :leftBtn];
    
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        negativeSpacer.width = - 20;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftBarButon];
    } else{
        
        self.navigationItem.leftBarButtonItem = leftBarButon;
    }
    
    [self set_logmodel];

    return leftBtn;
}

- (UIButton *)setNaviRightBtnWithTitle:(NSString *)title
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.backgroundColor = [UIColor lightGrayColor];
    rightBtn.frame = CGRectMake(0, 0, 50, 44);
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self setNaviBarRightView:rightBtn];
    
    return rightBtn;
}

- (void)setNaviBackBtn:(UIButton *__strong*)backBtn andCloseBtn:(UIButton *__strong*)closeBtn
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.backgroundColor = [UIColor lightGrayColor];
    backButton.frame = CGRectMake(0, 0, 50, 44);
    [backButton setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
//    [backButton setTitleColor:RGBCOLOR(153, 255, 255, 1) forState:UIControlStateHighlighted];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.backgroundColor = [UIColor grayColor];
    closeButton.frame = CGRectMake(0, 0, 32, 44);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBCOLOR(153, 255, 255, 1) forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    *backBtn = backButton;
    
    *closeBtn = closeButton;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
}

- (void)setNaviBarLeftView:(UIView *)view;
{
    if (view) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
        
        if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
            
        {
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            
            negativeSpacer.width = - 20;//这个数值可以根据情况自由变化
            
            self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
        } else{
            
            self.navigationItem.leftBarButtonItem = item;
        }

        
    }
}

- (void)setNaviBarRightView:(UIView *)view
{
    if (view) {
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
//        self.navigationItem.rightBarButtonItem = item;
        
        UIBarButtonItem *leftBarButon = [[ UIBarButtonItem alloc ] initWithCustomView :view];
        
        // 调整 leftBarButtonItem 在 iOS7 下面的位置
        
        if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
            
        {
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            
            negativeSpacer.width = - 15;//这个数值可以根据情况自由变化
            
            self.navigationItem.rightBarButtonItems = @[negativeSpacer,leftBarButon];
        } else{
            
            self.navigationItem.rightBarButtonItem = leftBarButon;
        }
        
    }
}

-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    
    detailTextView.text = value;
    
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    
    return deSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
