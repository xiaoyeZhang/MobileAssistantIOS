//
//  New_Contacts_MessageViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/10/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactEntity.h"

@interface New_Contacts_MessageViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) ContactEntity *entity;

@property (copy,nonatomic) NSString *company_num;
@end
