//
//  DatePicker.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/18.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSArray *_nameArray;
}
@property (strong, nonatomic) UIPickerView *pickerView;

-(id)initWithFrameRect:(CGRect)rect;

@end
