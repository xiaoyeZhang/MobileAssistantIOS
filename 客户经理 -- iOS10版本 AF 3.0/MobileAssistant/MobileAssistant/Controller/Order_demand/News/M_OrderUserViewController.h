//
//  M_OrderUserViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol M_OrderUserViewControllerDelegate <NSObject>

- (void)successM_OrderUserDelegate:(NSDictionary *)successdelegate;

@end

@interface M_OrderUserViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSString *order_id;

@property (nonatomic, strong) NSString *type_id;

@property (nonatomic, strong) NSString *Type;


@property (nonatomic, strong) id <M_OrderUserViewControllerDelegate>delegate;

@end
