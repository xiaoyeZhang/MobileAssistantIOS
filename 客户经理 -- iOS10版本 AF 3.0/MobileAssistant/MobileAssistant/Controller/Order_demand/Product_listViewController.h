//
//  Product_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/28.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Product_listViewControllerDelegate <NSObject>

- (void)successProduct_listDelegate:(NSArray *)successdelegate;

@end

@interface Product_listViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;

@property (nonatomic, strong) NSMutableArray *arrayCutomer;
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;

@property (nonatomic, strong) id <Product_listViewControllerDelegate>delegate;
@end
