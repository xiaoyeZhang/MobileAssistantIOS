//
//  SuggestViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-6.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *textFileLabel;

@property (strong, nonatomic) NSString *type_id;
@property (strong, nonatomic) NSString *suggestMessage;

@end
