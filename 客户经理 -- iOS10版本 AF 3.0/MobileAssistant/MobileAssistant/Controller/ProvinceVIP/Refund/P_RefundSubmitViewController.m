//
//  P_RefundSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_RefundSubmitViewController.h"
#import "XYDatePicker.h"
#import "P_AddPhotoViewController.h"
#import "AFNetworking.h"
#import "P_RefundViewController.h"

@interface P_RefundSubmitViewController ()<XYDatePickerDelegate,AddPhotoViewControllerDelegate,UITextFieldDelegate>


///时间
@property(nonatomic, copy) NSString *refund_time;

///客户名称
@property(nonatomic, copy) NSString *customer_name;

///金额
@property(nonatomic, copy) NSString *bill_amount;

///退款原因
@property(nonatomic, copy) NSString *Refund_reason;

///备注
@property(nonatomic, copy) NSString *remaks;

@property(nonatomic, copy) NSString *type_id;

@property (copy, nonatomic) NSString *business_id;
@end

@implementation P_RefundSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退款流程";
    
    self.type_id = @"20";
    
    if (self.detailDict) {
        self.refund_time = self.detailDict[@"refund_time"];
        self.customer_name = self.detailDict[@"customer_name"];
        self.bill_amount = self.detailDict[@"refund_amount"];
        self.Refund_reason = self.detailDict[@"refund_reason"];
        self.remaks = self.detailDict[@"refund_remarks"];
        self.business_id = self.bListModel.business_id;
    }

    
}

//提交
- (void)submitBtnClicked:(id)sender
{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    if(self.refund_time.length == 0){
        msg = @"请选择时间";
    }else if (self.customer_name.length == 0){
        msg = @"请填写客户名称";
    }else if (self.bill_amount.length == 0){
        msg = @"请填写金额";
    }else if (self.Refund_reason.length == 0){
        msg = @"请填写退款原因";
    }else if (self.remaks.length == 0){
        msg = @"请填写备注";
    }else if(self.uploadImagesArr.count == 0){
        msg = @"请上传合同资料";
    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    
    [dict setObject:userInfo.user_id forKey:@"create_id"];
    
    [dict setObject:self.type_id forKey:@"type_id"];
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@",self.customer_name,self.bill_amount] forKey:@"title"];
    
    [dict setObject:self.refund_time forKey:@"refund_time"];
    
    [dict setObject:self.customer_name forKey:@"customer_name"];
    
    [dict setObject:self.bill_amount forKey:@"refund_amount"];
    
    [dict setObject:self.Refund_reason forKey:@"refund_reason"];
    
    [dict setObject:self.remaks forKey:@"refund_remarks"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    NSDictionary *dict = @{@"method":!self.detailDict?@"submit_business":@"update_business",
//                           @"create_id":userInfo.user_id,
//                           @"title":[NSString stringWithFormat:@"%@,%@",self.customer_name,self.bill_amount],
//                           @"type_id":self.type_id,
//                           @"refund_time":self.refund_time,
//                           @"customer_name":self.customer_name,
//                           @"refund_amount":self.bill_amount,
//                           @"refund_reason":self.Refund_reason,
//                           @"refund_remarks":self.remaks,
//                           @"business_id":self.bListModel?self.bListModel.business_id:@"",
//                           };
    
    [self get_three_list:[dict objectForKey:@"type_id"] Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:dict];
        }else{
            
            [self goSumbitData:dict];
        }
        isDone = YES;
    }];
    
//    CommonService *service = [[CommonService alloc] init];
//    
//    
//    [service getNetWorkData:dict  Successed:^(id entity) {
//        
//        int state = [entity[@"state"] intValue];
//        
//        if (state == 1) {
//            
//            if (self.uploadImagesArr.count != 0) {
//                
//                for (int i = 0; i < [self.uploadImagesArr count]; i++) {
//                    
//                    if ([self.typeNum isEqualToString:@"1"]) {
//                        if ([self.uploadImagesArr[i] isKindOfClass:[UIImage class]]) {
//                            //取出重新上传的图片
//                            [self uploadImagesWithIndex:i withBusinessId:self.business_id];
//                            
//                            break;
//                        }
//                        //没有提交的图片 则显示提交成功
//                        if (i == self.uploadImagesArr.count - 1) {
//                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                                P_RefundViewController *vc = [[P_RefundViewController alloc]init];
//                                for (UIViewController *temp in self.navigationController.viewControllers) {
//                                    if ([temp isKindOfClass:[vc class]]) {
//                                        [self.navigationController popToViewController:temp animated:YES];
//                                    }
//                                    
//                                }
//                                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//                            }];
//                        }
//                        
//                    }else{
//                        [self uploadImagesWithIndex:0 withBusinessId:entity[@"content"]];
//                    }
//                    
//                }
//                
//            }else{
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                    if ([self.typeNum isEqualToString:@"1"]) {
//                        P_RefundViewController *vc = [[P_RefundViewController alloc]init];
//                        for (UIViewController *temp in self.navigationController.viewControllers) {
//                            if ([temp isKindOfClass:[vc class]]) {
//                                [self.navigationController popToViewController:temp animated:YES];
//                            }
//                            
//                        }
//                    }else{
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
//                }];
//                
//            }
//        }else{
//            ALERT_ERR_MSG(@"提交失败");
//        }
//        isDone = YES;
//    } Failed:^(int errorCode, NSString *message) {
//        ALERT_ERR_MSG(message);
//        isDone = YES;
//    }];
}

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)businessId
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%d",businessId,index];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.2f);
    
    NSDictionary *dict = @{@"method":@"terminal_upload",
                           @"business_id":businessId,
                           @"picname":imageName,
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
                [self uploadImagesWithIndex:index+1 withBusinessId:businessId];
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    P_RefundViewController *vc = [[P_RefundViewController alloc]init];
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[vc class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                        
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                P_RefundViewController *vc = [[P_RefundViewController alloc]init];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[vc class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 6;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    
    TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.txtField.tag = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLbl.text = @"时间";
            cell.txtField.text = self.refund_time;
            cell.txtField.placeholder = @"选择时间";
            break;
        }
        case 1:
        {
            cell.titleLbl.text = @"客户名称";
            cell.txtField.text = self.customer_name;
            break;
        }
        case 2:
        {
            cell.titleLbl.text = @"金额";
            cell.txtField.text = self.bill_amount;
            break;
        }
        case 3:
        {
            cell.titleLbl.text = @"退款原因";
            cell.txtField.text = self.Refund_reason;
            break;
        }
        case 4:
        {

            cell.titleLbl.text = @"附件上传";
            cell.txtField.placeholder = @"请上传合同相关资料";
            cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
            
            break;
        }
        case 5:
        {

            cell.titleLbl.text = @"备注";
            cell.txtField.text = self.remaks;

            break;
        }

        default:
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if(textField.tag == 0){
        [self.view endEditing:YES];
        
        //预约时间
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        return NO;
    }else if (textField.tag == 4){
        [self.view endEditing:YES];
        
        P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
        vc.imagesArr = self.uploadImagesArr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            self.customer_name = textField.text;
            break;
        }
        case 2:
        {
            self.bill_amount = textField.text;
            break;
        }
        case 3:
        {
            self.Refund_reason = textField.text;
            break;
        }
        case 5:
        {
            self.remaks = textField.text;
            break;
        }
        default:
            break;
    }
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.refund_time = dateStr;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    
    self.uploadImagesArr = imagesArr;
    [_tableView reloadData];
}

