//
//  Select_section_ManmerViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/26.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P_Vertical_industry_collaborationSubmitViewController.h"

@class Select_section_ManmerViewController;
@protocol Select_section_ManmerViewControllerDelegate <NSObject>

@optional
- (void)Select_section_ManmerViewController:(Select_section_ManmerViewController *)vc didSelectUser:(NSMutableDictionary *)dic;

@end

@interface Select_section_ManmerViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) P_Vertical_industry_collaborationSubmitViewController *tcVC;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSDictionary *selectDic;

@property(nonatomic, weak) id<Select_section_ManmerViewControllerDelegate> delegate;


@end
