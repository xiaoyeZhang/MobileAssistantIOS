//
//  P_CardSubmitViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "BusinessListModel.h"

@interface P_CardSubmitViewController : XYTableBaseViewController

@property(nonatomic, strong) NSDictionary *detailDict;
@property(nonatomic, strong) BusinessListModel *bListModel;

@end
