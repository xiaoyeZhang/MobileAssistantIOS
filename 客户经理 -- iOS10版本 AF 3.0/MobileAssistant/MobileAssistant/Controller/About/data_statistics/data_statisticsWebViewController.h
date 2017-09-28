//
//  data_statisticsWebViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "XYStartEndDatePicker.h"

@interface data_statisticsWebViewController : XYBaseViewController<XYStartEndDatePickerDelegate>

@property (strong, nonatomic) NSString *name;

@property (nonatomic, strong)NIDropDown *dropDown;

@property (nonatomic, strong) NSString *select_type;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@end
