//
//  P_TerminalSubmitViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "BusinessListModel.h"
#import "CustomerViewController.h"
#import "XYDatePicker.h"
#import "ThreeLabelsTableViewCell.h"
#import "P_AddDevicesViewController.h"
#import "P_AddPhotoViewController.h"

@interface P_TerminalSubmitViewController : XYTableBaseViewController<UITableViewDataSource,
                                                                    UITableViewDelegate,UITextFieldDelegate,
                                                                    CustomerViewControllerDelegate,
                                                                    XYDatePickerDelegate,
                                                                    AddDevicesViewControllerDelegate,
                                                                    AddPhotoViewControllerDelegate>
///集团名称
@property(nonatomic, copy) NSString *company;

///集团编号
@property(nonatomic, copy) NSString *company_num;

///订货类型
@property(nonatomic, copy) NSString *order_type;

///到货时间
@property(nonatomic, copy) NSString *order_time;

///机型
@property(nonatomic, copy) NSString *order_info;

///客户姓名
@property(nonatomic, copy) NSString *client_name;

///电话
@property(nonatomic, copy) NSString *phone_num;

///备注
@property(nonatomic, copy) NSString *remarks;

@property(nonatomic ,strong) NSArray *uploadImagesArr;
//保底金额
@property (nonatomic, strong) NSString *minimum_guarantee_amount;
/////
//@property(nonatomic, copy) NSArray *imagesNameArr;

@property(nonatomic, strong) NSDictionary *detailDict;
@property(nonatomic, strong) BusinessListModel *bListModel;

@property(nonatomic, assign) BOOL isFromTerminalStock;

- (void)getInfoFromDetaiDict;

@end
