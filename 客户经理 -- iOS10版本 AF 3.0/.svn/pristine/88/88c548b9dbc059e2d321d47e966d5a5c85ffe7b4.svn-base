//
//  ChangePwdViewController.m
//  MobileAssistant
//
//  Created by xy on 15/10/16.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UserEntity.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "MainViewController.h"

@interface ChangePwdViewController ()<UITextFieldDelegate>

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"修改密码";
    
    super.model = NSStringFromClass([self class]);
    
    if (self.type == 3) {
        
        [self.navigationItem.backBarButtonItem setTitle:@""];
        [self.navigationItem setHidesBackButton:YES];
    }else{
        UIButton *backBtn = [self setNaviCommonBackBtn];
        [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    numTxtField.text = userInfo.num;
    phoneTxtField.text = userInfo.tel;
}


#pragma mark -

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (IBAction)changePwdBtnClicked:(id)sender
{
    
    if (newPwdTxtField.text.length == 0) {
        ALERT_ERR_MSG(@"请输入新密码");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    if (newPwdTxtField.text.length < 8) {
        ALERT_ERR_MSG(@"新密码至少为8位");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    
    NSString *numregex = @"[0-9]";

    NSString *daxieregex = @"[A-Z]";
    
    NSString *xiaoxieregex = @"[a-z]";
    
    NSString *teshuregex = @"\\p{Punct}+";
    
    
    NSRegularExpression *regular1 = [[NSRegularExpression alloc] initWithPattern:numregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results1 = [regular1 matchesInString:newPwdTxtField.text options:0 range:NSMakeRange(0, newPwdTxtField.text.length)];
    
    if (results1.count == 0) {
        ALERT_ERR_MSG(@"密码必须包含数字");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    NSRegularExpression *regular2 = [[NSRegularExpression alloc] initWithPattern:daxieregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results2 = [regular2 matchesInString:newPwdTxtField.text options:0 range:NSMakeRange(0, newPwdTxtField.text.length)];
    
    
    if (results2.count == 0) {
        ALERT_ERR_MSG(@"密码必须包含大写字母");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    NSRegularExpression *regular3 = [[NSRegularExpression alloc] initWithPattern:xiaoxieregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results3 = [regular3 matchesInString:newPwdTxtField.text options:0 range:NSMakeRange(0, newPwdTxtField.text.length)];
    
    if (results3.count == 0) {
        
        ALERT_ERR_MSG(@"密码必须包含小写字母");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    NSRegularExpression *regular4 = [[NSRegularExpression alloc] initWithPattern:teshuregex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results4 = [regular4 matchesInString:newPwdTxtField.text options:0 range:NSMakeRange(0, newPwdTxtField.text.length)];
    
    if (results4.count == 0) {
        ALERT_ERR_MSG(@"密码必须包含特殊符号");
        [newPwdTxtField becomeFirstResponder];
        return;
    }
    
    if (confirmPwdTxtField.text.length == 0) {
        ALERT_ERR_MSG(@"请再次确认新密码");
        [confirmPwdTxtField becomeFirstResponder];
        return;
    }
    
    if (![confirmPwdTxtField.text isEqualToString:newPwdTxtField.text]) {
        ALERT_ERR_MSG(@"新密码和确认密码输入不一致");
        [confirmPwdTxtField becomeFirstResponder];
        return;
    }
    
    NSDictionary *dict = @{@"method":@"changepassword",
                           @"num":numTxtField.text,
                           @"tel":phoneTxtField.text,
                           @"password":newPwdTxtField.text};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      id content = entity[@"reason"];
                      if (state == 1) {
                          
                          if (self.type == 3) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                              message:content
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"确定"
                                                                    otherButtonTitles:nil, nil];
                              [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                  
                                  MainViewController *vc = [[MainViewController alloc] init];
                                  [self.navigationController pushViewController:vc animated:YES];
                                  return ;
                              }];
                              
                              
                          }else{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                              message:content
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"确定"
                                                                    otherButtonTitles:nil, nil];
                              [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                  [self backBtnClicked:nil];
                              }];
                          }
                 
                          UserEntity *userEntity1 = [[UserEntity alloc] init];
                          userEntity1 = [userEntity1 initWithAttributes:entity];
                          UserEntity *userEntity = [UserEntity sharedInstance];
                          [userEntity deepCopy:userEntity1];
                          
                      }else{
                          iToast *toast = [iToast makeText:content];
                          [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                          [toast setDuration:500];
                          [toast show:iToastTypeNotice];
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      iToast *toast = [iToast makeText:@"网络连接失败"];
                      [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                      [toast setDuration:500];
                      [toast show:iToastTypeNotice];
                  }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == numTxtField |
        textField == phoneTxtField) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
