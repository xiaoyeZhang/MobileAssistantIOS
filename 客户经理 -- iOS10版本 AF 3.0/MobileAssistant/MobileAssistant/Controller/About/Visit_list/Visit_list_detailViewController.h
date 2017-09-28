//
//  Visit_list_detailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/11/10.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface Visit_list_detailViewController : XYBaseViewController<NIDropDownDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *company_name;
@property (copy, nonatomic) NSString *actor_id;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@property (nonatomic, strong)NIDropDown *dropDown;

@property (nonatomic, assign)NSInteger type;

@end
