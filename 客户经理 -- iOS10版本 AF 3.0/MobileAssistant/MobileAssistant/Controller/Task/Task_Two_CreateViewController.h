//
//  TaskCreateViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExecutorEntity.h"
#import "CompEntity.h"
#import "ContactEntity.h"
#import "This_month_unvisitEntity.h"
#import "Handling_tasksEntity.h"
#import "No_visit_baselistEntity.h"

@interface Task_Two_CreateViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UIButton *btnShowMore;
@property (nonatomic, strong) IBOutlet UIView *viewMore;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *titleTextField;

@property (nonatomic, strong) IBOutlet UITextField *actionTextField;
@property (nonatomic, strong) IBOutlet UIButton *actionBtn;

@property (nonatomic, strong) IBOutlet UITextField *customerTextField;
@property (nonatomic, strong) IBOutlet UIButton *customerBtn;

@property (nonatomic, strong) IBOutlet UITextField *contactTextField;
@property (nonatomic, strong) IBOutlet UIButton *contactBtn;

@property (nonatomic, strong) IBOutlet UITextField *jobTitleTextField;
@property (nonatomic, strong) IBOutlet UITextField *addrTextField;

@property (nonatomic, strong) IBOutlet UITextField *dateTextField;
@property (nonatomic, strong) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *up_dataBtn;

@property (nonatomic, strong) IBOutlet UITextField *desTextField;
@property (nonatomic, strong) IBOutlet UITextField *taskNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *giftNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *Yes_Btn;
@property (weak, nonatomic) IBOutlet UIButton *No_Btn;
@property (weak, nonatomic) IBOutlet UIButton *setCustomer_epresentativeBtn;
@property (weak, nonatomic) IBOutlet UILabel *Customer_epresentativeLabel;

@property (nonatomic, strong) ExecutorEntity *exEntity;
@property (nonatomic, strong) CompEntity *compEntity;
@property (nonatomic, strong) ContactEntity *contactEntity;

- (void) setExecutorValue:(ExecutorEntity *)ex;
- (void) setCustomerValue:(CompEntity *)ex;
- (void) setCotactValue:(ContactEntity *)ex;

- (void) setCustomer_epresentative:(ExecutorEntity *)ex;

@property (assign) BOOL fromCoustomer;

@property (strong, nonatomic) This_month_unvisitEntity *entity;

@property (strong, nonatomic) Handling_tasksEntity *handlingEntity;
@property (strong, nonatomic) No_visit_baselistEntity *No_visit_Entity;


@end
