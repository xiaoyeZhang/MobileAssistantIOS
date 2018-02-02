//
//  News_ProvinceVip_Detail_TwoViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/2.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UserEntity.h"
#import "MJExtension.h"

@interface News_ProvinceVip_Detail_TwoViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *titleName;

@property (copy, nonatomic) NSString *business_id;

@property(nonatomic, strong) NSMutableArray *detailMuArr;

@property(nonatomic, strong) NSMutableArray *processMuArr;

@property(nonatomic, strong) NSMutableArray *select_listMuArr;

@end
