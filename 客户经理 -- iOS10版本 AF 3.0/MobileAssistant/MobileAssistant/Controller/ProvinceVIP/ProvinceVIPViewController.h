//
//  ProvinceVIPViewController.h
//  MobileAssistant
//
//  Created by xy on 15/9/29.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceVIPViewController : XYBaseViewController<UICollectionViewDataSource,
                                                        UICollectionViewDelegate,
                                                        UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *_collectionView;
    
}
@property (strong, nonatomic) UIButton *APPointBut;
@property (strong, nonatomic) UIButton *CardBut;
@property (strong, nonatomic) UIButton *BillBut;
@property (strong, nonatomic) UIButton *MarketingPlanBut;
@property (assign, nonatomic) BOOL isClick;
@end
