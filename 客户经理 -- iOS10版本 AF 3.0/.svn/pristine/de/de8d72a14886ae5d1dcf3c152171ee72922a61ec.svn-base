//
//  XYDatePicker.h
//  JXSAdmin
//
//  Created by xy on 15/8/21.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDatePicker;
@protocol XYDatePickerDelegate <NSObject>

@optional
- (void)datePickerDonePressed:(XYDatePicker *)datePicker;
- (void)datePickerCancelPressed:(XYDatePicker *)datePicker;
//- (void)datePicker:(XYDatePicker *)datePicker selectedDateDidChange:(NSDate *)selectedDate;

@end



@interface XYDatePicker : UIView

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, weak) id<XYDatePickerDelegate> delegate;

+ (instancetype)datePicker;

- (void)show;
- (void)dismiss;

@end
