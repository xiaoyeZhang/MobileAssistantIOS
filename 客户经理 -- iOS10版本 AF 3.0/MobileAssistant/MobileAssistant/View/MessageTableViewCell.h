//
//  MessageTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end
