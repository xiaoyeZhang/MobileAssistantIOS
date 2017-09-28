//
//  XYTableBaseViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "TxtFieldTableViewCell.h"
#import "UIAlertView+Blocks.h"
#import "SIAlertView.h"

@interface XYTableBaseViewController : XYBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
}

//返回
- (void)backBtnClicked:(id)sender;
//提交
- (void)submitBtnClicked:(id)sender;

- (void)get_three_list:(NSString *)business_type Successed:(void(^)(id entity)) successed;
//- (void)getNetWorkData:(NSDictionary *)param Successed:(void(^)(id entity)) successed Failed:(void(^)(int errorCode ,NSString *message))failed;
@end
