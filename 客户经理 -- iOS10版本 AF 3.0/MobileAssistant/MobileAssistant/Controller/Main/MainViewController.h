//
//  MainViewController.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "ATLabel.h"

@interface MainViewController : ZXYBaseViewController<EScrollerViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *MainCollectionView;

@property (strong, nonatomic) IBOutlet UIView *MainTableView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *Already_visitedLabel;
@property (weak, nonatomic) IBOutlet UILabel *Not_visitedLabel;
@property (weak, nonatomic) IBOutlet UILabel *P_StockLabel;
@property (weak, nonatomic) IBOutlet UILabel *P_BookLabel;
@property (weak, nonatomic) IBOutlet UILabel *P_BillLabel;
@property (weak, nonatomic) IBOutlet UILabel *P_MarketingLabel;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) IBOutlet ATLabel *animatedLabel;

@property (assign) int page;

@property (nonatomic, strong) IBOutlet UIButton *btnMain;
@property (nonatomic, strong) IBOutlet UIButton *btnMainText;
@property (nonatomic, strong) IBOutlet UIButton *btnCoustomer;
@property (nonatomic, strong) IBOutlet UIButton *btnCoustomerText;
@property (nonatomic, strong) IBOutlet UIButton *btnNews;
@property (nonatomic, strong) IBOutlet UIButton *btnNewsText;
@property (nonatomic, strong) IBOutlet UIButton *btnAbout;
@property (nonatomic, strong) IBOutlet UIButton *btnAboutText;

@property(nonatomic, assign) BOOL isAutoInP_VIP; //是否自动进入业务办理界面

@end
