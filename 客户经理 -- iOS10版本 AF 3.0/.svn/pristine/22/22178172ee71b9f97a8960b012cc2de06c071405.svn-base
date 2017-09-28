//
//  News_CustomerViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/24.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News_PtovinceVip_Next_CustomerEntity.h"

@class News_CustomerViewController;

@protocol News_CustomerViewControllerDelegate <NSObject>

@optional

- (void)News_CustomerViewControllerViewController:(News_CustomerViewController *)vc didSelectCompany:(NSMutableDictionary *)dic;

- (void)News_Next_CustomerViewControllerViewController:(News_CustomerViewController *)vc didSelectCompany:(News_PtovinceVip_Next_CustomerEntity *)entity;

@end

@interface News_CustomerViewController : XYBaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldKey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *data_source;

@property (copy, nonatomic) NSString *data_source_addition;

@property (copy, nonatomic) NSString *dep_id;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSMutableDictionary *dic;

@property(nonatomic, weak) id<News_CustomerViewControllerDelegate> delegate;

- (void)getData;

- (void)getData_Next;
@end
