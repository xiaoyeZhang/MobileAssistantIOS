//
//  Bussiness_StopOpenViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Bussiness_StopOpenViewController.h"
#import "UIColor+Hex.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "Business_StopOpenViewController.h"
#import "MBProgressHUD.h"
#import "UserEntity.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define MAINSCROLLHEIGHT self.view.bounds.size.height - 64

@interface Bussiness_StopOpenViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSDictionary *dict;
    NSString *SMS_code;
    NSTimer* timer1;
    int viewNum1;
    int viewNum4;
    int count;
}

@end

@implementation Bussiness_StopOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //横向分割线
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, (WIDTH - 3)/4, 2)];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#0099CC"];
    
    self.title = @"停开机";
    self.automaticallyAdjustsScrollViewInsets = NO;//防止留白
    ////////////////////////////定义主页面//////////////////////////
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, MAINSCROLLHEIGHT)];
    _mainScrollView.contentSize = CGSizeMake(WIDTH * 4, MAINSCROLLHEIGHT);
    _mainScrollView.pagingEnabled = YES;//整个页面翻页
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    
    ////////////////////////////定义标题页面//////////////////////////
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 38)];
    _titleScrollView.contentSize = CGSizeMake(WIDTH, 44);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.delegate = self;
    
    [self addMyButtons];
    [self addMyViews];
    [self.view addSubview:self.lineLabel];
    [self.view addSubview:_mainScrollView];
    [self.view addSubview:_titleScrollView];
}

- (void)addMyButtons
{
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 3)/4, 38)];
    [_button1 setTitle:@"随机密码" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 3)/4 + 1, 0, (WIDTH - 3)/4, 38)];
    [_button2 setTitle:@"用户密码" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    _button3 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 3)/2 + 2, 0, (WIDTH - 3)/4, 38)];
    [_button3 setTitle:@"证件验证" forState:UIControlStateNormal];
    [_button3 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    _button4 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 3)/4 * 3 + 3, 0, (WIDTH - 3)/4, 38)];
    [_button4 setTitle:@"综合验证" forState:UIControlStateNormal];
    [_button4 setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] forState:UIControlStateNormal];
    
    _button1.titleLabel.font = [UIFont systemFontOfSize:13];
    _button2.titleLabel.font = [UIFont systemFontOfSize:13];
    _button3.titleLabel.font = [UIFont systemFontOfSize:13];
    _button4.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    _button1.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    _button2.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    _button3.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    _button4.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    
    _button1.tag = 1;
    _button2.tag = 2;
    _button3.tag = 3;
    _button4.tag = 4;
    
    
    [_button1 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button4 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_titleScrollView addSubview:_button1];
    [_titleScrollView addSubview:_button2];
    [_titleScrollView addSubview:_button3];
    [_titleScrollView addSubview:_button4];
    
    
}

- (void)addMyViews
{
    _view1 = [[RandomViewController alloc]initWithFrame:CGRectMake(0, 0, WIDTH, MAINSCROLLHEIGHT)];
    _view2 = [[UserView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, MAINSCROLLHEIGHT)];
    _view3 = [[CertificatesView alloc]initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, MAINSCROLLHEIGHT)];
    _view4 = [[ComprehensiveView alloc]initWithFrame:CGRectMake(WIDTH * 3, 0, WIDTH, MAINSCROLLHEIGHT)];
    
    _view1.ResetButton.tag = 1;
    _view2.ResetButton.tag = 2;
    _view3.ResetButton.tag = 3;
    _view4.ResetButton.tag = 4;
    
    _view1.DetermineButton.tag = 1;
    _view2.DetermineButton.tag = 2;
    _view3.DetermineButton.tag = 3;
    _view4.DetermineButton.tag = 4;
    
    _view1.ObtainButton.tag = 5;
    _view4.ObtainButton.tag = 6;
    
    [_view1.ObtainButton addTarget:self action:@selector(ObtainButton:) forControlEvents:UIControlEventTouchUpInside];
    [_view4.ObtainButton addTarget:self action:@selector(ObtainButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_view1.DetermineButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_view2.DetermineButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_view3.DetermineButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_view4.DetermineButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:_view1];
    [_mainScrollView addSubview:_view2];
    [_mainScrollView addSubview:_view3];
    [_mainScrollView addSubview:_view4];
    
}

#pragma mark ------- scrollView的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [UIView animateWithDuration:0.5 animations:^{
        _x = _mainScrollView.contentOffset.x;
        
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-6)/4, 2);
    }];
}

