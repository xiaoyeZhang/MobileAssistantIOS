//
//  InformationViewViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/6.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface InformationViewViewController : XYBaseViewController

@property (nonatomic, strong) NSString *time_type;

@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *Btn2;
@property (weak, nonatomic) IBOutlet UIButton *Btn3;
@property (weak, nonatomic) IBOutlet UIView *CenterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView* viewCondition;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *Call_todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *Visit_weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *Visit_last_weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *Visit_month;
@property (weak, nonatomic) IBOutlet UILabel *Last_month_visit;
@end
