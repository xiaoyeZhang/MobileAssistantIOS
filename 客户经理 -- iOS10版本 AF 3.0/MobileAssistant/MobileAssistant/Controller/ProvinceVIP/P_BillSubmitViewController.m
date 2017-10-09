//
//  P_BillSubmitViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BillSubmitViewController.h"
#import "CustomerViewController.h"
#import "CheckBoxTableViewCell.h"
#import "P_ContractListViewController.h"
#import "XYDatePicker.h"
#import "UIActionSheet+Block.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "P_BillListViewController.h"

@interface P_BillSubmitViewController ()<UITextFieldDelegate,
                                         CustomerViewControllerDelegate,
                                         CheckBoxTableViewCellDelegate,
                                         ContractListViewControllerDelegate,
XYDatePickerDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

///备注
@property(nonatomic, copy) NSString *business_id;

///集团单位
@property(nonatomic, copy) NSString *company;

///单位编号
@property(nonatomic, copy) NSString *company_num;

///有无合同  有、无
@property(nonatomic, copy) NSString *bill_type;

///是否挂账 是、否 有合同时显示 否则不显示
@property(nonatomic, copy) NSString *on_account;

///账户编号
@property(nonatomic, strong) NSString *account_number;

///合同名称 有合同且备案进入合同列表、有合同无备案显示输入、自定义发票不显示
@property(nonatomic, copy) NSString *bill_contract;

///项目名称 自定发票时不显示
@property(nonatomic, copy) NSString *bill_project;

///自定义科目
@property(nonatomic, copy) NSString *bill_subject;

///发票金额
@property(nonatomic, copy) NSString *bill_amount;

///预回款日期
@property(nonatomic, copy) NSString *bill_predate;

///发票类别
@property(nonatomic, assign) NSString *bill_kind;

///固定科目
@property(nonatomic, copy) NSString *fixed_subject;

///选中的合同
@property(nonatomic, strong) BillListModel *selectedContractModel;

///备注
@property(nonatomic, strong) NSString *remarks;

///付款方式
@property(nonatomic, strong) NSString *type_payment;
@end

