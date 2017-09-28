//
//  NewsTableViewCell.h
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-22.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
