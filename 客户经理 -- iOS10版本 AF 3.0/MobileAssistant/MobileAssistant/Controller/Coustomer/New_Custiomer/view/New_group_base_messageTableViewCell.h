//
//  New_group_base_messageTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/10.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface New_group_base_messageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *GroupNum;
@property (weak, nonatomic) IBOutlet UILabel *GroupState;
@property (weak, nonatomic) IBOutlet UILabel *GroupAddress;
@property (weak, nonatomic) IBOutlet UILabel *GroupType;
@property (weak, nonatomic) IBOutlet UILabel *Cooperation_situation;//合作情况
@property (weak, nonatomic) IBOutlet UILabel *Cooperation_difficulties;//合作困难
@end
