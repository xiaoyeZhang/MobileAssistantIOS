//
//  M_Product_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_Order_Demand_SumiltEntity.h"

@protocol M_Product_listViewControllerDelegate <NSObject>

- (void)successM_Product_listViewDelegate:(NSDictionary *)successdelegate;

@end

@interface M_Product_listViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;

@property (strong, nonatomic) M_Order_Demand_SumiltEntity *entity;
@property (strong, nonatomic) NSMutableArray *data_arr;
@property (nonatomic, strong) NSMutableArray *data_arrCutomer;

@property (nonatomic, strong) id <M_Product_listViewControllerDelegate>delegate;

@end
