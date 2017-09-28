//
//  News_ProviceVIP_Edit_DetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/25.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P_AddPhotoViewController.h"
#import "P_AddDevicesViewController.h"
#import "XYDatePicker.h"

@interface News_ProviceVIP_Edit_DetailViewController :XYTableBaseViewController<XYDatePickerDelegate,AddPhotoViewControllerDelegate,AddDevicesViewControllerDelegate>

@property (copy, nonatomic) NSString *business_id;

@property(nonatomic ,strong) NSArray *uploadImagesArr;
///订货类型
@property(nonatomic, copy) NSString *order_type;

///到货时间
@property(nonatomic, copy) NSString *order_time;

///机型
@property(nonatomic, copy) NSString *order_info;

@property (copy, nonatomic) NSString *name;

@end
