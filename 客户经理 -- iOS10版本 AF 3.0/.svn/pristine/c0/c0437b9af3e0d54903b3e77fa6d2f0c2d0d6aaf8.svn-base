//
//  ComprehensiveView.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "ComprehensiveView.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation ComprehensiveView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 117)/ 2, HEIGHT - 90, 117, 21)];
    
    self.Phone_numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 21)];
    self.ServiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 100, 21)];
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 100, 21)];
    
    self.Phone_numberText = [[UITextField alloc]initWithFrame:CGRectMake(90, 18, 210, 25)];
    self.ServiceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 61, 210, 25)];
    self.messageText = [[UITextField alloc]initWithFrame:CGRectMake(90, 104, 150, 25)];
    
    self.ObtainButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 104, 50, 26)];
    self.ResetButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 160, (WIDTH - 60)/2, 26)];
    self.DetermineButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 60)/2 + 40, 160, (WIDTH - 60)/2, 26)];
    
    self.ObtainButton.backgroundColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1];
    self.ResetButton.backgroundColor = [UIColor colorWithRed:126.0/255 green:200.0/255 blue:227.0/255 alpha:1];
    self.DetermineButton.backgroundColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1];
    
    [self.ServiceText setSecureTextEntry:YES];
    
    self.Phone_numberLabel.font = [UIFont systemFontOfSize:13];
    self.ServiceLabel.font = [UIFont systemFontOfSize:13];
    self.messageLabel.font = [UIFont systemFontOfSize:13];
    
    self.Phone_numberText.font = [UIFont systemFontOfSize:14];
    self.ServiceText.font = [UIFont systemFontOfSize:14];
    self.messageText.font = [UIFont systemFontOfSize:14];
    self.label1.font = [UIFont systemFontOfSize:15];
    
    self.Phone_numberText.returnKeyType = UIReturnKeyDone;
    self.ServiceText.returnKeyType = UIReturnKeyDone;
    self.messageText.returnKeyType = UIReturnKeyDone;
    [self.Phone_numberText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.ServiceText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.messageText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.ObtainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.ResetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.DetermineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.Phone_numberLabel.text = @"手机号码：";
    self.ServiceLabel.text = @"服务密码：";
    self.messageLabel.text = @"短信验证：";
    
    self.Phone_numberText.placeholder = @"请输入手机号";
    self.ServiceText.placeholder = @"请输入服务密码";
    self.messageText.placeholder = @"请输入验证码";
    self.label1.text = @"服务时间超时!";
    
    self.label1.alpha = 0;
    [self.ObtainButton setTitle:@"获取" forState:UIControlStateNormal];
    [self.ResetButton setTitle:@"重置" forState:UIControlStateNormal];
    [self.DetermineButton setTitle:@"确认" forState:UIControlStateNormal];
    
    [self.ObtainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.DetermineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.Phone_numberText.layer.cornerRadius=5.0f;
    self.Phone_numberText.layer.masksToBounds=YES;
    self.Phone_numberText.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.Phone_numberText.layer.borderWidth= 1.0f;
    self.Phone_numberText.textAlignment = NSTextAlignmentCenter;
    self.Phone_numberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.ServiceText.layer.cornerRadius=5.0f;
    self.ServiceText.layer.masksToBounds=YES;
    self.ServiceText.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.ServiceText.layer.borderWidth= 1.0f;
    self.ServiceText.textAlignment = NSTextAlignmentCenter;
    self.ServiceText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.messageText.layer.cornerRadius=5.0f;
    self.messageText.layer.masksToBounds=YES;
    self.messageText.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.messageText.layer.borderWidth= 1.0f;
    self.messageText.textAlignment = NSTextAlignmentCenter;
    self.messageText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.ObtainButton.layer.cornerRadius = 5.0f;
    self.ObtainButton.layer.masksToBounds = YES;
    
    self.ResetButton.layer.cornerRadius = 5.0f;
    self.ResetButton.layer.masksToBounds = YES;
    
    self.DetermineButton.layer.cornerRadius = 5.0f;
    self.DetermineButton.layer.masksToBounds = YES;
    
    [self addSubview:self.Phone_numberLabel];
    [self addSubview:self.Phone_numberText];
    [self addSubview:self.ServiceLabel];
    [self addSubview:self.ServiceText];
    [self addSubview:self.messageLabel];
    [self addSubview:self.messageText];
    [self addSubview:self.ObtainButton];
    [self addSubview:self.ResetButton];
    [self addSubview:self.DetermineButton];
    [self addSubview:self.label1];
    
    return self;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

@end