- (void)turn:(UIButton*)sender{
    
    NSInteger i = sender.tag - 1;
    
    [_mainScrollView setContentOffset:CGPointMake(i * WIDTH, 0) animated:YES];
    
    if(sender.tag == 1)
    {
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-6)/4, 2);
    }else if (sender.tag == 2){
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-6)/4, 2);
    }else if (sender.tag == 3){
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-6)/4, 2);
    }else if (sender.tag == 4){
        _x = _mainScrollView.contentOffset.x;
        self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*WIDTH, 38, (WIDTH-6)/4, 2);
    }
}

- (void)ObtainButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    viewNum1 = 0;
    viewNum4 = 0;
    if (sender.tag == 5) {
        self.ServiceNum = _view1.Phone_numberText.text;
        [timer1 invalidate];
        count = 0;
        _view4.ObtainButton.enabled = YES;
        [_view4.ObtainButton setTitle:@"获取" forState:UIControlStateNormal];
        [_view4.ObtainButton setBackgroundColor:[UIColor colorWithRed:0.11 green:0.60 blue:0.8 alpha:1]];
        
        viewNum1 = 5;
    }else if(sender.tag == 6){
        self.ServiceNum = _view4.Phone_numberText.text;
        [timer1 invalidate];
        count = 0;
        _view1.ObtainButton.enabled = YES;
        [_view1.ObtainButton setTitle:@"获取" forState:UIControlStateNormal];
        [_view1.ObtainButton setBackgroundColor:[UIColor colorWithRed:0.11 green:0.60 blue:0.8 alpha:1]];
        
        viewNum4 = 6;
    }
    
    if (self.ServiceNum.length == 11) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"发送验证码";
        
        CommonService *service = [[CommonService alloc] init];
        UserEntity *entity = [UserEntity sharedInstance];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        
        dic = @{@"method":@"service_code",
                @"tel":self.ServiceNum,
                @"user_id":entity.user_id,
                @"oi_type":@"2",
                };
        
        [service getNetWorkData:dic  Successed:^(id entity) {
            
            int state = [entity[@"state"] intValue];
            
            if (state == 1) {
                SMS_code = [entity[@"content"] stringValue];
                sender.enabled = NO;
                timer1 = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(showRepeatButton)
                                                        userInfo:nil
                                                         repeats:YES];
                [sender setBackgroundColor:[UIColor lightGrayColor]];
                [timer1 fire];
                
            }else{
                
                ALERT_ERR_MSG(entity[@"msg"]);
            }
            [HUD hide:YES];
        } Failed:^(int errorCode, NSString *message) {
            
            [HUD hide:YES];
        }];
        
        
    }else{
        ALERT_ERR_MSG(@"手机格式错误");
        return;
    }
    
    
}

- (void)showRepeatButton{
//    static int count = 0;
    if (viewNum1 == 5) {
        if (count++ >= 120) {
            _view1.ObtainButton.enabled = YES;
            [timer1 invalidate];
            count = 0;
            [_view1.ObtainButton setTitle:@"获取" forState:UIControlStateNormal];
            [_view1.ObtainButton setBackgroundColor:[UIColor colorWithRed:0.11 green:0.60 blue:0.8 alpha:1]];
            return;
        }
        [_view1.ObtainButton setTitle:[NSString stringWithFormat:@"%i秒",120-count] forState:UIControlStateNormal];
    }
    if (viewNum4 == 6) {
        if (count++ >= 120) {
            _view4.ObtainButton.enabled = YES;
            [timer1 invalidate];
            count = 0;
            [_view4.ObtainButton setTitle:@"获取" forState:UIControlStateNormal];
            [_view4.ObtainButton setBackgroundColor:[UIColor colorWithRed:0.11 green:0.60 blue:0.8 alpha:1]];
            return;
        }
        [_view4.ObtainButton setTitle:[NSString stringWithFormat:@"%i秒",120-count] forState:UIControlStateNormal];
    }
    
}

