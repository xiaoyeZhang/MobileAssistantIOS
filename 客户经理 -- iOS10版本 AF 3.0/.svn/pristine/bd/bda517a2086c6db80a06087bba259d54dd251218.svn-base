//
//  SuggestViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-6.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "SuggestViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"

@interface SuggestViewController ()<MBProgressHUDDelegate,UITextViewDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation SuggestViewController

@synthesize TextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";
    [self select_logmodel:NSStringFromClass([self class])];
    
    self.btn0.selected = YES;
    self.type_id = @"0";
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //bgImageView.backgroundColor = GrayBackgroundColor;
    bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImageView];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.TextView.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"SuggestViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"SuggestViewController"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
{
    if (isShowNavigationBar) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 7.0f) {
            return self.view.frame.size.height - 64.0f;
        }
        else
            return self.view.frame.size.height - 44.0;
    }
    else {
        return self.view.frame.size.height;
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if ([TextView.text length] == 0) {
        [self.textFileLabel setHidden:NO];
    }else{
        [self.textFileLabel setHidden:YES];
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.suggestMessage = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)doSendFeedback:(id)sender
{
    if (self.suggestMessage.length == 0) {
        ALERT_ERR_MSG(@"请输入反馈内容");
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self sendData];
}

- (void) sendData
{
    
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    /*
     [titleDataArray count], @"level",
     [titleDataArray count], @"visit",
     [titleDataArray count], @"type",
     [titleDataArray count], @"scope",
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"feedback", @"method",
                           entity.user_id, @"user_id",
                           self.suggestMessage, @"content",
                           self.type_id, @"type_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        if (state > 0) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈信息提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if (state == 0){
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈信息提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}
- (IBAction)selectBtn:(UIButton *)sender {
    
    if (sender.tag == 0) {
        self.btn0.selected = YES;
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.type_id = @"0";
    }else if(sender.tag == 1){
        self.btn0.selected = NO;
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.type_id = @"1";
    }else if(sender.tag == 2){
        self.btn0.selected = NO;
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.type_id = @"2";
    }else if(sender.tag == 3){
        self.btn0.selected = NO;
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.type_id = @"3";
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        
    }
    if (0==buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了确认按钮");
    }
}

@end
