//
//  ActionViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ActionViewController.h"
#import "DXAlertView.h"
#import "UserEntity.h"
#import "Utilies.h"
#import "SCNavigationController.h"
#import "PictureEntity.h"
#import "UploadPictureService.h"
#import "CommonService.h"
#import "MBProgressHUD.h"
#import "PKImagePickerViewController.h"
#import "AppDelegate.h"
#import "LocationEntity.h"
#import "Utilies.h"
#import "MALocationEntity.h"

@interface ActionViewController ()<SCNavigationControllerDelegate, MBProgressHUDDelegate, PKImagePickerViewControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    MBProgressHUD *HUD;
    bool getlocationSuccess;
    SCNavigationController *nav;
    BOOL bSaveImageLocal;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    NSString *locaLatitude;
    NSString *locaLongitude;
    NSString *address;
}
@property (nonatomic, strong) NSMutableArray *arrayAddress;
@property (nonatomic, strong) PKImagePickerViewController *imagePicker;
@property (nonatomic, strong) LocationEntity *mLocationEntity;
@end

@implementation ActionViewController

@synthesize imageView, visiteTask, imageName;
@synthesize imageUpload;
@synthesize labelTag;
@synthesize arrayAddress;
@synthesize mLocationEntity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    address = @"";
    locaLongitude = @"";
    locaLatitude = @"";
    
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"签到";
    [self select_logmodel:NSStringFromClass([self class])];
    
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //bgImageView.backgroundColor = GrayBackgroundColor;
    bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImageView];
    
    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(uploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"上传" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
    arrayAddress = [[NSMutableArray alloc] init];
    //    mLocationEntity = [[LocationEntity alloc] init];
    
    self.imagePicker = [[PKImagePickerViewController alloc]init];
    self.imagePicker.delegate = self;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    getlocationSuccess = YES;

    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    locaLatitude = [locationDefaults objectForKey:@"locaLatitude"];
    locaLongitude = [locationDefaults objectForKey:@"locaLongitude"];
    address = [locationDefaults objectForKey:@"address"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ActionViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ActionViewController"];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhoto:(id)sender
{
    
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否立即上传？" leftButtonTitle:@"取消" rightButtonTitle:@"立即上传" TextAlignment:1 FontSize:15.0f];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
        //        [self saveImage:self.imageView.image];
        //        bSaveImageLocal = YES;
        //
        //        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        HUD.delegate = self;
        //        HUD.labelText = @"努力加载中...";
        //        [self checkVisite];
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
      
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"获取经纬度失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            
    
        //上传照片
        bSaveImageLocal = NO;
        [self uploadImage:self.imageView.image];
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    NSLog(@"right button clicked");
   
    //上传照片
    //[self uploadImage:self.imageView.image];
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

- (void)uploadImage:(UIImage *)image
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    imageUpload = image;
    HUD.labelText = @"努力加载中...";
    [self checkVisite];
    //[HUD showWhileExecuting:@selector(checkVisite) onTarget:self withObject:nil animated:YES];
}

- (void)checkVisite
{
    //{{
    CommonService *service = [[CommonService alloc] init];
    NSString *lat = locaLatitude;
    NSString *lng = locaLongitude;
    
    if (lat.length > 0) {
        
    }else{
        [HUD hide:YES];
        NSString* str=[NSString stringWithFormat:@"请退出客户经理，在【设置>隐私>定位服务>客户经理>使用应用程序期间】授权访问当前位置"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    

    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.visiteTask.visit_id, @"visitId",
                           lat?lat:locaLatitude, @"lat",
                           lng?lng:locaLongitude, @"long",
                           [MALocationEntity sharedInstance].name?[MALocationEntity sharedInstance].name:address, @"bdadd",
                           @"1", @"state",
                           [Utilies GetNowDateTime], @"starttime",
                           self.imageName, @"path",
                           @"sign", @"method", nil];

    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState= [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            if (bSaveImageLocal == NO) {
                UploadPictureService *service2 = [[UploadPictureService alloc] init];
                BOOL flg = [service2 uploadPicture:self.visiteTask.visit_id ImageFileName:self.imageName Image:UIImageJPEGRepresentation(imageUpload,0.5)];
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
        entity.state = self.visiteTask.visit_id;
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


#pragma mark "Take Photo Delegate"

//完成拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *strTime = [NSString stringWithFormat:@"时间: %@", [Utilies GetNowDateTime]];
    
    NSString *strAddress = [NSString stringWithFormat:@"地点: %@",[MALocationEntity sharedInstance].name];
    image = [Utilies imageAddText:image
                        textArray:[NSArray arrayWithObjects:strTime,
                                   strAddress,
                                   [MALocationEntity sharedInstance].lont,
                                   [MALocationEntity sharedInstance].lat, nil]];
    
    self.imageName = [NSString stringWithFormat:@"img_%@",[Utilies NSDateToNSString:[NSDate date]]];
    
    [self.imageView setImage:image];
}


//用户取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationUpdated
{
    self.imagePicker = [[PKImagePickerViewController alloc]init];
    self.imagePicker.delegate = self;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    getlocationSuccess = YES;
    
}

- (void)locationUpdatedFailed:(int)errorCode ErrorMessage:(NSString *)message
{
    getlocationSuccess = NO;
}

- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
{
    if (isShowNavigationBar) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 7.0f) {
            return self.view.frame.size.height - 64.0f;
        }
        else
            return self.view.frame.size.height - 44.0;
    }
    else {
        return self.view.frame.size.height;
    }
}

//
- (void)dealloc {
    [self configureNotification:NO];
}

- (void)configureNotification:(BOOL)toAdd {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationTakePicture object:nil];
    if (toAdd) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callbackNotificationForFilter:) name:kNotificationTakePicture object:nil];
    }
}

