//
//  TaskListViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "SUNListViewController.h"

@interface TaskListViewController : XYBaseViewController
@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) SUNListViewController *vc1;
@property (nonatomic, strong) SUNListViewController *vc2;
@property (nonatomic, strong) SUNListViewController *vc3;
@property (nonatomic, strong) SUNListViewController *vc4;

@property (nonatomic, strong) SUNListViewController *currentVC;

@property (nonatomic, strong) CompEntity *compEntity;

@property (nonatomic, strong) IBOutlet UIView* viewCondition;
@property (nonatomic, strong) IBOutlet UILabel* labelStatus;
@property (nonatomic, strong) IBOutlet UILabel* labelCompany;
@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) IBOutlet UIView* background;

- (void) setCustomerValue:(CompEntity *)ex;

@end
