//
//  P_BusinessDetailBaseViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/6.
//  Copyright (c) 2015年 ;. All rights reserved.
//

#import "XYBaseViewController.h"
#import "CommonService.h"
#import "BusinessDetailModel.h"
#import "BusinessProcessModel.h"
#import "BusinessListModel.h"
#import "MJExtension.h"
#import "TwoLablesTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "ThreeLabelsTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "ThreeCheckBoxTableViewCell.h"
#import "BtnTableViewCell.h"
#import "StringHelper.h"
#import "P_UserListViewController.h"
#import "UserEntity.h"
#import "UIAlertView+Blocks.h"
#import "XYDatePicker.h"
#import "P_AddDevicesViewController.h"

@interface P_BusinessDetailBaseViewController : XYBaseViewController<UITableViewDataSource,
                                                                     UITableViewDelegate,
                                                                     CheckBoxTableViewCellDelegate,
                                                                     UITextFieldDelegate,
                                                                     UserListViewControllerDelegate,
                                                                     XYDatePickerDelegate,
                                                                     AddDevicesViewControllerDelegate,
ThreeCheckBoxTableViewCellDelegate>
{    
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *processMuArr;
    
    NSMutableArray *detailMuArr;
}

@property(nonatomic, strong) NSDictionary *detailDict;

@property(nonatomic, strong) BusinessListModel *bListModel; //进入时需赋值
@property(nonatomic, assign) BOOL isShowSubmitBtn;

@property(nonatomic, assign) BOOL isCheckBoxUnPass; //不通过情况

@property(nonatomic, assign) NSString *CheckBoxFile;//归档情况

@property(nonatomic, copy) NSString *specialConfigStr; //处理通用人员

///审核状态
@property(nonatomic, assign) int submitState;

///处理意见
@property(nonatomic, copy) NSString *submitDesc;

///下一个处理人员ID
@property(nonatomic, copy) NSString *next_processor_id;

///选中的用户
@property(nonatomic, strong) UserListModel *selectedUserModel;

//返回
- (void)backBtnClicked:(id)sender;

//添加提交按钮
- (void)addSubmitBtn;

//添加提交按钮（可配置标题）
- (void)addSubmitBtnWithTitle:(NSString *)title;

//添加提交按钮（可配置标题、选择方法）
- (void)addSubmitBtnWithTitle:(NSString *)title action:(SEL)action;

//添加编辑按钮
- (void)addEditBtn;


//提交
- (void)submitBtnClicked:(id)sender;

//编辑
- (void)editBtnClicked:(id)sender;

//带按钮cell按钮点击事件
- (void)btnTableViewCellBtnClicked:(id)sender;


//初始化表格数据
- (void)initData;

//数据加载完成后调用
- (void)reloadSubmitData;


@end
