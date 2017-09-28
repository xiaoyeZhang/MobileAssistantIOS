//
//  XYDatePicker.m
//  JXSAdmin
//
//  Created by xy on 15/8/21.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import "XYDatePicker.h"

@interface XYDatePicker ()
{
    UIView *_bgView;
    UIControl *_control;
}

@end

@implementation XYDatePicker

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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-206, self.frame.size.width, 206)];
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
        
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
        toolbar.items = @[cancelItem,flexibleSpaceItem,doneItem];
        [_bgView addSubview:toolbar];
        
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 44, self.bounds.size.width, 160);
        _datePicker.datePickerMode = UIDatePickerModeDate;
//        _datePicker.minimumDate = [NSDate date];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _datePicker.locale = locale;
        [_bgView addSubview:_datePicker];
        
    }
    
    return self;
}

+ (instancetype)datePicker
{
    return [[XYDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
    self.date = nil;
    
    if ([_delegate respondsToSelector:@selector(datePickerCancelPressed:)]) {
        [_delegate datePickerCancelPressed:self];
    }
    
    [self dismiss];
}

- (void)doneBtnClicked:(id)sender
{
    self.date = self.datePicker.date;
    
    if ([_delegate respondsToSelector:@selector(datePickerDonePressed:)]) {
        [_delegate datePickerDonePressed:self];
    }
    
    [self dismiss];
}

@end
