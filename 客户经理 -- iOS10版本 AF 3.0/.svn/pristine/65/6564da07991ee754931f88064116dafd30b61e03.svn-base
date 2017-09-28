//
//  MessageTableViewCell.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    _messageText.returnKeyType = UIReturnKeyDone;
    [_messageText addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

-(void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
