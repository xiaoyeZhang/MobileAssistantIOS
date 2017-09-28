//
//  LeftIconCollectionViewCell.m
//  MobileAssistant
//
//  Created by xy on 15/10/10.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "LeftIconCollectionViewCell.h"
#import "UIColor+Hex.h"

@implementation LeftIconCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.selectedBackgroundView = selectedBgView;
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.8];
}

@end
