//
//  Business_change_SumbitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/7.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "CompEntity.h"

@interface Business_change_SumbitViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CompEntity *entity;

@property (nonatomic ,strong) NSArray *uploadImagesArr;

@property (nonatomic ,strong) NSMutableArray *uploadImagesNameArr;
@end
