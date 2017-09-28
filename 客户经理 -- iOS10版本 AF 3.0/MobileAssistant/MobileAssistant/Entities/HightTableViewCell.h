//
//  HightTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/28.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end
