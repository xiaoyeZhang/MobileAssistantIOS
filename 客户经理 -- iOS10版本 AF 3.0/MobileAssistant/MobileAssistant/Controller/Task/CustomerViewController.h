//
//  CustomerViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateViewController.h"
#import "ConditionEntity.h"
#import "TaskListViewController.h"
#import "ContactAddViewController.h"
#import "Task_Two_CreateViewController.h"
#import "Order_Demand_SumiltViewController.h"

//add by xy
@class CustomerViewController;
@protocol CustomerViewControllerDelegate <NSObject>

@optional
- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity;

@end
//end


@interface CustomerViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewCutomer;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSDictionary *contenDic;

@property (nonatomic, strong) TaskCreateViewController *tcVC;
@property (nonatomic, strong) TaskListViewController *tlVC;
@property (nonatomic, strong) ContactAddViewController *addCusVC;
@property (nonatomic, strong) Task_Two_CreateViewController *t_two_VC;
@property (nonatomic, strong) Order_Demand_SumiltViewController *OderVC;

@property (nonatomic, strong) NSString *product_name;
@property (assign) int enter_type;

- (void) addCompObj:(CompEntity *)entity;

@property (nonatomic, strong) IBOutlet UIView* viewCondition;

@property (nonatomic, strong) IBOutlet UILabel* lable1;
@property (nonatomic, strong) IBOutlet UILabel* lable2;
@property (nonatomic, strong) IBOutlet UILabel* lable3;
@property (nonatomic, strong) IBOutlet UILabel* lable4;

@property (nonatomic, strong) ConditionEntity *condition1;
@property (nonatomic, strong) ConditionEntity *condition2;
@property (nonatomic, strong) ConditionEntity *condition3;
@property (nonatomic, strong) ConditionEntity *condition4;

@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnReset;
@property (nonatomic, strong) IBOutlet UIButton *btnSure;

@property (nonatomic, strong) IBOutlet UITextField *textFieldKey;

@property(nonatomic, weak) id<CustomerViewControllerDelegate> delegate; //add by xy

- (void) setConditionView;

@end
