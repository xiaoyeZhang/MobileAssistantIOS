//
//  ForgetPwdViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-28.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"

@interface ForgetPwdViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}


@end

@implementation ForgetPwdViewController
@synthesize telTextFied;
@synthesize oldPwdTextFied;
@synthesize newestPwdTextFied;
@synthesize comfirmPwdTextFied;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    
    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(modifyPwd:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"修改" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
    [oldPwdTextFied setSecureTextEntry:YES];
    [newestPwdTextFied setSecureTextEntry:YES];
    [comfirmPwdTextFied setSecureTextEntry:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyPwd:(id)sender
{
    if (telTextFied.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你尚未输入手机号码，请输入手机号码！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (oldPwdTextFied.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你尚未输入旧密码，请输入旧密码！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (newestPwdTextFied.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你尚未输入新密码，请新密码！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (comfirmPwdTextFied.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你尚未输入确认密码，请输入确认密码！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([newestPwdTextFied.text isEqualToString:comfirmPwdTextFied.text] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"新密码与确认密码不一致，请重新输入！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doModfiyPwdTask];
    
}

- (void)doModfiyPwdTask
{
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           telTextFied.text, @"tel",
                           oldPwdTextFied.text, @"old_password",
                           newestPwdTextFied.text, @"new_password",
                           @"changepassword", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
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
