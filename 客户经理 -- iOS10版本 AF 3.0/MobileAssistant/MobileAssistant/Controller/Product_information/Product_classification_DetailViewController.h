//
//  Product_classification_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Product_classificationEntity.h"

@interface Product_classification_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (copy, nonatomic) NSString *name;

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIScrollView *titleScrollView;

@property (nonatomic,strong) UILabel *lineLabel;

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;

@property (strong, nonatomic)UIView *View3;
@property (strong, nonatomic)UIWebView *webView1;
@property (strong, nonatomic)UIWebView *webView2;

@property (strong, nonatomic) Product_classificationEntity *entity;
@end
