//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "QRadioButton.h"

double kAlertWidth =  245.0f;
double kAlertHeight = 205.0f;

@interface DXAlertView ()<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _leftLeave;
    CalendarHomeViewController *chvc;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DXAlertView
@synthesize vsTaskVC;
@synthesize alertButton;

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      TextAlignment:(int)textAlignment
           FontSize:(float) fontsize
{
    if (self = [super init]) {
        kAlertHeight = 160;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 80)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = textAlignment;
        self.alertContentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
        self.alertContentLabel.font = [UIFont systemFontOfSize:fontsize];
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 32.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        kAlertHeight = 250.0f;
        
        kAlertWidth = [UIScreen mainScreen].bounds.size.width - 40;
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset - 8, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        
//        self.alertContentTextView = [[UITextView alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame) + 10, contentLabelWidth, 80)];

        //优化拜访任务功能
        
        UILabel *serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+18, 75 , kTitleHeight)];
        
        serviceLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        serviceLabel.text = @"推荐业务:";
        serviceLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:serviceLabel];
        
        self.serviceTextfield = [[UITextField alloc]initWithFrame:CGRectMake(serviceLabel.frame.size.width + 8, kTitleYOffset+18, kAlertWidth - serviceLabel.frame.size.width - 16, kTitleHeight)];
        self.serviceTextfield.delegate = self;
        self.serviceTextfield.font = [UIFont systemFontOfSize:15.0f];
        self.serviceTextfield.returnKeyType = UIReturnKeyNext;
        self.serviceTextfield.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.serviceTextfield];
        
        UILabel *operationsLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+18 + kTitleHeight + 8,75 , kTitleHeight)];
        operationsLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        operationsLabel.text = @"挖掘业务:";
        operationsLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:operationsLabel];
        
        self.operationsTextfield = [[UITextField alloc]initWithFrame:CGRectMake(serviceLabel.frame.size.width + 8, kTitleYOffset + 26 + kTitleHeight, kAlertWidth - operationsLabel.frame.size.width - 16, kTitleHeight)];
        self.operationsTextfield.delegate = self;
        self.operationsTextfield.font = [UIFont systemFontOfSize:15.0f];
        self.operationsTextfield.returnKeyType = UIReturnKeyDone;
        self.operationsTextfield.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.operationsTextfield];
        
        
        UILabel *alertContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.operationsTextfield.frame.size.height + self.operationsTextfield.frame.origin.y + 10 ,75 , kTitleHeight)];
        alertContentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        alertContentLabel.text = @"拜访内容:";
        alertContentLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:alertContentLabel];
        
        self.alertContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(alertContentLabel.frame.size.width + 8, self.operationsTextfield.frame.size.height + self.operationsTextfield.frame.origin.y + 10, kAlertWidth - alertContentLabel.frame.size.width - 16, 80)];
        
        self.alertContentTextView.delegate = self;
        self.alertContentTextView.returnKeyType = UIReturnKeyDone;
        self.alertContentTextView.keyboardType = UIKeyboardAppearanceDefault;
        self.alertContentTextView.textAlignment = NSTextAlignmentLeft;
//        self.alertContentTextView.backgroundColor = [UIColor lightGrayColor];
        self.alertContentTextView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        self.alertContentTextView.layer.borderWidth = 1;
        self.alertContentTextView.layer.cornerRadius = 5;
        self.alertContentTextView.layer.borderColor = RGBA(175, 175, 175, 1).CGColor;
        self.alertContentTextView.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.alertContentTextView];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 32.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rigthTitle placeholderTitle:(NSString *)placeholder{
    
    if (self = [super init]) {
        kAlertHeight = 200.0f;
        
//        kAlertWidth = [UIScreen mainScreen].bounds.size.width - 40;
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAlertWidth, kTitleHeight + 15)];
        self.alertTitleLabel.backgroundColor = RGBA(28, 132, 190, 1);
        
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.alertTitleLabel.textColor = [UIColor whiteColor];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        
        self.alertContentTextView = [[UITextView alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame) + 5, contentLabelWidth, 100)];

        self.alertContentTextView.delegate = self;
        self.alertContentTextView.returnKeyType = UIReturnKeyDone;
        self.alertContentTextView.keyboardType = UIKeyboardAppearanceDefault;
        self.alertContentTextView.textAlignment = NSTextAlignmentLeft;
        self.alertContentTextView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        self.alertContentTextView.layer.borderWidth = 1;
        self.alertContentTextView.layer.cornerRadius = 5;
        self.alertContentTextView.layer.borderColor = RGBA(175, 175, 175, 1).CGColor;
        self.alertContentTextView.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.alertContentTextView];
        
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, contentLabelWidth - 10, 50)];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [UIFont systemFontOfSize:15];
        self.placeholderLabel.textColor = RGBA(111, 113, 121, 1);
        self.placeholderLabel.text = placeholder;
        
        [self.alertContentTextView addSubview:self.placeholderLabel];
        
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 32.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        
//        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
//        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
//        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
//        [self addSubview:xButton];
//        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
      contentButton:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        kAlertHeight = 200;
        kAlertWidth = [UIScreen mainScreen].bounds.size.width - 40;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
