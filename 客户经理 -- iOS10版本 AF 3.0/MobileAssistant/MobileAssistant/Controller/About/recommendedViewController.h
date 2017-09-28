//
//  recommendedViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/29.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recommendedViewController : XYBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSString *tel;

@end
