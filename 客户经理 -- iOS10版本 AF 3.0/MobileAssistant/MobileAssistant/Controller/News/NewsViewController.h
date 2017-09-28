//
//  NewsViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-20.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface NewsViewController : ZXYBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewNews;
@property (weak, nonatomic) IBOutlet UIButton *system_news_Btn;
@property (weak, nonatomic) IBOutlet UIButton *company_news_Btn;
@property (nonatomic, strong) NSMutableArray *mutableArryNews;
@property (assign) int page;
@property (nonatomic, strong) MainViewController *mainVC;
- (void) reloadNewsData;

@end
