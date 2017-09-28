//
//  P_TerminalSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/3.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_TerminalSubmitViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Block.h"
#import "AFNetworking.h"

#define USER_NAME_TABLE_INDEX 0  //客户经理列表索引
#define USER_DEP_TABLE_INDEX 1   //申请部门
#define COMPANY_TABLE_INDEX 2 //集团单位
#define COMPANY_NUM_TABLE_INDEX 3 //集团编号
#define CLINET_NAME_TABLE_INDEX 4 //客户姓名
#define PHONE_TABLE_INDEX 5 //电话号码
#define REMARKS_TABLE_INDEX 6 //备注
#define TYPE_TABLE_INDEX 7 //订货类型
#define DATE_TABLE_INDEX 8 //到货时间
#define DEVICE_TYPE_TABLE_INDEX 9 //机型
#define UPLOAD_TABLE_INDEX 10 //上传资料

@interface P_TerminalSubmitViewController ()

@end

@implementation P_TerminalSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"终端办理";
    
    self.order_type = @"已签合同";
    
    [self getInfoFromDetaiDict];
}

- (void)getInfoFromDetaiDict
{
    if (self.detailDict) {
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.order_type = self.detailDict[@"order_type"];
        self.order_time = self.detailDict[@"order_time"];
        self.order_info = self.detailDict[@"order_info"];
        self.client_name = self.detailDict[@"client_name"];
        self.phone_num = self.detailDict[@"client_tel"];
        self.remarks = self.detailDict[@"remarks"];
        
        if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"]){
            
            self.minimum_guarantee_amount = self.detailDict[@"minimum_guarantee_amount"];
            
        }
        
    }
}

