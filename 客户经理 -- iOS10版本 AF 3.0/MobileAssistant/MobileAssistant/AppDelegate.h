//
//  AppDelegate.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TaskListViewController.h"
#import "MALocationEntity.h"
#import "SGLNavigationViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

- (void) chnageRootToLoginVC;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (nonatomic, strong) TaskListViewController *taskListVC;
@property (strong , nonatomic) UINavigationController *nav;
@end