//登陆
- (void)submitBtnClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *msg = nil;
    UserEntity *userEntity = [UserEntity sharedInstance];
    Business_StopOpenViewController *vc = [[Business_StopOpenViewController alloc]init];
    
    if (sender.tag == 1) {
        if (_view1.Phone_numberText.text.length == 0) {
            msg = @"请填写手机号";
        }else if (_view1.Identifying_codeText.text.length == 0) {
            msg = @"请填写验证码";
        }
    }else if (sender.tag == 2){
        if (_view2.Phone_numberText.text.length == 0) {
            msg = @"请填写手机号";
        }else if (_view2.ServiceText.text.length == 0) {
            msg = @"请填写服务密码";
        }
    }else if (sender.tag == 3){
        if (_view3.user_nameText.text.length == 0) {
            msg = @"请填写用户名";
        }else if (_view3.IDText.text.length == 0) {
            msg = @"请填写身份证号";
        }
    }else if (sender.tag == 4){
        if (_view4.Phone_numberText.text.length == 0) {
            msg = @"请填写手机号";
        }else if (_view4.ServiceText.text.length == 0) {
            msg = @"请填写服务密码";
        }else if (_view4.messageText.text.length == 0) {
            msg = @"请填写验证码";
        }
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        
        return;
    }
    
    if (sender.tag == 1) {
        
        self.ServiceNum = _view1.Phone_numberText.text;
        self.message = _view1.Identifying_codeText.text;
        if (self.ServiceNum.length == 11) {
            
            if ([self.message isEqualToString:SMS_code]) {
                
                vc.ServiceNum = _ServiceNum;
                [vc loadData];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }else{
                ALERT_ERR_MSG(@"验证码错误");
                return;
            }
        }else{
            
            ALERT_ERR_MSG(@"手机格式错误");
            return;
        }
        
    }else if (sender.tag == 2){
        
        self.ServiceNum = _view2.Phone_numberText.text;
        self.Password = _view2.ServiceText.text;
        if (self.ServiceNum.length == 11) {
            
            dict = @{@"method":@"whole_province",
                     @"oicode":@"OI_VerifyUserPassword",
                     @"user_id":userEntity.user_id,
                     @"ServiceNum":_ServiceNum,
                     @"Password":_Password,
                     };
            
        }else{
            ALERT_ERR_MSG(@"手机格式错误");
            return;
        }
    }else if (sender.tag == 3){
        
        self.ServiceNum = _view3.user_nameText.text;
        self.Password = _view3.IDText.text;
        if (self.ServiceNum.length == 11) {
            dict = @{@"method":@"whole_province",
                     @"oicode":@"OI_VerifyCertInfo",
                     @"user_id":userEntity.user_id,
                     @"ServiceNum":_ServiceNum,
                     @"CertCode":_Password,
                     };
        }else{
            
            ALERT_ERR_MSG(@"手机格式错误");
            return;
        }
    }else if (sender.tag == 4){
        
        self.ServiceNum = _view4.Phone_numberText.text;
        self.Password = _view4.ServiceText.text;
        self.message = _view4.messageText.text;
        if (self.ServiceNum.length == 11) {
            
            if ([self.message isEqualToString:SMS_code]) {
                
                dict = @{@"method":@"whole_province",
                         @"oicode":@"OI_VerifyUserPassword",
                         @"user_id":userEntity.user_id,
                         @"ServiceNum":_ServiceNum,
                         @"Password":_Password,
                         };
                
            }else{
                ALERT_ERR_MSG(@"验证码错误");
                return;
            }
            
        }else{
            
            ALERT_ERR_MSG(@"手机格式错误");
            return;
        }
        
    }
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"登陆中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    if([dict objectForKey:@"CertCode"] != 0){
        
        [service getNetWorkData:dict  Successed:^(id entity) {
            
            int state = [entity[@"state"] intValue];
            
            if (state == 1) {
                NSDictionary *dic = entity[@"content"];
                
                if ([dic[@"CheckResult"] isEqualToString:@"Y"]) {
                    
                    vc.ServiceNum = _ServiceNum;
                    [vc loadData];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    
                }
                
                
            }else{
                ALERT_ERR_MSG([entity objectForKey:@"msg"]);
                
            }
            [HUD hide:YES];
        } Failed:^(int errorCode, NSString *message) {
            
            [HUD hide:YES];
            if ([message isEqualToString:@"似乎已断开与互联网的连接"]) {
                ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
            }else{
//                ALERT_ERR_MSG(@"服务时间超时!");
            }
        }];
        
    }else if([dict objectForKey:@"Password"] != 0){
        [service getNetWorkData:dict  Successed:^(id entity) {
            
            int state = [entity[@"state"] intValue];
            
            if (state == 1) {
                
                vc.ServiceNum = _ServiceNum;
                [vc loadData];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ALERT_ERR_MSG(entity[@"msg"]);
            }
            [HUD hide:YES];
        } Failed:^(int errorCode, NSString *message) {
            
            [HUD hide:YES];
            if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
                ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
            }else{
//                ALERT_ERR_MSG(@"服务时间超时!");
            }
        }];
    }
}

- (void)ResetButton:(UIButton *)sender{
    
    self.ServiceNum = @"";
    self.Password = @"";
    self.message = @"";
    if (sender.tag == 1) {
        _view1.Phone_numberText.text = @"";
        _view1.Identifying_codeText.text = @"";
    }else if (sender.tag == 2){
        _view2.Phone_numberText.text = @"";
        _view2.ServiceText.text = @"";
    }else if (sender.tag == 3){
        _view3.user_nameText.text = @"";
        _view3.IDLabel.text = @"";
    }else if (sender.tag == 4){
        _view4.Phone_numberText.text = @"";
        _view4.ServiceText.text = @"";
        _view4.messageText.text = @"";
    }
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
