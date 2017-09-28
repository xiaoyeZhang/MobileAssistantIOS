//
//  M_OrderDeleteViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/5/24.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P_AddPhotoViewController.h"

@interface M_OrderDeleteViewController : XYBaseViewController<UITextFieldDelegate,AddPhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSArray *uploadImagesArr;

@property (nonatomic ,strong) NSMutableArray *uploadImagesNameArr;

@property (nonatomic, strong) NSString *order_id;
@end
