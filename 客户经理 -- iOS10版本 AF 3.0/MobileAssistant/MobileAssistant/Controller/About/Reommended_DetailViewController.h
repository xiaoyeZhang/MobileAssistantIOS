//
//  Reommended_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Reommended_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *APP_ID;
@property (copy, nonatomic) NSString *APP_Name;

@property (copy, nonatomic) NSString *tel;

@end
