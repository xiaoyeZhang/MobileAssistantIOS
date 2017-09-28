//
//  No_visit_Detail_ListViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/8/12.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface No_visit_Detail_ListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *visit_state;

@property(nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSString *name;
@end

