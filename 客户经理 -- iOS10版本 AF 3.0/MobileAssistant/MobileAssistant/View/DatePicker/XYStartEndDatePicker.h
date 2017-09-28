//
//  XYStartEndDatePicker.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYStartEndDatePicker;
@protocol XYStartEndDatePickerDelegate <NSObject>

@optional
@optional
- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker;
- (void)startEndDatePickerCancelPressed:(XYStartEndDatePicker *)datePicker;

@end


@interface XYStartEndDatePicker : UIView

@property(nonatomic, strong) UIDatePicker *startDatePicker;
@property(nonatomic, strong) UIDatePicker *endDatePicker;
@property(nonatomic, weak) id<XYStartEndDatePickerDelegate> delegate;
@property(nonatomic, copy) NSString *showDateFormatter;

@property (strong,nonatomic)UIBarButtonItem *lableItem;

+ (instancetype)datePicker;

- (void)show;
- (void)dismiss;

@end
