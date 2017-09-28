//
//  MainTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/5.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ColorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
