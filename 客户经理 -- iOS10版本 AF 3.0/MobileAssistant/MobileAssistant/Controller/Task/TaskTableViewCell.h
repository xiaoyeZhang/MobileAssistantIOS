//
//  TaskTableViewCell.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-21.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageViewStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelCustomer;
@property (nonatomic, strong) IBOutlet UILabel *labelContact;
@property (nonatomic, strong) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;


@end
