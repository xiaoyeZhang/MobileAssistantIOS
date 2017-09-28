//
//  Business_InternationalViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomViewController.h"
#import "UserView.h"
#import "CertificatesView.h"
#import "ComprehensiveView.h"

@interface Business_InternationalViewController : XYBaseViewController

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIScrollView *titleScrollView;

@property (nonatomic,strong) UILabel *lineLabel;

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;

@property (nonatomic,strong) RandomViewController *view1;
@property (nonatomic,strong) UserView *view2;
@property (nonatomic,strong) CertificatesView *view3;
@property (nonatomic,strong) ComprehensiveView *view4;

@property (nonatomic,assign) CGFloat x ;

@property (strong, nonatomic) NSString *ServiceNum;
@property (strong, nonatomic) NSString *Password;
@property (strong, nonatomic) NSString *message;

@property (assign, nonatomic) NSInteger num;
@end
