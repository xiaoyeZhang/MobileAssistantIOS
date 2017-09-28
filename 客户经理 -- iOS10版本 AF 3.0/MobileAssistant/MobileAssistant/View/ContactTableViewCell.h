//
//  ContactTableViewCell.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-13.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelSubName;;

@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end
