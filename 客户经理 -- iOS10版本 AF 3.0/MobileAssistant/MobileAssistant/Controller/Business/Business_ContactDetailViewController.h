//
//  Business_ContactDetailViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/14.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupContact.h"
#import "CompEntity.h"

@interface Business_ContactDetailViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_tableView;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (strong, nonatomic) GroupContact *entity;
@property (strong, nonatomic) CompEntity *CompEntity;

@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *MemberCustId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *job;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *kind;
@property (assign, nonatomic) BOOL changeClick;
@property (assign, nonatomic) BOOL power;
@end
