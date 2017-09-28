//
//  Marking_listTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/18.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Marking_listTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@end
