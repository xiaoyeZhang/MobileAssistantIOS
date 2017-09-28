//
//  News_ProviceVIP_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface News_ProviceVIP_ListViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property(nonatomic, assign) int currentPage;

@property (copy, nonatomic) NSString *module_id;
@property (copy, nonatomic) NSString *name;

- (IBAction)waitBtnClicked:(UIButton *)sender;
- (IBAction)dateBtnClicked:(UIButton *)sender;

@end
