//
//  Examination_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/9.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exam_listEntity.h"

@interface Examination_DetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Exam_listEntity *entity;
@end
