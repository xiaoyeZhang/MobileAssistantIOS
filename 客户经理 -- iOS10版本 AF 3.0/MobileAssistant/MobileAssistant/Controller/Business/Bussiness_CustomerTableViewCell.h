//
//  Bussiness_CustomerTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bussiness_CustomerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CustomerName;
@property (weak, nonatomic) IBOutlet UILabel *CustomerNum;
@property (weak, nonatomic) IBOutlet UILabel *CustomerAddress;

@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@end
