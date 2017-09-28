//
//  SA_Special_SumbitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/8/7.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "P_AddPhotoViewController.h"
#import "CompEntity.h"

@interface SA_Special_SumbitViewController : XYBaseViewController<AddPhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSArray *uploadImagesArr;

@property (nonatomic ,strong) NSMutableArray *uploadImagesNameArr;

@property (nonatomic, strong) CompEntity *entity;

@property (nonatomic, strong) NSString *product_name;

@property (nonatomic, strong) NSString *type;

@end
