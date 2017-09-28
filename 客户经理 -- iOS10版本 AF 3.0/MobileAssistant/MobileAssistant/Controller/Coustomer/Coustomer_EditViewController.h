//
//  Coustomer_EditViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/1/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactEntity.h"
#import "CompEntity.h"
@interface Coustomer_EditViewController : XYBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ContactEntity * entity;
@property (nonatomic, strong) CompEntity *compEntity;

///成员种类
@property(nonatomic, copy) NSString *kind;
//成员类型
@property(nonatomic, copy) NSString *type;
///成员类别
@property(nonatomic, copy) NSString *MemberLevel;
///姓名
@property(nonatomic, copy) NSString *name;
///工号
@property(nonatomic, copy) NSString *num;
///职务
@property(nonatomic, copy) NSString *job;
///电话
@property(nonatomic, copy) NSString *tel;
///是否添加成员
@property(nonatomic, copy) NSString *IsAddMember;

@end
