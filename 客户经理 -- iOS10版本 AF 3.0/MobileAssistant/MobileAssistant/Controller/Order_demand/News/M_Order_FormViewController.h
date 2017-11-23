//
//  M_Order_FormViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/23.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_Order_Demand_SumiltEntity.h"

@protocol M_Order_FormViewControllerDelegate <NSObject>

- (void)successM_OrderFormDelegate:(NSDictionary *)successdelegate;

@end

@interface M_Order_FormViewController : XYBaseViewController

@property (nonatomic, strong) id <M_Order_FormViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) M_Order_Demand_SumiltEntity *methodEntity;

@property (strong, nonatomic) NSString *Id;
@end
