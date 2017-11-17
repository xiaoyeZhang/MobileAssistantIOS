//
//  Arrears_taskTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Arrears_taskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *company_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *acc_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end
