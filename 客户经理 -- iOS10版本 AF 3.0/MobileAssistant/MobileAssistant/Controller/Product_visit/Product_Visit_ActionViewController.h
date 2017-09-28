//
//  Product_Visit_ActionViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "Product_VisitListEntity.h"

@interface Product_Visit_ActionViewController : XYBaseViewController

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UILabel *labelTag;

@property (nonatomic, strong) Product_VisitListEntity *entity;

@end
