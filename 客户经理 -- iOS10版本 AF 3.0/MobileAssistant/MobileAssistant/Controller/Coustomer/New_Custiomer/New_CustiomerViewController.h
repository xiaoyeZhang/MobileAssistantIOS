//
//  New_CustiomerViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/9/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface New_CustiomerViewController : UIViewController

@property (nonatomic, strong) MainViewController *mainVC;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end
