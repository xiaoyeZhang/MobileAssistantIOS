//
//  ChangePhoneViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/21.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "UserEntity.h"
#import "iToast.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "UserService.h"
#import "JPUSHService.h"

@interface ChangePhoneViewController ()<UITextFieldDelegate>

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改手机号码";
    super.model = NSStringFromClass([self class]);
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    numTxtField.userInteractionEnabled = NO;
    phoneTxtField.userInteractionEnabled = NO;
    numTxtField.text = userInfo.num;
    phoneTxtField.text = userInfo.tel;
    newphoneTxtField.keyboardType = UIKeyboardTypeNumberPad;

}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePhoneBtnClicked:(id)sender {
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    if (newphoneTxtField.text.length == 0) {
        ALERT_ERR_MSG(@"请输入新手机号");
        [newphoneTxtField becomeFirstResponder];
        return;
    }
    
    if (newphoneTxtField.text.length != 11) {
        ALERT_ERR_MSG(@"手机号格式不对");
        [newphoneTxtField becomeFirstResponder];
        return;
    }
    if ([newphoneTxtField.text isEqualToString:userEntity.tel]) {
        ALERT_ERR_MSG(@"新输入的手机号码不能跟老手机号一样");
        [newphoneTxtField becomeFirstResponder];
        return;
    }
    
    [newphoneTxtField resignFirstResponder];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_ChangeManagerBillId",
                           @"user_id":userEntity.user_id,
                           @"ManagerId":numTxtField.text,
                           @"NewBillId":newphoneTxtField.text};

    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      id content = entity[@"reason"];
                      if (state == 1) {
                          
                          iToast *toast = [iToast makeText:@"修改成功"];
                          [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                          [toast setDuration:500];
                          [toast show:iToastTypeNotice];
                          [self backBtnClicked:nil];
                          [self loginTask:@"login"];
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

- (void) loginTask:(NSString *)method
{
    //    NSLog(@"%@", [OpenUDID value]);
    
    NSDictionary *clientInfoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *clientVersion = clientInfoDict[@"CFBundleVersion"];
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    UserService *service = [[UserService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           newphoneTxtField.text, @"tel",
                           userInfo.password, @"password",
                           clientVersion, @"version",
                           method, @"method", nil];
    
    [service loginWithPassword:param  Successed:^(UserEntity *entity) {
        
        if ([entity.state isEqualToString:@"2"] == YES ) {
            
            NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:entity];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:myEncodedObject forKey:@"UserEntity"];
            
            UserEntity *userInfo = [UserEntity sharedInstance];
//            [APService setAlias:userInfo.tel callbackSelector:@selector(userSetAliasCallBack:) object:nil];

            [JPUSHService setAlias:userInfo.tel completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                DebugLog(@"%@",iAlias);
                
            } seq:[userInfo.num intValue]];
            
        } else if ([entity.state isEqualToString:@"3"] == YES) {
            


        } else {

        }

    } Failed:^(int errorCode, NSString *message) {

    }];
}

- (void)userSetAliasCallBack:(id)sender
{
    DebugLog(@"%@",sender);
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
