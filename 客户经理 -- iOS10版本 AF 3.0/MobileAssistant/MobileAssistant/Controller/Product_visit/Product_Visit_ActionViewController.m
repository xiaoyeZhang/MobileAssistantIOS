//
//  Product_Visit_ActionViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_Visit_ActionViewController.h"
#import "PKImagePickerViewController.h"
#import "Utilies.h"
#import "PictureEntity.h"
#import "UploadPictureService.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"
#import "Product_VisitListViewController.h"

@interface Product_Visit_ActionViewController ()<PKImagePickerViewControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    BOOL bSaveImageLocal;
    NSString *locaLatitude;
    NSString *locaLongitude;
    NSString *address;
}
@property (nonatomic, strong) PKImagePickerViewController *imagePicker;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *imageUpload;
@end

@implementation Product_Visit_ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签到";

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"上传"];
    [submitBtn addTarget:self action:@selector(uploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imagePicker = [[PKImagePickerViewController alloc]init];
    self.imagePicker.delegate = self;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
    
    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    locaLatitude = [locationDefaults objectForKey:@"locaLatitude"];
    locaLongitude = [locationDefaults objectForKey:@"locaLongitude"];
    address = [locationDefaults objectForKey:@"address"];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openCamera
{
    //    nav = [[SCNavigationController alloc] init];
    //    nav.scNaigationDelegate = self;
    //    [nav showCameraWithParentController:self];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

//完成拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:image];
}
//将照片保存到disk上
- (void)saveImage:(UIImage *)image
{
    NSString *fileName;
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if(imageData == nil)
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
        fileName = [self.imageName stringByAppendingPathExtension:@"jpg"];
    }
    else
    {
        fileName = [self.imageName stringByAppendingPathExtension:@"png"];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[Utilies getCheckInImagePath],fileName];
    
    NSError *err;
    [imageData writeToFile:filePath options:1.0 error:&err];
    
    if (!err) {
        
        PictureEntity *entity = [[PictureEntity alloc] init];
        entity.pictureID = [Utilies GetUUID];
        entity.pictureName = self.imageName;
        entity.picturePath = filePath;
        entity.state = self.entity.visit_id;
        UploadPictureService *service = [[UploadPictureService alloc] init];
        [service addPictureToDB:entity];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"签到图片保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 1001;
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"签到图片保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //alert.tag = 1001;
        [alert show];
    }
}

//用户取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageSelected:(UIImage*)img
{
    NSString *strTime = [NSString stringWithFormat:@"时间: %@", [Utilies GetNowDateTime]];
    NSString *strAddress;
    NSString *strLon;
    NSString *strLat;
    
    strAddress = [NSString stringWithFormat:@"地点: %@",address];
    strLon = [NSString stringWithFormat:@"经度: %@",locaLongitude];
    strLat = [NSString stringWithFormat:@"纬度: %@",locaLatitude];

    NSString *strContent = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@", strTime , strLon, strLat,strAddress ];
    self.labelTag.text = strContent;
    
    self.imageName = [NSString stringWithFormat:@"img_%@",[Utilies NSDateToNSString:[NSDate date]]];
    
    NSData *imageData = UIImageJPEGRepresentation(img,0.5);
    
    UIImage* pressImage = [UIImage imageWithData:imageData];
    UIImage* scaleImage = [Utilies scaleFromImage: pressImage toSize:CGSizeMake(480, 640)];
    [self.imageView setImage:scaleImage];
}

-(void)imageSelectionCancelled
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhoto:(id)sender
{
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否立即上传？" leftButtonTitle:@"取消" rightButtonTitle:@"立即上传" TextAlignment:1 FontSize:15.0f];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
        
    };
    alert.rightBlock = ^() {
        
        //上传照片
        bSaveImageLocal = NO;
        [self uploadImage:self.imageView.image];
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };


}

- (void)uploadImage:(UIImage *)image
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    _imageUpload = image;
    HUD.labelText = @"努力加载中...";
    [self checkVisite];
    //[HUD showWhileExecuting:@selector(checkVisite) onTarget:self withObject:nil animated:YES];
}

- (void)checkVisite
{
    //{{
    CommonService *service = [[CommonService alloc] init];
    
    if (locaLatitude.length > 0) {
        
    }else{
        [HUD hide:YES];
        NSString* str=[NSString stringWithFormat:@"请退出客户经理，在【设置>隐私>定位服务>客户经理>使用应用程序期间】授权访问当前位置"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.entity.visit_id, @"visit_id",
                           locaLatitude, @"lat",
                           locaLongitude, @"lont",
                           address, @"address",
                           self.imageName, @"images",
                           @"product_visit_exec_task", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state intValue] > 0) {
            
            if (bSaveImageLocal == NO) {
                UploadPictureService *service2 = [[UploadPictureService alloc] init];
                
                BOOL flg = [service2 uploadPicture:self.entity.visit_id ImageFileName:self.imageName Image:UIImageJPEGRepresentation(_imageUpload,0.5)];
                
                if (flg) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"签到图片上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alert.tag = 1002;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"签到图片上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    //alert.tag = 1001;
                    [alert show];
                }
            } else {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"签到成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } else {
            //NSString *reason = [entity valueForKeyPath:@"reason"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"签到失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0==buttonIndex) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
        
        Product_VisitListViewController *vc = [[Product_VisitListViewController alloc]init];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[vc class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
