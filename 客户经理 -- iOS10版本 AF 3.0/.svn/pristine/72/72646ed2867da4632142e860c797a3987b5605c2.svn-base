//
//  CheckBoxTableViewCell.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "CheckBoxTableViewCell.h"

@implementation CheckBoxTableViewCell

- (void)awakeFromNib {
    // Initialization code
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectDataWithArray:(NSArray *)array
{
    self.selectArray = array;
    
    if ([array count]  == 2) {
        for (UIButton *btn in self.contentView.subviews) {
            if ([btn isMemberOfClass:[UIButton class]]) {
                
                [btn setTitle:self.selectArray[btn.tag-1] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectBtnIndex:(int)index
{
    if (index == 1) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
    }else{
        self.btn1.selected = NO;
        self.btn2.selected = YES;
    }
    
    self.selectedIndex = index;
}

- (IBAction)btnClicked:(id)sender {
    
    for (UIButton *btn in self.contentView.subviews) {
        if ([btn isMemberOfClass:[UIButton class]]) {
            if (btn == sender) {
                if (!btn.selected) {
                    btn.selected = YES;
                    
                    self.selectedIndex = btn.tag;
                    
                    if ([self.delegate respondsToSelector:@selector(checkBoxTableViewCell:checkDidChanged:)]) {
                        [self.delegate checkBoxTableViewCell:self checkDidChanged:self.selectedIndex];
                    }
                }
            }else{
                btn.selected = NO;
            }
            
        }
    }
    
}


@end