- (void)callbackNotificationForFilter:(NSNotification*)noti {
    UIViewController *cameraCon = noti.object;
    if (!cameraCon) {
        return;
    }
    UIImage *finalImage = [noti.userInfo objectForKey:kImage];
    if (!finalImage) {
        return;
    }
    
}

#pragma mark - SCNavigationController delegate
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {

    NSString *strTime = [NSString stringWithFormat:@"时间: %@", [Utilies GetNowDateTime]];
    NSString *strAddress = [NSString stringWithFormat:@"地点: %@",[MALocationEntity sharedInstance].name];
    
    NSString *strLon = [NSString stringWithFormat:@"经度: %@",[MALocationEntity sharedInstance].lont];
    NSString *strLat = [NSString stringWithFormat:@"纬度: %@",[MALocationEntity sharedInstance].lat];
    
    image = [Utilies imageAddText:image
                        textArray:[NSArray arrayWithObjects:strTime,strAddress,
                                   [NSString stringWithFormat:@"经度: %@",[MALocationEntity sharedInstance].lont],
                                   [NSString stringWithFormat:@"纬度: %@",[MALocationEntity sharedInstance].lat],
                                   nil]];
    
    [self.imageView setImage:image];
    
    [nav dismissModalViewControllerAnimated:YES];
}

-(void)imageSelected:(UIImage*)img
{
    NSString *strTime = [NSString stringWithFormat:@"时间: %@", [Utilies GetNowDateTime]];
    NSString *strAddress;
    NSString *strLon;
    NSString *strLat;
    if ([MALocationEntity sharedInstance].name.length > 0) {
        
        strAddress = [NSString stringWithFormat:@"地点: %@",[MALocationEntity sharedInstance].name];
        strLon = [NSString stringWithFormat:@"经度: %@",[MALocationEntity sharedInstance].lont];
        strLat = [NSString stringWithFormat:@"纬度: %@",[MALocationEntity sharedInstance].lat];
        
    }else{
        
        strAddress = [NSString stringWithFormat:@"地点: %@",address];
        strLon = [NSString stringWithFormat:@"经度: %@",locaLongitude];
        strLat = [NSString stringWithFormat:@"纬度: %@",locaLatitude];
        
    }
    
    NSString *strContent = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@", strTime , strLon, strLat,strAddress ];
    labelTag.text = strContent;

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        
    }
    if (0==buttonIndex) {
        AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self.navigationController popToViewController:appDelegate.taskListVC animated:YES];
        NSLog(@"点击了确认按钮");
    }
}


@end



