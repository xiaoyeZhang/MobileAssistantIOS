//
//  Marketing_CenterListTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/13.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Marketing_CenterListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIButton *reBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *ComentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *supportImage;
@property (weak, nonatomic) IBOutlet UIView *supportView;
@property (weak, nonatomic) IBOutlet UIImageView *reImage;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@end
