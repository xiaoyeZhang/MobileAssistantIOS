//
//  ImagesBrowserViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "ImagesBrowserViewController.h"
#import "ImageCollectionViewCell.h"

static NSString *cellIdentifier = @"ImageCollectionViewCell";

@interface ImagesBrowserViewController ()
{
    NSMutableArray *imagesMuArr;
}
@end

@implementation ImagesBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"合同";
    
    [self select_logmodel:NSStringFromClass([self class])];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_collectionView registerClass:[ImageCollectionViewCell class]
        forCellWithReuseIdentifier:cellIdentifier];
    
    imagesMuArr = [[NSMutableArray alloc] initWithArray:self.imagesNameArray];
    
    [imagesMuArr removeObject:@""];
}

#pragma mark -

- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if([[self.imagesNameArray lastObject] isEqualToString:@""])
//    {
//         return [self.imagesNameArray count] - 1;
//    }else{
//         return [self.imagesNameArray count];
//    }
//    
    return [imagesMuArr count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *imageUrl;
    
    if ([_type isEqualToString:@"1"]) {
        
        imageUrl = [NSString stringWithFormat:@"%@%@",TERMINAL_PHOTO_URL,imagesMuArr[indexPath.row]];
    }else{
        
        imageUrl = [NSString stringWithFormat:@"%@%@.jpg",TERMINAL_PHOTO_URL,imagesMuArr[indexPath.row]];
    }
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
