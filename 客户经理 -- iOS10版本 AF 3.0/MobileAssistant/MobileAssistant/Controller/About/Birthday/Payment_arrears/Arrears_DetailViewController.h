//
//  Arrears_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Arrears_taskEntity.h"

@interface Arrears_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *arrearage_id;
@property (strong, nonatomic) Arrears_taskEntity *entity;

@end
