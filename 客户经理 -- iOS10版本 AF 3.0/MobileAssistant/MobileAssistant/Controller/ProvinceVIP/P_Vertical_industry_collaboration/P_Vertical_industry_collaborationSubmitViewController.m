//
//  P_Vertical_industry_collaborationSubmitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/15.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "P_Vertical_industry_collaborationSubmitViewController.h"
#import "TxtFieldTableViewCell.h"
#import "UIActionSheet+Block.h"
#import "XYDatePicker.h"
#import "P_AddPhotoViewController.h"
#import "Select_object_ViewController.h"
#import "Select_section_ManmerViewController.h"
#import "AFNetworking.h"
#import "goP_Vertical_industry_collaborationViewController.h"
#import "MBProgressHUD.h"

@interface P_Vertical_industry_collaborationSubmitViewController ()<UITextFieldDelegate,XYDatePickerDelegate,AddPhotoViewControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSArray *messageArr;
    NSMutableDictionary *submitDic;
    
    NSInteger type_Time;
    
    NSMutableArray *CustomerArr;
    
    NSMutableDictionary *section_Dic;
    NSString *addressStr;
}


@end

@implementation P_Vertical_industry_collaborationSubmitViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addressStr = [[NSString alloc]init];
    
    self.navigationItem.title = @"纵向行业任务协同";
    
    submitDic = [[NSMutableDictionary alloc]init];
    CustomerArr = [[NSMutableArray alloc]init];
    section_Dic = [[NSMutableDictionary alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [self setNaviRightBtnWithTitle:@"派发"];
    [addBtn addTarget:self action:@selector(SubmitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    messageArr = [NSArray arrayWithObjects:
                  @"主      题：",
                  @"提 交 人：",
                  @"联系方式：",
                  @"操作部门：",
                  @"操作时间：",
                  @"处理时限：",
                  @"集团产品：",
                  @"紧急程度：",
                  @"任务类别：",
                  @"合同上传：",
                  @"任务描述：",
                  @"备      注：",
                  @"选择派发对象：",
                  @"选择二级经理：",nil];
    
    if (self.entity != nil) {
        
        [submitDic setObject:self.entity.title forKey:messageArr[0]];
        [submitDic setObject:self.entity.submit_name forKey:messageArr[1]];
        [submitDic setObject:self.entity.tel forKey:messageArr[2]];
        [submitDic setObject:self.entity.dep_name forKey:messageArr[3]];
        [submitDic setObject:self.entity.op_time forKey:messageArr[4]];
        [submitDic setObject:self.entity.to_day forKey:messageArr[5]];
        [submitDic setObject:self.entity.product forKey:messageArr[6]];
        [submitDic setObject:self.entity.level forKey:messageArr[7]];
        [submitDic setObject:self.entity.type forKey:messageArr[8]];
        [submitDic setObject:self.entity.dep_name forKey:messageArr[9]];//合同上传
        [submitDic setObject:self.entity.content forKey:messageArr[10]];
        [submitDic setObject:self.entity.marks forKey:messageArr[11]];
        [submitDic setObject:self.entity.target_name forKey:messageArr[12]];
        [submitDic setObject:@"" forKey:messageArr[13]];
        addressStr = self.entity.target_num;
    }
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//派发
- (void)SubmitBtnClicked:(UIButton *)sender{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    for (NSString *key in submitDic) {
        
        if ([[submitDic objectForKey:key] isEqualToString:@""]) {
            
            NSString *str = [NSString stringWithFormat:@"%@不能为空",[key substringToIndex:key.length - 1]];
            
            ALERT_ERR_MSG(str);
            
            isDone = YES;
            return;
        }
    }
    
    
    if (CustomerArr.count> 0 ) {
        for (NSDictionary *dic in CustomerArr) {
            
            NSString *string = [NSString stringWithFormat:@"%@",dic[@"dep_id"]];
            addressStr = [addressStr stringByAppendingFormat:@"%@;",string];
        }
        
        addressStr = [addressStr substringToIndex:addressStr.length - 1];
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":!self.entity?@"create_teamwork":@"update_teamwork",
                           @"user_id":userInfo.user_id,
                           @"target_num":addressStr,//选择部门的ID，分号隔开
                           @"next_process_id":[section_Dic objectForKey:@"user_id"],//下级处理人的ID，分号隔开
                           @"next_processor_name":[section_Dic objectForKey:@"name"],//下级处理人的姓名，分号隔开
                           @"title":[submitDic objectForKey:@"主      题："],
                           @"submit_name":[submitDic objectForKey:@"提 交 人："],
                           @"tel":[submitDic objectForKey:@"联系方式："],
                           @"dep_name":[submitDic objectForKey:@"操作部门："],
                           @"op_time":[submitDic objectForKey:@"操作时间："],
                           @"to_day":[submitDic objectForKey:@"处理时限："],
                           @"product":[submitDic objectForKey:@"集团产品："],
                           @"level":[submitDic objectForKey:@"紧急程度："],
                           @"type":[submitDic objectForKey:@"任务类别："],
                           @"content":[submitDic objectForKey:@"任务描述："],
                           @"marks":[submitDic objectForKey:@"备      注："],
                           @"images":self.entity?self.entity.images:@"",
                           @"teamwork_id":self.entity?self.entity.teamwork_id:@""
                           };

    CommonService *service = [[CommonService alloc] init];


    [service getNetWorkData:dict  Successed:^(id entity) {

        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            
            NSString *teamwork_id = [entity objectForKey:@"state"];
            
            if (self.uploadImagesArr.count != 0) {
                for (int i = 0; i < [self.uploadImagesArr count]; i++) {
                    
                    if ([self.uploadImagesArr[i] isKindOfClass:[UIImage class]]) {
                        //取出重新上传的图片
                        [self uploadImagesWithIndex:i withBusinessId:teamwork_id];
                        
                        break;
                    }
                }
                if (self.entity != nil) {
                    
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        goP_Vertical_industry_collaborationViewController *vc = [[goP_Vertical_industry_collaborationViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                        
                    }];
                }
            }else{
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    //                [self.navigationController popViewControllerAnimated:YES];
                    
                    [self backBtnClicked:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    
                }];
            }
            
            
        }else{
            ALERT_ERR_MSG(@"提交失败");
        }
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
        isDone = YES;
        [HUD hide:YES];
    }];

}

- (void)uploadImagesWithIndex:(int)index withBusinessId:(NSString *)teamwork_id
{
    if (![self.uploadImagesArr[index] isKindOfClass:[UIImage class]]) {
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[NSUUID UUID] UUIDString]];
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImagesArr[index], 0.5f);
    
    NSDictionary *dict = @{@"method":@"common_upload",
                           @"teamwork_id":teamwork_id,
                           @"picname":imageName,
                           @"upload_type":@"teamwork",
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
                
                [self uploadImagesWithIndex:index+1 withBusinessId:teamwork_id];
            }else{
                if (self.entity != nil) {
                    
                }else{
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    }];
                }
            }
        }else{
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"附件提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArr.count;
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
    
    cell.txtField.tag = indexPath.row;
    cell.titleLbl.text = messageArr[indexPath.row];
    
    if (indexPath.row == 4 |indexPath.row == 5|indexPath.row == 6 | indexPath.row == 7 | indexPath.row == 8) {
        NSString *str = messageArr[indexPath.row];
        
        cell.txtField.placeholder = [NSString stringWithFormat:@"请选择%@",[str substringToIndex:str.length - 1]];
        
    }else if (indexPath.row == 12 || indexPath.row == 13) {
        NSString *str = messageArr[indexPath.row];
        
        cell.txtField.placeholder = [NSString stringWithFormat:@"请%@",[str substringToIndex:str.length - 1]];
        
    }else{
        cell.txtField.placeholder = @"";
    }
    
    cell.txtField.text = [submitDic objectForKey:messageArr[indexPath.row]];
  
    
    if(indexPath.row == 1){
        UserEntity *userInfo = [UserEntity sharedInstance];
        cell.txtField.text = userInfo.name;
        
    }
    
    if(indexPath.row == 5){

        cell.txtField.text = [submitDic objectForKey:messageArr[indexPath.row]]>0?[submitDic objectForKey:messageArr[indexPath.row]]:@"未知";
        
    }
    
    if(indexPath.row == 9){
        
        cell.txtField.placeholder = @"请上传合同相关资料";
        cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;
        
    }
    
    [submitDic setObject:cell.txtField.text forKey:messageArr[indexPath.row]];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 
    if (textField.tag == 1) {
        return NO;
    }
    
    if (textField.tag == 4) {
        [self.view endEditing:YES];
    
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        type_Time = textField.tag;
        
        return NO;
    }else if (textField.tag == 5) {
        [self.view endEditing:YES];
        
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker show];
        
        type_Time = textField.tag;
        
        return NO;
    }else if (textField.tag == 6) {
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"集团产品"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"WLAN",@"专线",@"行业应用卡",@"集团号簿",@"统付",@"其他"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     textField.text = @"WLAN";
                                 }else if(buttonIndex == 1){
                                     textField.text = @"专线";
                                 }else if(buttonIndex == 2){
                                     textField.text = @"行业应用卡";
                                 }else if(buttonIndex == 3){
                                     textField.text = @"集团号簿";
                                 }else if(buttonIndex == 4){
                                     textField.text = @"统付";
                                 }else if(buttonIndex == 5){
                                     textField.text = @"其他";
                                 }
                                 
                                 [submitDic setObject:textField.text forKey:messageArr[textField.tag]];

                             }
                             
                         }];
        
        return NO;
    }else if (textField.tag == 7) {
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"紧急程度"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"一级",@"二级"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     textField.text = @"一级";
                                 }else if(buttonIndex == 1){
                                     textField.text = @"二级";
                                 }
                                 
                                 [submitDic setObject:textField.text forKey:messageArr[textField.tag]];
                                 
                             }
                             
                         }];
        
        return NO;
    }else if (textField.tag == 8) {
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"任务类别"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"金融"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     textField.text = @"金融";
                                 }
                                 
                                 [submitDic setObject:textField.text forKey:messageArr[textField.tag]];
                             }
                             
                         }];
        
        return NO;
    }else if (textField.tag == 9) {
        [self.view endEditing:YES];
        
        P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
        vc.imagesArr = self.uploadImagesArr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if (textField.tag == 12) {
        [self.view endEditing:YES];
        
        Select_object_ViewController *vc = [[Select_object_ViewController alloc]init];
        
        vc.tcVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if (textField.tag == 13){
        
        [self.view endEditing:YES];
        
        Select_section_ManmerViewController *vc = [[Select_section_ManmerViewController alloc]init];
        
        vc.tcVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [submitDic setObject:textField.text forKey:messageArr[textField.tag]];
    
    return;
    
}

- (void)setCustomer:(NSMutableArray *)arr{

    [CustomerArr removeAllObjects];
    
    NSString *addressStrS = [[NSString alloc]init];
    
    [CustomerArr addObjectsFromArray:arr];
    
    for (NSDictionary *dic in arr) {
        
        NSString *string = [NSString stringWithFormat:@"%@",dic[@"name"]];
        addressStrS = [addressStrS stringByAppendingFormat:@"%@;",string];
    }
    
    addressStrS = [addressStrS substringToIndex:addressStrS.length - 1];
    
    [submitDic setObject:addressStrS forKey:messageArr[12]];
    
    [_tableView reloadData];
}

- (void)set_Section_Customer:(NSDictionary *)dic{
    
//    NSString *addressStr = [[NSString alloc]init];
    
//    for (NSString *str in arr) {
//        
//        NSString *string = [NSString stringWithFormat:@"%@",str];
//        addressStr = [addressStr stringByAppendingFormat:@"%@;",string];
//    }
//    
//    addressStr = [addressStr substringToIndex:addressStr.length - 1];
    [section_Dic addEntriesFromDictionary:dic];
    
    [submitDic setObject:dic[@"name"] forKey:messageArr[13]];
    
    [_tableView reloadData];
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    
    self.uploadImagesArr = imagesArr;
    [_tableView reloadData];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    [submitDic setObject:dateStr forKey:messageArr[type_Time]];
    
    [_tableView reloadData];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the tableView it might be occluding
    keyboardFrame = [_tableView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, _tableView.bounds);
    
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
            _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height+10, 0);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