//        [self addSubview:self.alertTitleLabel];
        
//        CGFloat contentLabelWidth = kAlertWidth - 16;
//        self.alertButton = [[UIButton alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertButton.frame), contentLabelWidth, 30)];
//        self.alertButton.titleLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
//        self.alertButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//        [self addSubview:self.alertButton];
//        [self.alertButton addTarget:self action:@selector(contentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+12,130 , kTitleHeight)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        titleLabel.text = @"督办拜访截止时间:";
        titleLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:titleLabel];
        
        self.alertButton = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width + 5, kTitleYOffset+12, kAlertWidth - titleLabel.frame.size.width - 8, 25)];
//        self.alertButton.titleLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
        
        [self.alertButton setTitleColor:RGBA(175, 175, 175, 1) forState:UIControlStateNormal];

        self.alertButton.layer.cornerRadius = 5;
        self.alertButton.layer.borderWidth = 1;
        self.alertButton.layer.borderColor = RGBA(175, 175, 175, 1).CGColor;
        self.alertButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [self addSubview:self.alertButton];
        
        
        UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+12 + kTitleHeight + 5, 80, kTitleHeight)];
        
        jobLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        jobLabel.text = @"工作内容:";
        jobLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:jobLabel];
        
        self.alertContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(jobLabel.frame.size.width+jobLabel.frame.origin.x + 3, jobLabel.frame.origin.y + 3, kAlertWidth - jobLabel.frame.size.width-jobLabel.frame.origin.x - 8, 90)];
        
        self.alertContentTextView.returnKeyType = UIReturnKeyDone;
        self.alertContentTextView.keyboardType = UIKeyboardAppearanceDefault;
        self.alertContentTextView.textAlignment = NSTextAlignmentLeft;
        
        self.alertContentTextView.layer.cornerRadius = 5;
        self.alertContentTextView.layer.borderWidth = 1;
        self.alertContentTextView.layer.borderColor = RGBA(175, 175, 175, 1).CGColor;
        
        self.alertContentTextView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        self.alertContentTextView.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.alertContentTextView];
        
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 32.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - kCoupleButtonWidth)/ 2, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
//            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
//        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        self.leftBtn.backgroundColor = RGBA(66, 187, 233, 1);
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
//        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title summaryText:(NSString *)content qradioButton:(NSString *)qradioTitle leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{
    
    if (self = [super init]) {
        kAlertHeight = 200;
        kAlertWidth = [UIScreen mainScreen].bounds.size.width - 40;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
//        [self addSubview:self.alertTitleLabel];
        
        //        CGFloat contentLabelWidth = kAlertWidth - 16;
        //        self.alertButton = [[UIButton alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertButton.frame), contentLabelWidth, 30)];
        //        self.alertButton.titleLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
        //        self.alertButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        //        [self addSubview:self.alertButton];
        //        [self.alertButton addTarget:self action:@selector(contentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+18,80 , kTitleHeight)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        titleLabel.text = [NSString stringWithFormat:@"%@：",content];
        titleLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:titleLabel];
        
        self.alertContentTextView = [[UITextView alloc]initWithFrame:CGRectMake(titleLabel.frame.size.width + 8, kTitleYOffset+18, kAlertWidth - titleLabel.frame.size.width - 16, kTitleHeight + 40)];
        self.alertContentTextView.delegate = self;
        self.alertContentTextView.font = [UIFont systemFontOfSize:14.0f];
        self.alertContentTextView.returnKeyType = UIReturnKeyDone;
        self.alertContentTextView.keyboardType = UIKeyboardAppearanceDefault;
        self.alertContentTextView.textAlignment = NSTextAlignmentLeft;
        
        self.alertContentTextView.layer.cornerRadius = 5;
        self.alertContentTextView.layer.borderWidth = 1;
        self.alertContentTextView.layer.borderColor = RGBA(175, 175, 175, 1).CGColor;
        
        self.alertContentTextView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        
        [self addSubview:self.alertContentTextView];
        
        UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kTitleYOffset+18 + kTitleHeight + 43, 80, kTitleHeight + 20)];
        jobLabel.numberOfLines = 0;
        jobLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        jobLabel.text = [NSString stringWithFormat:@"%@：",qradioTitle];
        jobLabel.textColor = RGBA(175, 175, 175, 1);
        [self addSubview:jobLabel];
        
        
        QRadioButton *radio_one = [[QRadioButton alloc] initWithDelegate:self groupId:@"1" type:0 answer:@"1"];
        
        radio_one.frame = CGRectMake(jobLabel.frame.size.width + 12, kTitleYOffset + 18 + self.alertContentTextView.frame.size.height + 5, 40, 44);
        
        radio_one.titleLabel.numberOfLines = 0;
        [radio_one setTitle:@"是" forState:UIControlStateNormal];
        [radio_one setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
        [radio_one.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [self addSubview:radio_one];

        QRadioButton *radio_two = [[QRadioButton alloc] initWithDelegate:self groupId:@"1" type:0 answer:@"0"];
        
        radio_two.frame = CGRectMake(jobLabel.frame.size.width + 12 + radio_one.frame.size.width + 20, kTitleYOffset + 18 + self.alertContentTextView.frame.size.height + 5, 40, 44);
        
        radio_two.titleLabel.numberOfLines = 0;
        [radio_two setTitle:@"否" forState:UIControlStateNormal];
        [radio_two setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
        [radio_two.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [self addSubview:radio_two];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 32.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - kCoupleButtonWidth)/ 2, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            //            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
        //        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        self.leftBtn.backgroundColor = RGBA(66, 187, 233, 1);
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        //        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.serviceTextfield) {
        [self.operationsTextfield becomeFirstResponder];
    } else if (textField == self.operationsTextfield) {
        [textField endEditing:YES];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([self.alertContentTextView.text length] == 0) {
        [self.placeholderLabel setHidden:NO];
    }else{
        [self.placeholderLabel setHidden:YES];
        
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)leftBtnClicked:(id)sender
{
    vsTaskVC.strSummery = self.alertContentTextView.text;
    vsTaskVC.strService = self.serviceTextfield.text;
    vsTaskVC.strOperations = self.operationsTextfield.text;
    
    if (_Pro_visitVC) {
        
        _Pro_visitVC.strSummery = self.alertContentTextView.text;
    }
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)contentBtnClicked:(id)sender
{
    if (!chvc) {
        chvc = [[CalendarHomeViewController alloc]init];
        chvc.calendartitle = @"选择日期";
        [chvc setAirPlaneToDay:365 ToDateforString:nil];//
    }

    chvc.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        
        if (model.holiday) {
            [sender setTitle:[NSString stringWithFormat:@"%@ %@ %@",[model toString],[model getWeek],model.holiday] forState:UIControlStateNormal];
        }else{
            [sender setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
        }
    };
    
//    [self.vsTaskVC.navigationController pushViewController:chvc animated:YES];
    [self.no_visitVC.navigationController pushViewController:chvc animated:YES];
    
    if (self.contentBlock) {
        self.contentBlock();
    }
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId type:(int)type answer:(NSString *)answer{
    
    if (type == 0) {
        
//        [answerMuDic setObject:radio.titleLabel.text forKey:[NSString stringWithFormat:@"%d",[groupId intValue]]];
        _Pro_visitVC.expect = answer;
        
    }
}

- (void)show
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

//- (void)handleKeyboardWillHide:(NSNotification *)notification
//{
//    UIViewController *topVC = [self appRootViewController];
//    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, kAlertHeight - 30, kAlertWidth, kAlertHeight);
//}
//
//- (void)handleKeyboardDidShow:(NSNotification *)notification
//{
//    UIViewController *topVC = [self appRootViewController];
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    if(screenHeight==568.0f){//iphone5
//        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, kAlertHeight - 90, kAlertWidth, kAlertHeight);
//    }else{//
//        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, kAlertHeight - 120, kAlertWidth, kAlertHeight);
//    }
//}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
