//
//  Business_Add_Group_DirectoruyViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/28.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "CompEntity.h"

@interface Business_Add_Group_DirectoruyViewController : XYTableBaseViewController

@property (strong, nonatomic) CompEntity *entity;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (strong, nonatomic) NSString *BillId;
@end
