//
//  Basic_business_moduleSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/12/19.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Basic_business_moduleSubmitViewController.h"
#import "CustomerViewController.h"
#import "TxtFieldTableViewCell.h"
#import "CompEntity.h"
#import "UIActionSheet+Block.h"
#import "UIAlertView+Blocks.h"
#import "XYDatePicker.h"
#import "P_AddPhotoViewController.h"
#import "AFNetworking.h"
#import "Basic_business_moduleListViewController.h"

@interface Basic_business_moduleSubmitViewController ()<UITextFieldDelegate,CustomerViewControllerDelegate,XYDatePickerDelegate,AddPhotoViewControllerDelegate>{
    
    NSMutableArray *detailMuArr;
    NSMutableDictionary *detailMuDic;
}

@property (copy, nonatomic) NSString *business_id;

@property(nonatomic, assign) NSInteger timeType;

///选择的公司对象
@property(nonatomic, strong) CompEntity *selectedComEntitiy;

@end

@implementation Basic_business_moduleSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基础业务受理";
    
    detailMuDic = [NSMutableDictionary dictionary];
    //    CompanyCheck :选择集团 Text：填写 Label: 只读 Time: 选择时间  imageCheck：上传图片
    //    messageCheck :下拉框
    UserEntity *userInfo = [UserEntity sharedInstance];
    detailMuArr = [[NSMutableArray alloc] initWithObjects:
                   @{@"title":@"客户经理",@"detail":@"username",@"type":@"Label",@"placeholder":@"",@"message":@""},
                   @{@"title":@"申请部门",@"detail":@"userdep_name",@"type":@"Label",@"placeholder":@"",@"message":@""},
                   @{@"title":@"集团单位",@"detail":@"company_name",@"type":@"CompanyCheck",@"placeholder":@"请选择集团单位名称",@"message":@""},
                   @{@"title":@"集团编号",@"detail":@"company_num",@"type":@"Label",@"placeholder":@"选择集团单位后自动生成",@"message":@""},
                   @{@"title":@"基础业务类型",@"detail":@"basic_business_type",@"type":@"messageCheck",@"placeholder":@"请选择营销方案类型",@"message":@[@"解除互斥",@"终止活动",@"解除机卡合一",@"取消保底",@"活动延期",@"其他"]},
                   @{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"客户参加活动时间",@"detail":@"activity_time",@"type":@"Time",@"placeholder":@"请选择客户参加活动时间",@"message":@""},
                   @{@"title":@"业务需求说明",@"detail":@"business_info",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"备注",@"detail":@"remarks",@"type":@"Text",@"placeholder":@"",@"message":@""},
                   @{@"title":@"附件上传",@"detail":@"image",@"type":@"imageCheck",@"placeholder":@"请上传合同相关资料",@"message":@""},nil];
    
    
    for (NSDictionary *dic in detailMuArr) {
        
        [detailMuDic setObject:@"" forKey:dic[@"detail"]];
        [detailMuDic setObject:@" " forKey:@"image"];
        
        if (self.detailDict) {
            
            self.business_id = self.bListModel.business_id;
            
            if ([dic[@"detail"] isEqualToString:@"username"] || [dic[@"detail"] isEqualToString:@"userdep_name"] || [dic[@"detail"] isEqualToString:@"image"]) {
                
            }else{
                
                [detailMuDic setObject:self.detailDict[dic[@"detail"]] forKey:dic[@"detail"]];
                
            }
            
        }
        
        [detailMuDic setObject:userInfo.name forKey:@"username"];
        [detailMuDic setObject:userInfo.dep_name forKey:@"userdep_name"];
        
    }
    
    if (self.detailDict) {
        if ([self.detailDict[@"basic_business_type"] isEqualToString:@"活动延期"]) {
            
            [detailMuArr removeObject:@{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Text",@"placeholder":@"",@"message":@""}];
            [detailMuArr removeObject:@{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Text",@"placeholder":@"",@"message":@""}];

            [detailMuArr insertObject:@{@"title":@"大活动名称",@"detail":@"big_activity_name",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:5];
            [detailMuArr insertObject:@{@"title":@"大活动ID",@"detail":@"big_activity_id",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:6];

            
            [detailMuDic setObject:self.detailDict[@"big_activity_name"] forKey:@"big_activity_name"];
            [detailMuDic setObject:self.detailDict[@"big_activity_id"] forKey:@"big_activity_id"];
        }
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
    
    if ([detailMuDic[@"basic_business_type"] isEqualToString:@"活动延期"]) {
        
        [detailMuDic setObject:@" " forKey:@"client_name"];
        [detailMuDic setObject:@" " forKey:@"client_tel"];
        
    }else{
        
        [detailMuDic setObject:@" " forKey:@"big_activity_name"];
        [detailMuDic setObject:@" " forKey:@"big_activity_id"];
    }
    
    for (NSString *key in detailMuDic) {
        
        NSString *str = [detailMuDic objectForKey:key];
        
        for (NSDictionary *dic in detailMuArr) {
            
            if ([dic[@"detail"] isEqualToString:key] && ![key isEqualToString:@"remarks"]) {
                if (str.length == 0) {
                    
                    msg = [NSString stringWithFormat:@"%@不能为空",dic[@"title"]];
                    ALERT_ERR_MSG(msg);
                    isDone = YES;
                    return;
                    
                }
            }
        }
        
    }
    
//    if (self.uploadImagesArr.count <= 0) {
//
//        msg = @"请上传附件";
//    }
    
    if (msg) {
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    
    [detailMuDic setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    [detailMuDic setObject:userInfo.user_id forKey:@"create_id"];
    [detailMuDic setObject:@"24" forKey:@"type_id"];
    [detailMuDic setObject:detailMuDic[@"company_name"] forKey:@"title"];
    [detailMuDic setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];

    [self get_three_list:[detailMuDic objectForKey:@"type_id"] Successed:^(id entity) {

        int state = [entity[@"state"] intValue];

        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:detailMuDic];
        }else{

            [self goSumbitData:detailMuDic];
        }
        isDone = YES;
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return detailMuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
    
    NSDictionary *dict = detailMuArr[indexPath.row];
    
    cell.titleLbl.text = dict[@"title"];
    cell.txtField.placeholder = dict[@"placeholder"];
    
    if ([dict[@"detail"] isEqualToString:@"client_tel"]) {
        
        cell.txtField.keyboardType = UIKeyboardTypePhonePad;
        
    }else{
        
        cell.txtField.keyboardType = UIKeyboardTypeDefault;
        
    }
    
    if ([dict[@"type"] isEqualToString:@"imageCheck"]) {
        
        cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
        
    }else{
        
        cell.txtField.text = detailMuDic[dict[@"detail"]];
        
    }
    return cell;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    //    CompanyCheck :选择集团    Text：填写    Label: 只读   Time: 选择时间    imageCheck：上传图片
    //    messageCheck :下拉框
//    if (textField.tag == USER_NAME_TABLE_INDEX |
//        textField.tag == USER_DEP_TABLE_INDEX |
//        textField.tag == COMPANY_NUM_TABLE_INDEX){
//        return NO;
//    }
    NSString *type = detailMuArr[textField.tag][@"type"];
    NSString *title = detailMuArr[textField.tag][@"title"];
    NSString *detail = detailMuArr[textField.tag][@"detail"];
    
    if ([type isEqualToString:@"Label"]) {
        return NO;
    }else if ([type isEqualToString:@"Time"]){
        [self.view endEditing:YES];
        //预约时间
        self.timeType = textField.tag;
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        return NO;
    }else if ([type isEqualToString:@"CompanyCheck"]){
        [self.view endEditing:YES];
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if ([type isEqualToString:@"messageCheck"]){
        [self.view endEditing:YES];
        
        NSArray *data_arr = detailMuArr[textField.tag][@"message"];
        
        [UIActionSheet showInView:self.view
                        withTitle:title
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:data_arr
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             for (int i = 0; i < data_arr.count; i ++ ) {
                                 if (buttonIndex == i) {
                                     [detailMuDic setObject:data_arr[i] forKey:detail];
                                 }
                             }
                             
                             if ([detailMuDic[@"basic_business_type"] isEqualToString:@"活动延期"]) {
                                 
                                 NSInteger index= [detailMuArr indexOfObject:@{@"title":@"大活动名称",@"detail":@"big_activity_name",@"type":@"Text",@"placeholder":@"",@"message":@""} inRange:NSMakeRange(0, [detailMuArr count] - 1)];
                                 
                                 if(index == NSNotFound)
                                 {
                                     [detailMuArr removeObject:@{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                     [detailMuArr removeObject:@{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                     
                                     [detailMuArr insertObject:@{@"title":@"大活动名称",@"detail":@"big_activity_name",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:5];
                                     [detailMuArr insertObject:@{@"title":@"大活动ID",@"detail":@"big_activity_id",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:6];
                                 }else{
                                     
                                     
                                 }
                                 
                                 [_tableView reloadData];
                                 
                             }else{
                                 NSInteger index= [detailMuArr indexOfObject:@{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Text",@"placeholder":@"",@"message":@""} inRange:NSMakeRange(0, [detailMuArr count] - 1)];
                                 
                                 if(index == NSNotFound)
                                 {
                                     [detailMuArr removeObject:@{@"title":@"大活动名称",@"detail":@"big_activity_name",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                     [detailMuArr removeObject:@{@"title":@"大活动ID",@"detail":@"big_activity_id",@"type":@"Text",@"placeholder":@"",@"message":@""}];
                                     
                                     [detailMuArr insertObject:@{@"title":@"客户姓名",@"detail":@"client_name",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:5];
                                     [detailMuArr insertObject:@{@"title":@"客户手机号",@"detail":@"client_tel",@"type":@"Text",@"placeholder":@"",@"message":@""} atIndex:6];
                                 }
                                
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
        
    }else if ([type isEqualToString:@"imageCheck"]){
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
    NSString *type = detailMuArr[textField.tag][@"type"];
    NSString *detail = detailMuArr[textField.tag][@"detail"];
    
    if ([type isEqualToString:@"Text"]) {
        
        [detailMuDic setObject:textField.text forKey:detail];
        
    }
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{

    [detailMuDic setObject:entity.name forKey:@"company_name"];
    [detailMuDic setObject:entity.num forKey:@"company_num"];
    
    self.selectedComEntitiy = entity;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],\
                                         [NSIndexPath indexPathForRow:3 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    NSString *detail = detailMuArr[_timeType][@"detail"];
    
    [detailMuDic setObject:dateStr forKey:detail];
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_timeType inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    self.uploadImagesArr = imagesArr;

    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:detailMuArr.count-1 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];    
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
                                Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]init];
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
                        Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]init];
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

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)businessId
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%d",businessId,index];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);
    
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
                    if ([self.typeNum isEqualToString:@"1"]) {
                        Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]init];
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
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if ([self.typeNum isEqualToString:@"1"]) {
                    Basic_business_moduleListViewController *vc = [[Basic_business_moduleListViewController alloc]init];
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
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
