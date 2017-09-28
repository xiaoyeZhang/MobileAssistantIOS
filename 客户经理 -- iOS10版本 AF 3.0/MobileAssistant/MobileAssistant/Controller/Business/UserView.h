//
//  UserView.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserView : UIView

@property (strong, nonatomic) UILabel *Phone_numberLabel;
@property (strong, nonatomic) UILabel *ServiceLabel;

@property (strong, nonatomic) UITextField *Phone_numberText;
@property (strong, nonatomic) UITextField *ServiceText;

@property (strong, nonatomic) UIButton *ResetButton;
@property (strong, nonatomic) UIButton *DetermineButton;
@property (strong, nonatomic) UILabel  *label1;

@end
