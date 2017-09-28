//
//  ImagesBrowserViewController.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UIImageView+WebCache.h"

//#define TERMINAL_PHOTO_URL @"http://cmm.avatek.com.cn/gzcms/terminal_photo/" //合同图片地址

@interface ImagesBrowserViewController : XYBaseViewController<UICollectionViewDataSource,
                                                              UICollectionViewDelegate,
                                                              UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *_collectionView;
}

@property(nonatomic, strong) NSArray *imagesNameArray;

@property (strong, nonatomic) NSString *type;
@end
