//
//  M_Order_Demand_SumiltViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "P_AddPhotoViewController.h"
#import "CompEntity.h"
#import "M_Order_Demand_DetailEntity.h"

@interface M_Order_Demand_SumiltViewController : XYBaseViewController<AddPhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSArray *uploadImagesArr;

@property (nonatomic ,strong) NSMutableArray *uploadImagesNameArr;

@property (nonatomic, strong) CompEntity *entity;

@property (nonatomic, strong) NSArray *form_infoArr;

@property (nonatomic, strong) NSString *order_id;

@property (nonatomic, strong) NSDictionary *contenDic;

@end
