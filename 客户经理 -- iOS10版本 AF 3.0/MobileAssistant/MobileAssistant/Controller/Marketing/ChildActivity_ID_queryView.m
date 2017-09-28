//
//  ChildActivity_ID_queryView.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "ChildActivity_ID_queryView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation ChildActivity_ID_queryView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.activity_ID_query = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, WIDTH - 100, 30)];
    self.activity_ID_query.placeholder = @"请输入活动ID查询";
    
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.activity_ID_query.leftView = paddingView;
    self.activity_ID_query.leftViewMode = UITextFieldViewModeAlways;
    
    self.activity_ID_query.layer.cornerRadius=5.0f;
    self.activity_ID_query.layer.masksToBounds=YES;
    self.activity_ID_query.layer.borderColor = [UIColor colorWithRed:162.0/255 green:162.0/255 blue:162.0/255 alpha:1].CGColor;
    self.activity_ID_query.layer.borderWidth= 1.0f;
    self.activity_ID_query.font = [UIFont systemFontOfSize:15];
    self.activity_ID_query.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.activity_ID_query.returnKeyType = UIReturnKeyDone;
    [self.activity_ID_query addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.certainButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 80, 50, 80, 30)];
    self.certainButton.backgroundColor = [UIColor whiteColor];
    [self.certainButton setTitle:@"查询" forState:UIControlStateNormal];
    [self.certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.certainButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.activity_titlename = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 30)];
    [self.activity_titlename setTitle:@"" forState:UIControlStateNormal];
    [self.activity_titlename setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.activity_titlename.titleLabel.font = [UIFont systemFontOfSize:16];
    self.activity_titlename.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.activity_ID_query];
    [self addSubview:self.certainButton];
    [self addSubview:self.activity_titlename];
    
    return self;
}

-(void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}
@end
