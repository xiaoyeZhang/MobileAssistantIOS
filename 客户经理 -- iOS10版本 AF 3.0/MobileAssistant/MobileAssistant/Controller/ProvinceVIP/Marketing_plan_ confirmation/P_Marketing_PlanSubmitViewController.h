//
//  P_Marketing_PlanSubmitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/5.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYTableBaseViewController.h"
#import "BusinessListModel.h"

@interface P_Marketing_PlanSubmitViewController : XYTableBaseViewController

@property(nonatomic, strong) NSDictionary *detailDict; //被驳回时重新提交内容
@property(nonatomic, strong) BusinessListModel *bListModel;

@property (strong, nonatomic) NSString *typeNum;
///图片上传
@property(nonatomic ,strong) NSArray *uploadImagesArr;

@end