- (void)showSIAlertView:(NSArray *)arr andWithDict:(NSMutableDictionary *)dic{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"下级执行人" andMessage:@""];
    
    for (int i = 0; i < arr.count; i++) {
        
        [alertView addButtonWithTitle:[arr[i] objectForKey:@"name"]
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  NSLog(@"Button1 Clicked:%@",[arr[i] objectForKey:@"name"]);
                                  
                                  [dic setObject:[arr[i] objectForKey:@"user_id"] forKey:@"next_processor"];
                                  
                                  [self goSumbitData:dic];
                              }];
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler", alertView);
        };
        
    }
    [alertView addButtonWithTitle:@"取   消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    [alertView show];
    
}

- (void)goSumbitData:(NSMutableDictionary *)dict{
    
    CommonService *service = [[CommonService alloc] init];
    
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            
            if (self.uploadImagesArr.count != 0) {
                
                for (int i = 0; i < [self.uploadImagesArr count]; i++) {
                    
                    if ([self.typeNum isEqualToString:@"1"]) {
                        if ([self.uploadImagesArr[i] isKindOfClass:[UIImage class]]) {
                            //取出重新上传的图片
                            [self uploadImagesWithIndex:i withBusinessId:self.business_id];
                            
                            break;
                        }
                        //没有提交的图片 则显示提交成功
                        if (i == self.uploadImagesArr.count - 1) {
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                P_RefundViewController *vc = [[P_RefundViewController alloc]init];
                                for (UIViewController *temp in self.navigationController.viewControllers) {
                                    if ([temp isKindOfClass:[vc class]]) {
                                        [self.navigationController popToViewController:temp animated:YES];
                                    }
                                    
                                }
                                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                            }];
                        }
                        
                    }else{
                        [self uploadImagesWithIndex:0 withBusinessId:entity[@"content"]];
                    }
                    
                }
                
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if ([self.typeNum isEqualToString:@"1"]) {
                        P_RefundViewController *vc = [[P_RefundViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
                
            }
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