#pragma mark - UIButtonMethod

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
    if(self.company.length == 0){
        msg = @"请选择集团单位";
    }else if (self.order_time.length == 0){
        msg = @"请选择到货时间";
    }else if (self.order_info.length == 0){
        msg = @"请输入机型";
    }
    
    if ([self.order_type isEqualToString:@"赠送机"]|
        [self.order_type isEqualToString:@"赠送礼品"]|
        [self.order_type isEqualToString:@"集团关键联系人保底购机活动"]|
        [self.order_type isEqualToString:@"业务"]) {
        
        if (self.client_name.length == 0) {
            msg = @"请输入客户姓名";
        }else if (self.phone_num.length == 0) {
            msg = @"请输入电话号码";
        }else if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"] && self.minimum_guarantee_amount.length == 0) {
            msg = @"请选择保底金额";
        }
    }else{
        
        if(self.uploadImagesArr.count == 0){
            msg = @"请上传合同资料";
        }
        
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
    
    [dict setObject:@"4" forKey:@"type_id"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num forKey:@"company_num"];
    
    [dict setObject:self.company forKey:@"title"];
    
    [dict setObject:self.order_type forKey:@"order_type"];
    
    [dict setObject:self.order_info forKey:@"order_info"];
    
    [dict setObject:self.order_time forKey:@"order_time"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
    [dict setObject:self.client_name?self.client_name:@"" forKey:@"client_name"];
    
    [dict setObject:self.phone_num?self.phone_num:@"" forKey:@"client_tel"];
    
    [dict setObject:self.remarks?self.remarks:@"" forKey:@"remarks"];
    
    if ([self.order_type isEqualToString:@"集团关键联系人保底购机活动"]){
        
       [dict setObject:self.minimum_guarantee_amount forKey:@"minimum_guarantee_amount"];
        
    }
    
    [self get_three_list:[dict objectForKey:@"type_id"] Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            [self showSIAlertView:[entity objectForKey:@"content"] andWithDict:dict];
        }else{
            
            [self goSumbitData:dict];
        }
        isDone = YES;
    }];
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
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }
        }else{
//            ALERT_ERR_MSG(@"上传图片失败");
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        if (([self.order_type isEqualToString:@"已签合同"] |
             [self.order_type isEqualToString:@"未签合同"] |
             [self.order_type isEqualToString:@"集团关键联系人保底购机活动"]) & !self.isFromTerminalStock) {
            rows = 11;
        }else{
            rows = 10;
        }
    }else{
        NSArray *arr = [self.order_info componentsSeparatedByString:@";"];
        
        rows = [arr count]>0?[arr count]+1:0;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    static NSString *identifier1 = @"ThreeLabelsTableViewCell";
    
    if (indexPath.section == 0) {
        TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
            cell.txtField.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.indexPath = indexPath;
        cell.txtField.tag = indexPath.row;
        
        UserEntity *userInfo = [UserEntity sharedInstance];
        
        switch (indexPath.row) {
            case USER_NAME_TABLE_INDEX:
            {
                cell.titleLbl.text = @"客户经理";
                cell.txtField.placeholder = nil;
                cell.txtField.text = userInfo.name;
                
                break;
            }
            case USER_DEP_TABLE_INDEX:
            {
                cell.titleLbl.text = @"申请部门";
                cell.txtField.placeholder = nil;
                cell.txtField.text = userInfo.dep_name;
                break;
            }
            case COMPANY_TABLE_INDEX:
            {
                cell.titleLbl.text = @"集团单位";
                cell.txtField.placeholder = @"请选择集团单位名称";
                cell.txtField.text = self.company;
                break;
            }
            case COMPANY_NUM_TABLE_INDEX:
            {
                cell.titleLbl.text = @"集团编号";
                cell.txtField.placeholder = @"选择集团单位后自动生成";
                cell.txtField.text = self.company_num;
                break;
            }
            case CLINET_NAME_TABLE_INDEX:
            {
                cell.titleLbl.text = @"客户姓名";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.client_name;
                break;
            }
            case PHONE_TABLE_INDEX:
            {
                cell.titleLbl.text = @"电       话";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.phone_num;
                break;
            }
            case REMARKS_TABLE_INDEX:
            {
                cell.titleLbl.text = @"备       注";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.remarks;
                break;
            }
            case TYPE_TABLE_INDEX:
            {
                cell.titleLbl.text = @"订货类型";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.order_type;
                break;
            }
            case DATE_TABLE_INDEX:
            {
                cell.titleLbl.text = @"到货时间";
                cell.txtField.placeholder = @"选择预计到货时间";
                cell.txtField.text = self.order_time;
                break;
            }
            case DEVICE_TYPE_TABLE_INDEX:
            {
                cell.titleLbl.text = @"机       型";
                cell.txtField.placeholder = @"请输入机型";
                cell.txtField.text = nil;
                
                if ([self.order_type isEqualToString:@"赠送礼品"]|
                    [self.order_type isEqualToString:@"业务"]) {
                    cell.titleLbl.text = @"业       务";
                    cell.txtField.placeholder = @"请输入业务";
                }
                break;
            }
            case UPLOAD_TABLE_INDEX:
            {
                if (([self.order_type isEqualToString:@"已签合同"] |
                     [self.order_type isEqualToString:@"未签合同"]) & !self.isFromTerminalStock) {
                    cell.titleLbl.text = @"上传资料";
                    cell.txtField.placeholder = @"请上传合同相关资料";
                    cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
                }else{
                    
                    cell.titleLbl.text = @"选择保底金额";
                    cell.txtField.placeholder = @"选择保底金额";
                    cell.txtField.text = self.minimum_guarantee_amount;
                    
                }
                
                break;
            }
            default:
                break;
        }
        
        return cell;
    }else{
        ThreeLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            cell.leftLbl.text = @"需求机型";
            cell.middleLbl.text = @"数量";
            cell.rightLbl.text = @"颜色";
            
            if ([self.order_type isEqualToString:@"赠送礼品"]|
                [self.order_type isEqualToString:@"业务"]) {
                cell.leftLbl.text = @"业务名称";
            }
        }else{
            NSArray *deviceArr = [self.order_info componentsSeparatedByString:@";"];
            NSString *deviceStr = deviceArr[indexPath.row-1];
            
            NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
            if (infoArr.count >= 3) {
                cell.leftLbl.text = infoArr[0];
                cell.middleLbl.text = infoArr[1];
                cell.rightLbl.text = infoArr[2];
            }
        }
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 1 && self.order_info) {
        title = @"机型列表";
        
        if ([self.order_type isEqualToString:@"赠送礼品"]|
            [self.order_type isEqualToString:@"业务"]) {
            title = @"业务列表";
        }
    }
    
    return title;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决
    
    if (textField.tag == USER_NAME_TABLE_INDEX |
        textField.tag == USER_DEP_TABLE_INDEX |
        textField.tag == COMPANY_NUM_TABLE_INDEX){
        return NO;
    }else if(textField.tag == COMPANY_TABLE_INDEX){ //集团单位
        
        [self.view endEditing:YES];
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        vc.enter_type = 1;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else if (textField.tag == TYPE_TABLE_INDEX){ //订货类型
    
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"订货类型"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"已签合同",@"未签合同",@"集团关键联系人保底购机活动",@"业务"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 self.order_type = @"已签合同";
                             }else if(buttonIndex == 1){
                                 self.order_type = @"未签合同";
                             }else if(buttonIndex == 2){
                                 self.order_type = @"集团关键联系人保底购机活动";
                             }else if(buttonIndex == 3){
                                 self.order_type = @"业务";
                             }
                             
//                             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:TYPE_TABLE_INDEX inSection:0]]
//                                               withRowAnimation:UITableViewRowAnimationFade];
                             [_tableView reloadData];
                             
                         }];
        
        return NO;
    }else if (textField.tag == DATE_TABLE_INDEX){ //到货时间
        [self.view endEditing:YES];
        
        //预约时间
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        return NO;
    }else if (textField.tag == DEVICE_TYPE_TABLE_INDEX){ //机型
        
        [self.view endEditing:YES];
        
        P_AddDevicesViewController *vc = [[P_AddDevicesViewController alloc] init];
        vc.device_info = self.order_info;
        vc.order_type = self.order_type;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if (textField.tag == UPLOAD_TABLE_INDEX){ //上传资料
    
        [self.view endEditing:YES];
        
        if (([self.order_type isEqualToString:@"已签合同"] |
             [self.order_type isEqualToString:@"未签合同"]) & !self.isFromTerminalStock) {
            P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
            vc.imagesArr = self.uploadImagesArr;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        
        }else{
            [UIActionSheet showInView:self.view
                            withTitle:@"保底金额"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"310100966401  28元保底[合约期6个月]",
                                        @"310100966402  58元保底[合约期6个月]",
                                        @"310100966403  88元保底[合约期6个月]",
                                        @"310100966404  128元保底[合约期6个月]",
                                        @"310100966405  158元保底[合约期6个月]",
                                        @"310100966406  188元保底[合约期6个月]",
                                        @"310100966407  238元保底[合约期6个月]",
                                        @"310100966408  258元保底[合约期6个月]",
                                        @"310100966409  288元保底[合约期6个月]",
                                        @"310100966410  338元保底[合约期6个月]",
                                        @"310100966411  388元保底[合约期6个月]"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex == 0) {
                                     self.minimum_guarantee_amount= @"310100966401 28元保底[合约期6个月]";
                                 }else if(buttonIndex == 1){
                                     self.minimum_guarantee_amount = @"310100966402  58元保底[合约期6个月]";
                                 }else if(buttonIndex == 2){
                                     self.minimum_guarantee_amount = @"310100966403  88元保底[合约期6个月]";
                                 }else if(buttonIndex == 3){
                                     self.minimum_guarantee_amount = @"310100966404  128元保底[合约期6个月]";
                                 }else if(buttonIndex == 4){
                                     self.minimum_guarantee_amount = @"310100966405  158元保底[合约期6个月]";
                                 }else if(buttonIndex == 5){
                                     self.minimum_guarantee_amount = @"310100966406  188元保底[合约期6个月]";
                                 }else if(buttonIndex == 6){
                                     self.minimum_guarantee_amount = @"310100966407  238元保底[合约期6个月]";
                                 }else if(buttonIndex == 7){
                                     self.minimum_guarantee_amount = @"310100966408  258元保底[合约期6个月]";
                                 }else if(buttonIndex == 8){
                                     self.minimum_guarantee_amount = @"310100966409  288元保底[合约期6个月]";
                                 }else if(buttonIndex == 9){
                                     self.minimum_guarantee_amount = @"310100966410  338元保底[合约期6个月]";
                                 }else if(buttonIndex == 10){
                                     self.minimum_guarantee_amount = @"310100966411  388元保底[合约期6个月]";
                                 }
                                 [_tableView reloadData];
                                 
                             }];
        }
        
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
    if (textField.tag == CLINET_NAME_TABLE_INDEX) {
        self.client_name = textField.text;
    }else if (textField.tag == PHONE_TABLE_INDEX){
        self.phone_num = textField.text;
    }else if (textField.tag == REMARKS_TABLE_INDEX){
        self.remarks = textField.text;
    }
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    self.company_num = entity.num;
    
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:COMPANY_TABLE_INDEX inSection:0],\
                                         [NSIndexPath indexPathForRow:COMPANY_NUM_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    self.order_time = dateStr;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:DATE_TABLE_INDEX inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - AddDevicesViewControllerDelegate

- (void)addDevicesViewController:(P_AddDevicesViewController *)vc addDevicesInfo:(NSString *)info
{
    self.order_info = info;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
              withRowAnimation:UITableViewRowAnimationNone];
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
            
            if ([self.order_type isEqualToString:@"赠送机"]|
                [self.order_type isEqualToString:@"赠送礼品"]|
                [self.order_type isEqualToString:@"集团关键联系人保底购机活动"]|
                [self.order_type isEqualToString:@"业务"]) {
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                }];
            }else{
                if (self.bListModel) { //编辑后上传
                    
                    for (int i = 0; i < [self.uploadImagesArr count]; i++) {
                        if ([self.uploadImagesArr[i] isKindOfClass:[UIImage class]]) {
                            //取出重新上传的图片
                            [self uploadImagesWithIndex:i withBusinessId:self.bListModel.business_id];
                            
                            break;
                        }
                        
                        //没有提交的图片 则显示提交成功
                        if (i == self.uploadImagesArr.count - 1) {
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                [self.navigationController popViewControllerAnimated:YES];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                            }];
                        }
                    }
                }else{ //第一次上传
                    [self uploadImagesWithIndex:0 withBusinessId:entity[@"content"]];
                }
            }
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }

    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
   
    }];

    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
