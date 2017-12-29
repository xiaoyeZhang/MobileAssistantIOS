//
//  BaseViewController.h
//  SnailNetHallO2O
//
//  Created by xy on 15/7/9.
//  Copyright (c) 2015年 snailgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYBaseViewController : ZXYBaseViewController

- (UIButton *)setNaviCommonBackBtn;
- (UIButton *)setNaviRightBtnWithTitle:(NSString *)title;

- (void)setNaviBackBtn:(UIButton *__strong*)backBtn andCloseBtn:(UIButton *__strong*)closeBtn;
- (void)setNaviBarLeftView:(UIView *)view;
- (void)setNaviBarRightView:(UIView *)view;

-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;


@end
