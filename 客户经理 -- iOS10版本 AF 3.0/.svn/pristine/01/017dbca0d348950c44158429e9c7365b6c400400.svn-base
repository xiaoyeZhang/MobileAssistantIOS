//
//  CertificatesView.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "CertificatesView.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation CertificatesView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 117)/ 2, HEIGHT - 90, 117, 21)];
    
    self.user_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 21)];
    self.IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 100, 21)];
    
    self.user_nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 18, 200, 25)];
    self.IDText = [[UITextField alloc]initWithFrame:CGRectMake(90, 61, 200, 25)];
    
    self.ResetButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, (WIDTH - 60)/2, 26)];
    self.DetermineButton = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 60)/2 + 40, 120, (WIDTH - 60)/2, 26)];
    
    
    self.ResetButton.backgroundColor = [UIColor colorWithRed:126.0/255 green:200.0/255 blue:227.0/255 alpha:1];
    self.DetermineButton.backgroundColor = [UIColor colorWithRed:28.0/255 green:135.0/255 blue:192.0/255 alpha:1];
    
    self.user_nameLabel.font = [UIFont systemFontOfSize:13];
    self.IDLabel.font = [UIFont systemFontOfSize:13];
    
    self.user_nameText.font = [UIFont systemFontOfSize:14];
    self.IDText.font = [UIFont systemFontOfSize:14];
    self.label1.font = [UIFont systemFontOfSize:15];
    
    self.ResetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.DetermineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.user_nameText.returnKeyType = UIReturnKeyDone;
    self.IDText.returnKeyType = UIReturnKeyDone;
    [self.user_nameText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.IDText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.user_nameLabel.text = @"用 户 名 ：";
    self.IDLabel.text = @"身份证号：";
    
    self.user_nameText.placeholder = @"请输入用户名";
    self.IDText.placeholder = @"请输入身份证号";
    self.label1.text = @"服务时间超时!";
    
    self.label1.alpha = 0;
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
    
    self.IDText.layer.cornerRadius=5.0f;
    self.IDText.layer.masksToBounds=YES;
    self.IDText.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.IDText.layer.borderWidth= 1.0f;
    self.IDText.textAlignment = NSTextAlignmentCenter;
    self.IDText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.ResetButton.layer.cornerRadius = 5.0f;
    self.ResetButton.layer.masksToBounds = YES;
    
    self.DetermineButton.layer.cornerRadius = 5.0f;
    self.DetermineButton.layer.masksToBounds = YES;
    
    [self addSubview:self.user_nameLabel];
    [self addSubview:self.user_nameText];
    [self addSubview:self.IDLabel];
    [self addSubview:self.IDText];
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