@implementation P_BillSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"开具发票";
    
    if (self.detailDict) {
        self.company = self.detailDict[@"company_name"];
        self.company_num = self.detailDict[@"company_num"];
        self.bill_type = self.detailDict[@"bill_type"];
        self.on_account = self.detailDict[@"on_account"];
        self.bill_contract = self.detailDict[@"bill_contract"];
        self.bill_project = self.detailDict[@"bill_project"];
        self.bill_subject = self.detailDict[@"bill_subject"];
        self.bill_amount = self.detailDict[@"bill_amount"];
        self.bill_predate = self.detailDict[@"bill_predate"];
        self.remarks = self.detailDict[@"remarks"];
        self.bill_kind = self.detailDict[@"bill_kind"];
        self.account_number = self.detailDict[@"account_number"];
        self.fixed_subject = self.detailDict[@"fixed_subject"];
        self.business_id = self.bListModel.business_id;
//        self.type_payment = self.detailDict[@"type_payment"];
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
    
    [self.view endEditing:YES];
    
    NSString *msg = nil;
    if(self.company.length == 0 ){
        msg = @"请选择集团单位";
        
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    if (self.bill_kind.length == 0) {
        msg = @"请选择发票类别";
        
        ALERT_ERR_MSG(msg);
        isDone = YES;
        return;
    }
    
    
    
    if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
        
        if(self.account_number.length == 0){
            msg = @"请填写账户编号";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.on_account.length == 0){
            msg = @"请选择是否挂账";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.bill_type.length == 0){
            msg = @"请选择有无合同";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.uploadImagesArr.count == 0){
            msg = @"请上传附件";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if ([self.bill_type isEqualToString:@"是"]){
            if (self.bill_contract.length == 0) {
                msg = @"请填写合同名称";
                
                ALERT_ERR_MSG(msg);
                isDone = YES;
                return;
            }
            
            if (self.bill_project.length == 0) {
                msg = @"请填写项目名称";
                
                ALERT_ERR_MSG(msg);
                isDone = YES;
                return;
            }
            
        }
        
        
        if (self.fixed_subject.length == 0) {
            msg = @"请选择固定科目";
            
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
    
        if(self.bill_amount.length == 0){
            msg = @"请填写发票金额";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.bill_predate.length == 0){
            msg = @"请选择预回款日期";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.remarks.length == 0){
            msg = @"请填写备注";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
//        if (self.type_payment.length == 0) {
//            msg = @"请选择付款方式";
//            ALERT_ERR_MSG(msg);
//            isDone = YES;
//            return;
//        }
//        
        if ([self.bill_type isEqualToString:@"否"]){
            msg = @"增值税发票必须要有合同，否则不能提交";
            
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        
    }else{
        
        if(self.bill_subject.length == 0){
            msg = @"请填写自定义科目";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.bill_amount.length == 0){
            msg = @"请填写发票金额";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.bill_predate.length == 0){
            msg = @"请选择预回款日期";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
        if(self.remarks.length == 0){
            msg = @"请填写备注";
            ALERT_ERR_MSG(msg);
            isDone = YES;
            return;
        }
        
    }
  
    


    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:!self.detailDict?@"submit_business":@"update_business" forKey:@"method"];
    
    [dict setObject:userInfo.user_id forKey:@"create_id"];
   
    [dict setObject:userInfo.tel forKey:@"msger_tel"];
    
    [dict setObject:[self.bill_kind isEqualToString:@"自定义发票"]?([self.bill_amount intValue] > 3000?@"13":@"14"):@"12" forKey:@"type_id"];
    
    [dict setObject:[NSString stringWithFormat:@"%@,%@,%@",self.company,self.bill_amount,self.bill_kind] forKey:@"title"];
    
    [dict setObject:[self.bill_kind isEqualToString:@"自定义发票"]?self.bill_subject:(self.bill_subject?self.bill_subject:@"") forKey:@"bill_subject"];
    
    [dict setObject:self.bill_predate?self.bill_predate:@"" forKey:@"bill_predate"];
    
    [dict setObject:@"" forKey:@"bill_type"];
    
    [dict setObject:([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"])?([self.bill_type isEqualToString:@"是"]?self.bill_contract:@""):@"" forKey:@"bill_contract"];
    
    [dict setObject:([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"])?([self.bill_type isEqualToString:@"是"]?self.bill_project:@""):@"" forKey:@"bill_project"];
    
    [dict setObject:self.company forKey:@"company_name"];
    
    [dict setObject:self.company_num?self.company_num:@"" forKey:@"company_num"];
    
    [dict setObject:self.bill_amount?self.bill_amount:@"" forKey:@"bill_amount"];
    
    [dict setObject:self.on_account?self.on_account:@"" forKey:@"bill_record"];
    
    [dict setObject:self.bill_kind?self.bill_kind:@"" forKey:@"bill_kind"];
    
    [dict setObject:self.remarks?self.remarks:@"" forKey:@"remarks"];
    
    [dict setObject:self.on_account?self.on_account:@"" forKey:@"on_account"];
    
    [dict setObject:([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"])?(self.fixed_subject?self.fixed_subject:@""):@"" forKey:@"fixed_subject"];
    
    [dict setObject:([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"])?(self.account_number?self.account_number:@""):@"" forKey:@"account_number"];
    
    [dict setObject:self.bListModel?self.bListModel.business_id:@"" forKey:@"business_id"];
    
//    [dict setObject:self.type_payment?self.type_payment:@"" forKey:@"type_payment"];
    
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
                        P_BillListViewController *vc = [[P_BillListViewController alloc]init];
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
//            ALERT_ERR_MSG(@"上传图片失败");
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传未成功，请返回列表删除工单后，重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if ([self.typeNum isEqualToString:@"1"]) {
                    P_BillListViewController *vc = [[P_BillListViewController alloc]init];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
        if ([self.bill_type isEqualToString:@"是"]) {
            return 16/*有合同*/;
        }
        return 14/*无合同*/;
    }else{
        return 8+1/*自定义科目*/+1/*发票类别*/;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TxtFieldTableViewCell";
    static NSString *identifier2 = @"CheckBoxTableViewCell";
     UserEntity *userInfo = [UserEntity sharedInstance];
//    if (indexPath.row == 5 || ([self.bill_type isEqualToString:@"有合同"] && indexPath.row == 7)) {
        CheckBoxTableViewCell *Checkcell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!Checkcell) {
            Checkcell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
            Checkcell.selectionStyle = UITableViewCellSelectionStyleNone;
            Checkcell.delegate = self;
        }
        Checkcell.indexPath = indexPath;
//
////        if (indexPath.row == 5) {
////            if ([userInfo.dep_id rangeOfString:@"10007"].location != NSNotFound) {
////                TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////                if (!cell) {
////                    cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
////                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                }
////                
////                cell.titleLbl.text = @"发票类型";
////                cell.txtField.text = @"自定义发票";
////                self.bill_type = @"自定义发票";
////                cell.txtField.userInteractionEnabled = NO;
////                return cell;
////            }else{
////                cell.titleLbl.text = @"发票类型";
////                [cell setSelectDataWithArray:@[@"自定义发票",@"有合同"]];
////                if ([self.bill_type isEqualToString:@"自定义发票"]) {
////                    cell.btn1.selected = YES;
////                    cell.btn2.selected = NO;
////                }else if([self.bill_type isEqualToString:@"有合同"]){
////                    cell.btn1.selected = NO;
////                    cell.btn2.selected = YES;
////                }
////                cell.btn2.hidden = YES;
////            }
////        }else
//        if(indexPath.row == 7){
//            cell.titleLbl.text = @"是否备案";
//            [cell setSelectDataWithArray:@[@"是",@"否"]];
//            
//            if ([self.bill_record isEqualToString:@"是"]) {
//                cell.btn1.selected = YES;
//                cell.btn2.selected = NO;
//            }else if([self.bill_record isEqualToString:@"否"]){
//                cell.btn1.selected = NO;
//                cell.btn2.selected = YES;
//            }
//        }
//        
//        return cell;
//    } else{
    
        TxtFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
            cell.txtField.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 45, 30);
            [btn setTitle:@"选择" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(selectCompanyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.txtField.rightView = btn;
            cell.txtField.rightViewMode = UITextFieldViewModeAlways;
        }
        
        cell.indexPath = indexPath;
        cell.txtField.tag = indexPath.row;
        
       
        
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLbl.text = @"客户经理";
                cell.txtField.placeholder = nil;
                cell.txtField.text = userInfo.name;
                
                break;
            }
            case 1:
            {
                cell.titleLbl.text = @"申请部门";
                cell.txtField.placeholder = nil;
                cell.txtField.text = userInfo.dep_name;
                break;
            }
            case 2:
            {
                cell.titleLbl.text = @"电话号码";
                cell.txtField.placeholder = nil;
                cell.txtField.text = userInfo.tel;
                break;
            }
            case 3:
            {
                cell.titleLbl.text = @"集团单位";
                cell.txtField.placeholder = @"请选择集团单位";
                cell.txtField.text = self.company;
                break;
            }
            case 4:
            {
                cell.titleLbl.text = @"集团编号";
                cell.txtField.placeholder = @"选择集团单位后自动生成";
                cell.txtField.text = self.company_num;
                break;
            }
            case 5:
            {
                cell.titleLbl.text = @"发票类别";
                cell.txtField.placeholder = @"请选择";
                cell.txtField.text = self.bill_kind;
                break;
            }
            case 6:
            {
                if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                    
                    cell.titleLbl.text = @"账户编号";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.account_number;
                    
                }else{
                    cell.titleLbl.text = @"自定义科目";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_subject;
                }
                break;
            }
            case 7:
            {
                if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                    
                    Checkcell.titleLbl.text = @"挂账";
                    [Checkcell setSelectDataWithArray:@[@"是",@"否"]];
        
                    if ([self.on_account isEqualToString:@"是"]) {
                        Checkcell.btn1.selected = YES;
                        Checkcell.btn2.selected = NO;
                    }else if([self.on_account isEqualToString:@"否"]){
                        Checkcell.btn1.selected = NO;
                        Checkcell.btn2.selected = YES;
                    }
            
                }else{
                    cell.titleLbl.text = @"发票金额";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_amount;
                }
                
                break;
            }
            case 8:
            {
                if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                    
                    Checkcell.titleLbl.text = @"有无合同";
                    [Checkcell setSelectDataWithArray:@[@"是",@"否"]];
                    
                    if ([self.bill_type isEqualToString:@"是"]) {
                        Checkcell.btn1.selected = YES;
                        Checkcell.btn2.selected = NO;
                    }else if([self.bill_type isEqualToString:@"否"]){
                        Checkcell.btn1.selected = NO;
                        Checkcell.btn2.selected = YES;
                    }
                }else{
                    cell.titleLbl.text = @"预回款日期";
                    cell.txtField.placeholder = @"请选择预回款日期";
                    cell.txtField.text = self.bill_predate;
                }
                break;
            }
            case 9:
            {
                if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
    
                    cell.titleLbl.text = @"附件上传";
                    cell.txtField.placeholder = @"请上传";
                    cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;

                }else{
                    cell.titleLbl.text = @"备注";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.remarks;
                }
                
                break;
            }
            case 10:
            {
                if ([self.bill_type isEqualToString:@"是"]) {
                    cell.titleLbl.text = @"合同名称";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_contract;
                }else{
                    cell.titleLbl.text = @"固定科目";
                    cell.txtField.placeholder = @"请选择";
                    cell.txtField.text = self.fixed_subject;
                }
                break;
            }
            case 11:
            {
                if ([self.bill_type isEqualToString:@"是"]) {
                    cell.titleLbl.text = @"项目名称";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_project;
                }else{
                    cell.titleLbl.text = @"发票金额";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_amount;
                }
                
                break;
            }
            case 12:
            {
                if ([self.bill_type isEqualToString:@"是"]) {
                    cell.titleLbl.text = @"固定科目";
                    cell.txtField.placeholder = @"请选择";
                    cell.txtField.text = self.fixed_subject;
                }else{
                    cell.titleLbl.text = @"预回款日期";
                    cell.txtField.placeholder = @"请选择预回款日期";
                    cell.txtField.text = self.bill_predate;
                }
                break;
            }
            case 13:
            {
                if ([self.bill_type isEqualToString:@"是"]) {
                    cell.titleLbl.text = @"发票金额";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.bill_amount;
                }else{
                    cell.titleLbl.text = @"备注";
                    cell.txtField.placeholder = nil;
                    cell.txtField.text = self.remarks;
                }
                break;
            }
            case 14:
            {
                
//                if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
//                    
//                    if ([self.bill_type isEqualToString:@"是"]) {
//      
//                        cell.titleLbl.text = @"预回款日期";
//                        cell.txtField.placeholder = @"请选择预回款日期";
//                        cell.txtField.text = self.bill_predate;
//                        
//                    }else{
//                        
//////                        cell.titleLbl.text = @"付款方式";
//////                        cell.txtField.placeholder = @"请选择付款方式";
//////                        cell.txtField.text = self.type_payment;
////                    }
//                    
//                }else{
                
                    cell.titleLbl.text = @"预回款日期";
                    cell.txtField.placeholder = @"请选择预回款日期";
                    cell.txtField.text = self.bill_predate;
                
//                }

                break;
            }
            case 15:
            {
                cell.titleLbl.text = @"备注";
                cell.txtField.placeholder = nil;
                cell.txtField.text = self.remarks;
                break;
            }
//            case 16:
//            {
//                cell.titleLbl.text = @"付款方式";
//                cell.txtField.placeholder = @"请选择付款方式";
//                cell.txtField.text = self.type_payment;
//                break;
//            }
            default:
                break;
        }
        
        if (indexPath.row == 3) {
            cell.txtField.rightView.hidden = NO;
        }else{
            cell.txtField.rightView.hidden = YES;
        }
    
        if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
            if (indexPath.row == 7 ||indexPath.row == 8 ) {
                 return Checkcell;
            }else{
                return cell;
            }
            
        }else{
            
            return cell;
        }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    //测试时切勿按tab键 此处有bug 暂未解决

    if (textField.tag == 0 |
        textField.tag == 1 |
        textField.tag == 2 |
        textField.tag == 4){
        return NO;
    }else if(textField.tag == 3){ //集团单位
//        [self.view endEditing:YES];
//        
//        CustomerViewController *vc = [[CustomerViewController alloc] init];
//        vc.enter_type = 1;
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return NO;
    }else if (textField.tag == 5){
        [self.view endEditing:YES];
        
        [UIActionSheet showInView:self.view
                        withTitle:@"发票类别"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"增值税普通发票",@"增值税专用发票",@"自定义发票"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if (buttonIndex == 0) {
                                     self.bill_kind = @"增值税普通发票";
                                 }else if(buttonIndex == 1){
                                     self.bill_kind = @"增值税专用发票";
                                 }else if(buttonIndex == 2){
                                     self.bill_kind = @"自定义发票";
                                 }
                                 
                                 [_tableView reloadData];
                             }
                             
                         }];
        
        return NO;
    } else if(textField.tag == 8){ //合同名称或预回款日期
        

        [self.view endEditing:YES];
        //预回款日期
        XYDatePicker *datePicker = [XYDatePicker datePicker];
        datePicker.delegate = self;
        [datePicker show];
        return NO;
        
    }else if (textField.tag == 9){
       
        if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){ //附件上传
            
            [self.view endEditing:YES];
            
            P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
            vc.imagesArr = self.uploadImagesArr;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
            return NO;
        }
    }else if(textField.tag == 10){ //固定科目
        
        
        if ([self.bill_type isEqualToString:@"是"]) {
           
        }else{
            
            [self.view endEditing:YES];
            
            [UIActionSheet showInView:self.view
                            withTitle:@"固定科目"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"基础电信业务 税率11%",@"增值电信业务 税率6%",@"多种税率（基础电信业务 税率11%及增值电信业务 税率6%）"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.fixed_subject = @"基础电信业务 税率11%";
                                     }else if(buttonIndex == 1){
                                         self.fixed_subject = @"增值电信业务 税率6%";
                                     }else if(buttonIndex == 2){
                                         self.fixed_subject = @"多种税率（基础电信业务 税率11%及增值电信业务 税率6%）";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
            
            return NO;

        }
        
        
    }else if(textField.tag == 11){ //发票金额
        
        
    }else if(textField.tag == 12){ //预回款日期
         [self.view endEditing:YES];
        if ([self.bill_type isEqualToString:@"是"]) {
            
            [UIActionSheet showInView:self.view
                            withTitle:@"固定科目"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:@[@"基础电信业务 税率11%",@"增值电信业务 税率6%",@"多种税率（基础电信业务 税率11%及增值电信业务 税率6%）"]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex != actionSheet.cancelButtonIndex) {
                                     
                                     if (buttonIndex == 0) {
                                         self.fixed_subject = @"基础电信业务 税率11%";
                                     }else if(buttonIndex == 1){
                                         self.fixed_subject = @"增值电信业务 税率6%";
                                     }else if(buttonIndex == 2){
                                         self.fixed_subject = @"多种税率（基础电信业务 税率11%及增值电信业务 税率6%）";
                                     }
                                     
                                     [_tableView reloadData];
                                 }
                                 
                             }];
        }else{
            //预回款日期
            XYDatePicker *datePicker = [XYDatePicker datePicker];
            datePicker.delegate = self;
            [datePicker show];
        }
       
        return NO;
    }else if(textField.tag == 12){
    
        return YES;
    }else if(textField.tag == 14){ //预回款日期
//        if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){ //付款方式
//            if ([self.bill_type isEqualToString:@"是"]) {
//                
//                //预回款日期
//                XYDatePicker *datePicker = [XYDatePicker datePicker];
//                datePicker.delegate = self;
//                [datePicker show];
//            }else{
//                [self.view endEditing:YES];
//                [UIActionSheet showInView:self.view
//                                withTitle:@"付款方式"
//                        cancelButtonTitle:@"取消"
//                   destructiveButtonTitle:nil
//                        otherButtonTitles:@[@"月结",@"预存"]
//                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                     if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                         
//                                         if (buttonIndex == 0) {
//                                             self.type_payment = @"月结";
//                                         }else if(buttonIndex == 1){
//                                             self.type_payment = @"预存";
//                                         }
//                                         [_tableView reloadData];
//                                     }
//                                     
//                                 }];
//                
//            }
//            
//        }else{
            //预回款日期
            XYDatePicker *datePicker = [XYDatePicker datePicker];
            datePicker.delegate = self;
            [datePicker show];
//        }
        
    
        return NO;
    }
//    else if(textField.tag == 16){ //付款方式
//        [self.view endEditing:YES];
//        [UIActionSheet showInView:self.view
//                        withTitle:@"付款方式"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"月结",@"预存"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 if (buttonIndex == 0) {
//                                     self.type_payment = @"月结";
//                                 }else if(buttonIndex == 1){
//                                     self.type_payment = @"预存";
//                                 }
//                                 [_tableView reloadData];
//                             }
//                             
//                         }];
//        
//        return NO;
//
//    }

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
        case 3:
        {
            if (self.company.length == 0 ) {
                self.company = textField.text;
            }
            
            break;
        }
        case 6: //
        {
            //自定义科目 此时为自定义发票

            if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                self.account_number = textField.text;
            }else{
                
                self.bill_subject = textField.text;
            }
            
            break;
        }
        case 7:
        {

            self.bill_amount = textField.text;

            break;
        }
        case 8:
        {

            self.bill_predate = textField.text; //备注

            break;
        }
        case 9:
        {
            self.remarks = textField.text; //备注
            
//            //项目名称
//            self.bill_subject = textField.text;

            break;
        }
        case 10:
        {
            if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                
                if ([self.bill_type isEqualToString:@"是"]) {
                    self.bill_contract = textField.text;
                }else{
                    self.fixed_subject = textField.text;
                }
                
            }else{
                self.fixed_subject = textField.text;
                
            }
            break;
        }
        case 11:
        {
            if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                
                if ([self.bill_type isEqualToString:@"是"]) {
                    self.bill_project = textField.text;
                }else{
                    self.bill_amount = textField.text;
                }
                
            }else{
                self.bill_amount = textField.text;
                
            }
            
            
            break;
        }
        case 12://
        {
            
            if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                
                if ([self.bill_type isEqualToString:@"是"]) {//固定科目
                    self.fixed_subject = textField.text;
                }else{
                    self.bill_predate = textField.text;
                }
                
            }else{
                self.bill_predate = textField.text;
                
            }
            
            break;
        }
        case 13:
        {
            if([self.bill_kind isEqualToString:@"增值税普通发票"] || [self.bill_kind isEqualToString:@"增值税专用发票"]){
                
                if ([self.bill_type isEqualToString:@"是"]) {
                    self.bill_amount = textField.text;
                }else{
                    self.remarks = textField.text;
                }
                
            }else{
                self.remarks = textField.text;
                
            }
            
            break;
        }
        case 14:
        {
            self.bill_predate = textField.text;
            
            
            break;
        }
        case 15:
        {
            self.remarks = textField.text;
            
            
            break;
        }
        default:
            break;
    }
    

}

