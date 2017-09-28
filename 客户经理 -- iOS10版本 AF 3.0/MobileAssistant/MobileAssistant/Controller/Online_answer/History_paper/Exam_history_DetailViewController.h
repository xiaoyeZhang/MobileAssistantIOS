//
//  Exam_history_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Exam_historylistEntity.h"

@interface Exam_history_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Exam_historylistEntity *entity;
@end
