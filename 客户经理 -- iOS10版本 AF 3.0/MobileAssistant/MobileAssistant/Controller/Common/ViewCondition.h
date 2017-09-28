//
//  ViewCondition.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/24.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCondition : UIView


@property (weak, nonatomic) IBOutlet UIButton *HideSearchBtn;

@property (weak, nonatomic) IBOutlet UIButton *ResetBtn;
@property (weak, nonatomic) IBOutlet UIButton *ComfirmBtn;

@property (weak, nonatomic) IBOutlet UITableView *ConditionTabelView;

@end
