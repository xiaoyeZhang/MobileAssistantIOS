//
//  UserTableCellHeaderView.h
//  MobileAssistant
//
//  Created by xy on 15/10/15.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableCellHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *down_rightImage;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
