//
//  P_AddPhotoViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"

@class P_AddPhotoViewController;
@protocol AddPhotoViewControllerDelegate <NSObject>

@optional
- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr;

@end

@interface P_AddPhotoViewController : XYBaseViewController<UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *_collectionView;
    
}

@property(nonatomic, weak) id<AddPhotoViewControllerDelegate> delegate;
@property(nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, copy) NSString *VC_Type;
@end
