//
//  P_AddPhotoViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/18.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_AddPhotoViewController.h"
#import "PhotosCollectionViewCell.h"
#import "ImagesBrowserViewController.h"

static NSString *imageCellIdentifier = @"PhotosCollectionViewCell";

@interface P_AddPhotoViewController ()<UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate>
{
    NSMutableArray *imagesMuArr;
    NSMutableArray *imagesNameArr;
}

@end

@implementation P_AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"上传资料";
    
    imagesNameArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imagesMuArr = [[NSMutableArray alloc] initWithArray:self.imagesArr];
    
    UINib *nib = [UINib nibWithNibName:imageCellIdentifier bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:imageCellIdentifier];
    
    
    imagesMuArr = [[NSMutableArray alloc] initWithArray:self.imagesArr];

    [imagesMuArr removeObject:@""];

}

#pragma mark -

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
- (void)submitBtnClicked:(id)sender
{
    if ([self.VC_Type isEqualToString:@"订单需求发起"] || [self.VC_Type isEqualToString:@"新订单需求发起"]) {
        
    }else{
        if (imagesMuArr.count == 0) {
            ALERT_ERR_MSG(@"请上传合同资料");
            
            return;
        }
    }

    if ([self.delegate respondsToSelector:@selector(addPhotoViewController:didSelectImages:)]) {
        
        for (int i = 0;i < imagesMuArr.count; i ++) {
            if (![imagesMuArr[i] isKindOfClass:[UIImage class]]) {
                
                NSString *imageUrl;
                
                if ([self.VC_Type isEqualToString:@"新订单需求发起"]) {
                
                    imageUrl = [NSString stringWithFormat:@"%@%@",TERMINAL_PHOTO_URL,imagesMuArr[i]];
                    
                }else{
                    imageUrl = [NSString stringWithFormat:@"%@%@.jpg",TERMINAL_PHOTO_URL,imagesMuArr[i]];
                }
                UIImageView *image = [[UIImageView alloc]init];
                [image setImageWithURL:[NSURL URLWithString:imageUrl]];
                [imagesMuArr replaceObjectAtIndex:i withObject:image.image];
            }
        }
        [self.delegate addPhotoViewController:self didSelectImages:imagesMuArr];
    }
    [self backBtnClicked:nil];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [imagesMuArr count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    
    id image = imagesMuArr[indexPath.row];
    if ([image isKindOfClass:[UIImage class]]){
        cell.imageView.image = imagesMuArr[indexPath.row];
    }else if ([image isKindOfClass:[NSString class]]){
        
        NSString *imageUrl;
        if ([self.VC_Type isEqualToString:@"新订单需求发起"]) {
            
            imageUrl = [NSString stringWithFormat:@"%@%@",TERMINAL_PHOTO_URL,image];
            
        }else{
            
            imageUrl = [NSString stringWithFormat:@"%@%@.jpg",TERMINAL_PHOTO_URL,image];
        
        }

        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
        
    }
    
    cell.deleteBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((collectionView.bounds.size.width-30)/2,\
                             (collectionView.bounds.size.width-30)/2);
    
    return size;
}

#pragma mark - UIButtonMethod

- (void)deleteBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isMemberOfClass:[UIButton class]]) {
        
        [imagesMuArr removeObjectAtIndex:btn.tag];
//        [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:btn.tag inSection:0]]];

        [_collectionView reloadData];
    }
}

- (IBAction)takePhotoBtnClicked:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;   // 设置委托
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    }
    
}

- (IBAction)getPhotoFromLibrary:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //判断是否有图库
    if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;   // 设置委托
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    }
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [imagesMuArr addObject:image];
    
    [_collectionView reloadData];
//    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:imagesMuArr.count-1 inSection:0]]];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
