
//
//  White_list_queryViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "White_list_queryViewController.h"
#import "White_query_Detail_listViewController.h"
#import "MBProgressHUD.h"

@interface White_list_queryViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation White_list_queryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"可办理营销活动查询";
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.user_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 21)];
    
    self.user_nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 38, 200, 25)];
    
    self.ResetButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, (SCREEN_WIDTH - 60)/2, 30)];
    self.DetermineButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2 + 40, 100, (SCREEN_WIDTH - 60)/2, 30)];
    
    
    self.ResetButton.backgroundColor = [UIColor colorWithRed:126.0/255 green:200.0/255 blue:227.0/255 alpha:1];
    self.DetermineButton.backgroundColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1];
    
    self.user_nameLabel.font = [UIFont systemFontOfSize:13];
    
    self.user_nameText.font = [UIFont systemFontOfSize:14];
    
    self.ResetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.DetermineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.user_nameText.returnKeyType = UIReturnKeyDone;
    [self.user_nameText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];

    
    self.user_nameLabel.text = @"手机号码：";
    
    self.user_nameText.placeholder = @"请输入手机号码";
    self.user_nameText.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.ResetButton setTitle:@"重置" forState:UIControlStateNormal];
    [self.DetermineButton setTitle:@"确认" forState:UIControlStateNormal];
    
    [self.ResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.DetermineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.user_nameText.layer.cornerRadius=5.0f;
    self.user_nameText.layer.masksToBounds=YES;
    self.user_nameText.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.user_nameText.layer.borderWidth= 1.0f;
    self.user_nameText.textAlignment = NSTextAlignmentCenter;
    self.user_nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.ResetButton.layer.cornerRadius = 5.0f;
    self.ResetButton.layer.masksToBounds = YES;
    
    self.DetermineButton.layer.cornerRadius = 5.0f;
    self.DetermineButton.layer.masksToBounds = YES;
    
    
    [self.ResetButton addTarget:self action:@selector(ResetButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.DetermineButton addTarget:self action:@selector(DetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.user_nameLabel];
    [self.view addSubview:self.user_nameText];
    [self.view addSubview:self.ResetButton];
    [self.view addSubview:self.DetermineButton];
    

}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ResetButton:(UIButton *)sender{
    
    self.user_nameText.text = @"";
    
}

- (void)DetermineButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntiy = [UserEntity sharedInstance];

    NSDictionary *dict = @{@"method":@"whole_province",
                           @"user_id":userEntiy.user_id,
                           @"oicode":@"OI_QueryActivitySignupType",
                           @"ServiceNum":self.user_nameText.text,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            if ([[[entity objectForKey:@"content"] objectForKey:@"Desc"] rangeOfString:@"受理成功"].location != NSNotFound) {
                NSDictionary *dic = [entity objectForKey:@"content"];
                
                White_query_Detail_listViewController *vc = [[White_query_Detail_listViewController
                                                              alloc]init];
                vc.ListDic = dic;
                
                if([[dict allKeys] containsObject:@"ResultList"])
                {
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    ALERT_ERR_MSG(@"不是目标用户！");
                }
            
            }else{
                
                ALERT_ERR_MSG([[entity objectForKey:@"content"] objectForKey:@"Desc"]);
            
            }

        }else{
            ALERT_ERR_MSG([entity objectForKey:@"msg"]);
        }
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)TextFieldEndEdited:(id)sender{
    
    [self.view endEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
