//
//  TestScoresViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/9.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "TestScoresViewController.h"
#import "Examination_SeconViewController.h"
#import "MainBaseViewController.h"
#import "Centralized_managementViewController.h"

@interface TestScoresViewController ()

@end

@implementation TestScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *RightBtn = [self setNaviRightBtnWithTitle:@"完成"];
//    [RightBtn addTarget:self action:@selector(RightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *scoresStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@分",_Scores] attributes:nil];
    
    [scoresStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(_Scores.length, 1)];
    
    self.scoresLabel.attributedText = scoresStr;
    
    if ([_Scores intValue] >= 60) {
        self.messageLabel.text = @"恭喜你通过考试";
    }else{
        self.messageLabel.text = @"很抱歉未通过考试";
    }
    
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    if ([_type isEqualToString:@"0"]) {
        Examination_SeconViewController *vc = [[Examination_SeconViewController alloc]init];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[vc class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    }else if ([_type isEqualToString:@"1"]){
        Centralized_managementViewController *vc = [[Centralized_managementViewController alloc]init];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[vc class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    }

}

- (void)RightBtnClicked:(UIButton *)sender{
    
    [self backBtnClicked:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
