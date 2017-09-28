//
//  Peoduct_Visit_Select_userViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "No_visit_listEntity.h"

@class Product_Visit_Select_userViewController;

@protocol Product_VisitViewControllerDelegate <NSObject>

@optional
- (void)addProduct_VisitViewController:(Product_Visit_Select_userViewController *)vc didSelectUser:(No_visit_listEntity *)UserEntity;

@end

@interface Product_Visit_Select_userViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) id <Product_VisitViewControllerDelegate>delegate;

@end
