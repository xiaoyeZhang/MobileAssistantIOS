//
//  Visit_list_quertViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/11/8.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYStartEndDatePicker.h"

@interface Visit_list_quertViewController : XYBaseViewController<XYStartEndDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dataBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@end
