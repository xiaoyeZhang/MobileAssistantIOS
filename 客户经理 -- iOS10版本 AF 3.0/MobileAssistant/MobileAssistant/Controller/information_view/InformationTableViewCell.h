//
//  InformationTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/10.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
