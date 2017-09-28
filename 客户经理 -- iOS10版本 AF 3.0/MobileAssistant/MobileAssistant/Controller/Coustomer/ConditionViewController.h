//
//  ConditionViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-7.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoustomerMainNewsViewController.h"
#import "CustomerViewController.h"

@interface ConditionViewController : XYBaseViewController

@property (nonatomic, strong) NSMutableArray *mutableArry;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CoustomerMainNewsViewController *cmn;
@property (nonatomic, strong) CustomerViewController *cvc;

@property (assign) int type;
@property (assign) int enter_type;

@end
