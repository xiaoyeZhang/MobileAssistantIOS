//
//  small_piece_paperSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/13.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "small_piece_paperSubmitViewController.h"
#import "MBProgressHUD.h"
#import "XYDatePicker.h"
#import "No_visit_listViewController.h"
#import "AFNetworking.h"

@interface small_piece_paperSubmitViewController ()<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate,XYDatePickerDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userInfo;
    NSString *cusName;
    NSMutableArray *CusArr;
}
@end

@implementation small_piece_paperSubmitViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"派发小纸条";
    
    userInfo = [UserEntity sharedInstance];
    
    CusArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [self setNaviRightBtnWithTitle:@"派发"];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
    
    self.textView.layer.masksToBounds = YES;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    
    if (width == 480.0) {
        [scrollView setContentSize: CGSizeMake(320, 860)];
    } else {
        [scrollView setContentSize: CGSizeMake(320, 600)];
    }
    
    [self.imageBtn addTarget:self action:@selector(updownImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"small_piece_paperSubmitViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"small_piece_paperSubmitViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    
}

- (void)updownImage:(UIButton *)sender{
    
    P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
    vc.imagesArr = self.uploadImagesArr;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.user_nameTextFile) {
        
        [self.user_nameTextFile resignFirstResponder];
        
        No_visit_listViewController *vc = [[No_visit_listViewController alloc]init];
        
        vc.tcVC = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (textField == self.end_timeTextFile) {
        
        [self changeDate];
        
        [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)changeDate{
    
    [self.end_timeTextFile resignFirstResponder];
    //预约时间
    XYDatePicker *datePicker = [XYDatePicker datePicker];
    datePicker.delegate = self;
    datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker show];
    
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.end_timeTextFile.text = dateStr;
    
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
   self.uploadImagesArr = imagesArr;

}

-(void)setCustomer:(NSMutableArray *)ex{
    
    CusArr = ex;
    
    cusName = [[NSString alloc]init];
    
    for (No_visit_listEntity *entity in CusArr) {
        
        NSString *string = [NSString stringWithFormat:@"%@",entity.name];
        
        cusName = [cusName stringByAppendingFormat:@"%@;",string];

    }
    cusName = [cusName substringToIndex:cusName.length-1];
    
    self.user_nameTextFile.text = cusName;
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClicked:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    static BOOL isDone = YES;
    NSLog(@"%hhd",isDone);
    if (!isDone) {
        return;
    }
    
    if (self.titleTextFile.text.length == 0) {
        
        ALERT_ERR_MSG(@"主题不能为空！");
        isDone = YES;
        return;
    }
    
    if (self.textView.text.length == 0) {
        
        ALERT_ERR_MSG(@"内容不能为空！");
        isDone = YES;
        return;
    }
    
    if (self.user_nameTextFile.text.length == 0) {
        ALERT_ERR_MSG(@"请选择客户经理！");
        isDone = YES;
        return;
    }
    NSString *cus_id = [[NSString alloc]init];
    
    for (No_visit_listEntity *entity in CusArr) {
        
        NSString * string= [NSString stringWithFormat:@"%@",entity.user_id];
        
        cus_id = [cus_id stringByAppendingFormat:@"%@;",string];
        
    }
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";

    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userInfo.user_id, @"create_id",
                           
                           cus_id, @"user_ids",
                           
                           self.titleTextFile.text, @"title",
                           
                           self.textView.text, @"content",
                           
                           self.end_timeTextFile.text?self.end_timeTextFile.text:@"", @"end_time",
                           
                           @"tape_add", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
            
        } else {
            
            NSString *tape_id = [entity objectForKey:@"content"];
            
            if (self.uploadImagesArr.count != 0) {
                 [self uploadImagesWithIndex:0 withBusinessId:tape_id];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        isDone = YES;
    }];
    
}

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)tape_id
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[NSUUID UUID] UUIDString]];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);
    
    NSDictionary *dict = @{@"method":@"common_upload",
                           @"tape_id":tape_id,
                           @"picname":imageName,
                           @"upload_type":@"tape",
                           @"file":imageData
                           };

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    
    [manager POST:BASEURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(self.uploadImagesArr[index],0.5);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",imageName] mimeType:@"image/jpg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[obj objectForKey:@"state"] intValue]== 1) {
            if (index < self.uploadImagesArr.count-1) {
                
                [self uploadImagesWithIndex:index+1 withBusinessId:tape_id];
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
//            ALERT_ERR_MSG(@"上传图片失败");
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
