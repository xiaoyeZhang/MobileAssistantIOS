//
//  News_MyGroup_MessageViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/9.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompEntity.h"

@interface News_MyGroup_MessageViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *Btn_one;
@property (weak, nonatomic) IBOutlet UIButton *Btn_two;

@property (copy, nonatomic) NSString *name;

@property (nonatomic, strong) CompEntity *compEntity;

@end
