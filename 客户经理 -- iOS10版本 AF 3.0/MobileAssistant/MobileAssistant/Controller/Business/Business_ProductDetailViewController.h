//
//  Business_ProductDetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/17.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Business_ProductDetailViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *AttrInstInfoDic;
@end
