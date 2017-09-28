//
//  Marketing_CenterAllViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/14.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@interface Marketing_CenterAllViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewNews;
@property (weak, nonatomic) IBOutlet UIButton *system_news_Btn;
@property (weak, nonatomic) IBOutlet UIButton *company_news_Btn;

@end
