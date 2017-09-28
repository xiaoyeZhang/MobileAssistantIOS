//
//  MainBaseViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainBaseViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)NSString *name;
@end
