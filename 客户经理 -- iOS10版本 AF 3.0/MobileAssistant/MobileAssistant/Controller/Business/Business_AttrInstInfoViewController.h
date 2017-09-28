//
//  Business_AttrInstInfoViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/16.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Business_AttrInstInfoViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *AttrInstInfo;
@property (nonatomic ,assign) int num;

@end
