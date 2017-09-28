//
//  OrderUserViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/2/15.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderUserViewControllerDelegate <NSObject>

- (void)successOrderUserDelegate:(NSDictionary *)successdelegate;

@end

@interface OrderUserViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) id <OrderUserViewControllerDelegate>delegate;

@end
