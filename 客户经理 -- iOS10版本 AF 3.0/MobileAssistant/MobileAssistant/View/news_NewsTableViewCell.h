//
//  news_NewsTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/19.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface news_NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *Release_DepartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Icon_State;
@end
