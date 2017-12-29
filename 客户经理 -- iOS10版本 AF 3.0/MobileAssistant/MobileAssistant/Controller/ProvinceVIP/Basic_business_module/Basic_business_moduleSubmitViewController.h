//
//  Basic_business_moduleSubmitViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "BusinessListModel.h"

@interface Basic_business_moduleSubmitViewController : XYTableBaseViewController

@property(nonatomic, strong) NSDictionary *detailDict; //被驳回时重新提交内容
@property(nonatomic, strong) BusinessListModel *bListModel;

@property (strong, nonatomic) NSString *typeNum;
///图片上传
@property(nonatomic ,strong) NSArray *uploadImagesArr;

@end
