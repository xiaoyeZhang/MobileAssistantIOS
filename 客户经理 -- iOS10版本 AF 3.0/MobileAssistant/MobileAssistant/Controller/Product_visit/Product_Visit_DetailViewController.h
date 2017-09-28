//
//  Product_Visit_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Product_VisitListEntity.h"

@interface Product_Visit_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Product_VisitListEntity *entity;

@property (nonatomic, strong) NSString *strSummery;

@property (nonatomic, strong) NSString *expect;

@end