#pragma mark -

- (void)selectCompanyBtnClicked:(id)sender
{
    CustomerViewController *vc = [[CustomerViewController alloc] init];
    vc.enter_type = 1;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CustomerViewControllerDelegate

- (void)customerViewController:(CustomerViewController *)vc didSelectCompany:(CompEntity *)entity
{
    self.company = entity.name;
    self.company_num = entity.num;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0],\
                                         [NSIndexPath indexPathForRow:4 inSection:0]]
                      withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    if (cell.indexPath.row == 7){//是否挂账
        if (selectedIndex == 1) {
            self.on_account = @"是";
        }else{
            self.on_account = @"否";
        }
    }else if (cell.indexPath.row == 8) { //有无合同
        if (selectedIndex == 1) {
            self.bill_type = @"是";
        }else{
            self.bill_type = @"否";
        }
    }
    [_tableView reloadData];
}

#pragma mark - ContractListViewControllerDelegate

- (void)contractListViewController:(P_ContractListViewController *)vc didSelectedModel:(BillListModel *)model
{
    self.selectedContractModel = model;
    
    [_tableView reloadData];
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.bill_predate = [dateFormatter stringFromDate:datePicker.date];
    
    [_tableView reloadData];
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
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
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
                                P_BillListViewController *vc = [[P_BillListViewController alloc]init];
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
                        P_BillListViewController *vc = [[P_BillListViewController alloc]init];
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
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        ALERT_ERR_MSG(message);
        [HUD hide:YES];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
