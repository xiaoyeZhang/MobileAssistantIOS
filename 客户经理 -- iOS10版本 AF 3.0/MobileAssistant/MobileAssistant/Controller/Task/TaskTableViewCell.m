//
//  TaskTableViewCell.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-21.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell
@synthesize labelContact, labelCustomer, labelDate, labelTitle;
@synthesize imageViewStatus;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
