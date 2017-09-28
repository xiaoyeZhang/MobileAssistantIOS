//
//  ThreeCheckBoxTableViewCell.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "ThreeCheckBoxTableViewCell.h"

@implementation ThreeCheckBoxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelectDataWithArray:(NSArray *)array
{
    self.selectArray = array;
    
    if ([array count]  == 3) {
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
        self.btn3.selected = NO;
    }else if(index == 2){
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
    }else if(index == 3){
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
    }
    
    self.selectedIndex = index;
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    for (UIButton *btn in self.contentView.subviews) {
        if ([btn isMemberOfClass:[UIButton class]]) {
            if (btn == sender) {
                if (!btn.selected) {
                    btn.selected = YES;
                    
                    self.selectedIndex = btn.tag;
                    
                    if ([self.delegate respondsToSelector:@selector(ThreecheckBoxTableViewCell:checkDidChanged:)]) {
                        [self.delegate ThreecheckBoxTableViewCell:self checkDidChanged:self.selectedIndex];
                    }
                }
            }else{
                btn.selected = NO;
            }
            
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
