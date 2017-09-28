//
//  P_MarketingSubmitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/3.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "BusinessListModel.h"
#import "XYDatePicker.h"

@interface P_MarketingSubmitViewController : XYTableBaseViewController<XYDatePickerDelegate>

@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, strong) BusinessListModel *bListModel;

@property(nonatomic, copy) NSString *create_id;
@property(nonatomic, copy) NSString *type_id;
@property(nonatomic, copy) NSString *activity_name;
@property(nonatomic, copy) NSString *company_name;
@property(nonatomic, copy) NSString *company_num;
@property(nonatomic, copy) NSString *client_name;
@property(nonatomic, copy) NSString *tel_num;
@property(nonatomic, copy) NSString *take_time;
@property(nonatomic, copy) NSString *complaint_reason;
@property(nonatomic, copy) NSString *change_mode;

@end
