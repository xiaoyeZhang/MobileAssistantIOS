//
//  News_Select_Next_listViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/2/6.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "News_PtovinceVip_Next_CustomerEntity.h"

@class News_Select_Next_listViewController;

@protocol News_Select_Next_listViewControllerDelegate <NSObject>

@optional

- (void)News_Select_Next_listViewControllerViewController:(News_Select_Next_listViewController *)vc didSelectCompany:(News_PtovinceVip_Next_CustomerEntity *)entity;

@end

@interface News_Select_Next_listViewController : XYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@property(nonatomic, weak) id<News_Select_Next_listViewControllerDelegate> delegate;

@end
