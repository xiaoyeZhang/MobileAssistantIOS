//
//  SGLNavigationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/9/21.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "SGLNavigationViewController.h"
#import "TrackViewController.h"

@interface SGLNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SGLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
    
}

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
//    if ([self.childViewControllers isKindOfClass:[TaskListViewController class]]) {
//        return NO;
//    }
    TrackViewController *vc = [[TrackViewController alloc]init];
    for (UIViewController *temp in self.childViewControllers) {
        if ([temp isKindOfClass:[vc class]]) {
            return NO;
        }
    }
    

    return (self.childViewControllers.count == 1 || self.childViewControllers.count == 2)? NO : YES;
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
