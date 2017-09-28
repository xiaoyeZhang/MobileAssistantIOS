//
//  CertificatesView.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificatesView : UIView

@property (strong, nonatomic) UILabel *user_nameLabel;
@property (strong, nonatomic) UILabel *IDLabel;

@property (strong, nonatomic) UITextField *user_nameText;
@property (strong, nonatomic) UITextField *IDText;

@property (strong, nonatomic) UIButton *ResetButton;
@property (strong, nonatomic) UIButton *DetermineButton;
@property (strong, nonatomic) UILabel  *label1;

@end
