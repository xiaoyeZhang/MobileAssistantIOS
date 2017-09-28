//
//  Product_classificationViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/5.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product_classificationViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *type_id;
@end
