//
//  P_BillSubmitViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "BusinessListModel.h"
#import "P_AddPhotoViewController.h"

@interface P_BillSubmitViewController : XYTableBaseViewController<AddPhotoViewControllerDelegate>

@property(nonatomic, strong) NSDictionary *detailDict;
@property(nonatomic, strong) BusinessListModel *bListModel;

@property(nonatomic ,strong) NSArray *uploadImagesArr;

@property (copy, nonatomic) NSString *typeNum;
@end
