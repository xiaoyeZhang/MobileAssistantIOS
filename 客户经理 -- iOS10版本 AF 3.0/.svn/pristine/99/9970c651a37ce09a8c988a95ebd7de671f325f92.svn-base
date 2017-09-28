//
//  XYStartEndDatePicker.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYStartEndDatePicker.h"

@interface XYStartEndDatePicker ()
{
    UIView *_bgView;
    UIControl *_control;
    
    
}

@end


@implementation XYStartEndDatePicker

- (void)dealloc
{

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleHeight;
        
        _control = [[UIControl alloc] initWithFrame:self.bounds];
        _control.backgroundColor = [UIColor blackColor];
        _control.alpha = 0;
        _control.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_control addTarget:self action:@selector(cancelBtnClickd:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_control];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-398, self.frame.size.width, 398)];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(cancelBtnClickd:)];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(doneBtnClicked:)];
        
        _lableItem = [[UIBarButtonItem alloc] initWithTitle:@"请选择起始时间" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                           target:nil
                                                                                           action:nil];
        toolbar.items = @[cancelItem,flexibleSpaceItem,_lableItem,flexibleSpaceItem,doneItem];
        [_bgView addSubview:toolbar];
        
        
        self.showDateFormatter = @"yyyy-MM-dd";
        
        _startDatePicker = [[UIDatePicker alloc] init];
        _startDatePicker.frame = CGRectMake(0, 44, self.bounds.size.width, 162);
        _startDatePicker.datePickerMode = UIDatePickerModeDate;
//        _startDatePicker.maximumDate = [NSDate date];
        _startDatePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _startDatePicker.locale = locale;
        [_startDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgView addSubview:_startDatePicker];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _startDatePicker.frame.origin.y+_startDatePicker.frame.size.height+5, self.bounds.size.width, 20)];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        label.text = @"到";
        label.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:label];
        
        
        _endDatePicker = [[UIDatePicker alloc] init];
        _endDatePicker.frame = CGRectMake(0, label.frame.origin.y+label.frame.size.height+5, self.bounds.size.width, 162);
        _endDatePicker.datePickerMode = UIDatePickerModeDate;
        _endDatePicker.maximumDate = [NSDate date];
        _endDatePicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _endDatePicker.locale = locale;
        [_endDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgView addSubview:_endDatePicker];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *startDateStr = [dateFormatter stringFromDate:_startDatePicker.date];
        NSString *endDateStr = [dateFormatter stringFromDate:_endDatePicker.date];
        
        _lableItem.title = [NSString stringWithFormat:@"%@ ~ %@",startDateStr,endDateStr];
    }
    
    return self;
}

+ (instancetype)datePicker
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CGRect rect = _bgView.frame;
    rect.origin.y += rect.size.height;
    _bgView.frame = rect;
    
    
    CGRect showRect = rect;
    showRect.origin.y -= showRect.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _control.alpha = 0.5;
                         _bgView.frame = showRect;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
}

- (void)dismiss
{
    CGRect rect = _bgView.frame;
    rect.origin.y += rect.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _control.alpha = 0;
                         _bgView.frame = rect;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
    
}

#pragma mark -

- (void)cancelBtnClickd:(id)sender
{
    if ([_delegate respondsToSelector:@selector(startEndDatePickerCancelPressed:)]) {
        [_delegate startEndDatePickerCancelPressed:self];
    }
    
    [self dismiss];
}

- (void)doneBtnClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(startEndDatePickerDonePressed:)]) {
        [_delegate startEndDatePickerDonePressed:self];
    }
    
    [self dismiss];
}

- (void)datePickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:self.showDateFormatter];
    NSString *startDateStr = [dateFormatter stringFromDate:_startDatePicker.date];
    NSString *endDateStr = [dateFormatter stringFromDate:_endDatePicker.date];
    
    _lableItem.title = [NSString stringWithFormat:@"%@ ~ %@",startDateStr,endDateStr];
}

@end
