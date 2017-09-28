//
//  Business_Group_V_Net_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group_V_NetModel.h"
#import "CompEntity.h"

@interface Business_Group_V_Net_DetailViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (strong, nonatomic) Group_V_NetModel *entity;
@property (strong, nonatomic) CompEntity *compEntity;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;
@property(nonatomic, assign) int startcurrentPage;
@property(nonatomic, assign) int endcurrentPage;

- (void)loadData;
@end
