//
//  CoustomerMainNewsViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-5.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ConditionEntity.h"
#import "CompEntity.h"
@interface CoustomerMainNewsViewController : ZXYBaseViewController

@property (nonatomic, strong) NSMutableArray *mutableArry;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;

@property (nonatomic, strong) IBOutlet UIView* viewCondition;

@property (weak, nonatomic) IBOutlet UIButton *doSearch;
@property (nonatomic, strong) IBOutlet UILabel* lable1;
@property (nonatomic, strong) IBOutlet UILabel* lable2;
@property (nonatomic, strong) IBOutlet UILabel* lable3;
@property (nonatomic, strong) IBOutlet UILabel* lable4;
@property (nonatomic, strong) IBOutlet UIView* background;

@property (nonatomic, strong) ConditionEntity *condition1;
@property (nonatomic, strong) ConditionEntity *condition2;
@property (nonatomic, strong) ConditionEntity *condition3;
@property (nonatomic, strong) ConditionEntity *condition4;

@property (nonatomic, strong) NSString *strSearchKey;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *message;
- (void) setConditionView;
- (void) loadData;
- (void) addCompObj:(CompEntity *)entity;

@end
