//
//  Order_Demand_SumiltViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/27.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Order_Demand_SumiltViewController.h"
#import "TxtFieldTableViewCell.h"
#import "CustomerViewController.h"
#import "Product_listViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIActionSheet+Block.h"
#import "OrderUserViewController.h"
#import "Order_demandViewController.h"

@interface Order_Demand_SumiltViewController ()<UITextFieldDelegate,Product_listViewControllerDelegate,OrderUserViewControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
    TxtFieldTableViewCell *cell;
    NSMutableArray *dicArr;
}
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *company_name;
@property (strong, nonatomic) NSString *company_num;
@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSString *limit_time;//截止时间
@property (strong, nonatomic) NSString *marks;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *bandwidth;//带宽
@property (strong, nonatomic) NSString *method;//付费方式
@property (strong, nonatomic) NSString *postage;//资费

@property (strong, nonatomic) NSString *phone_Num;//号码个数
@property (strong, nonatomic) NSString *needs;//靓号需求

@property (strong, nonatomic) NSString *service_level;//服务等级
@property (strong, nonatomic) NSString *protection_grade;//保障等级

@property (strong, nonatomic) NSString *user_name;//用户名
@property (strong, nonatomic) NSString *whether_tube;//是否省管

@property (strong, nonatomic) NSString *A_address;//A端地址
@property (strong, nonatomic) NSString *Z_end;//Z端地址

@property (strong, nonatomic) NSString *order_user_name;//下级执行人姓名
@property (strong, nonatomic) NSString *order_user_id;//下级执行人ID
//$user_name  用户姓名
//$dep_name  部门名称
//$tel  电话号码
//$company_name  集团名称
//$company_num 集团编号
//$product_name = 产品列表
@end

@implementation Order_Demand_SumiltViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单需求发起";
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _tel = userEntity.tel;
    _company_name = @"";
    _company_num = @"";
    _limit_time = @"";
    _product_name = @"";
    _marks = @"";
    
    _province = @"";
    _bandwidth = @"";
    _method = @"";
    _postage = @"";
    _phone_Num = @"";
    _needs = @"";
    _order_user_name = @"";
    
    _service_level = @"";
    _protection_grade = @"";
    _user_name = @"";
    _whether_tube = @"";
    _A_address = @"";
    _Z_end = @"";
    
    if (_entity) {
        _tel = _entity.tel;
        _company_name = _entity.company_name;
        _company_num = _entity.company_num;
        _limit_time = _entity.limit_time;
        _product_name = _entity.product_name;
        _marks = _entity.marks;
        
        if ([_entity.addition_info isEqualToString:@""]) {
            
        }else{
            NSArray *addition_infoArr = [_entity.addition_info componentsSeparatedByString:@";"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < addition_infoArr.count; i++) {
                NSArray *arr = [addition_infoArr[i] componentsSeparatedByString:@":"];
                
                [dic setObject:arr[1] forKey:arr[0]];
            }
            
            if ([_product_name isEqualToString:@"互联网专线"] || [_product_name isEqualToString:@"数据专线"]) {

                _province = [dic objectForKey:@"province"];
                _bandwidth = [dic objectForKey:@"bandwidth"];
                _method = [dic objectForKey:@"method"];
                _postage = [dic objectForKey:@"postage"];
                
              if ([[dic allKeys] containsObject:@"service_level"]) {
              
                  _service_level = [dic objectForKey:@"service_level"];
                  
              }
              if ([[dic allKeys] containsObject:@"protection_grade"]){
                  _protection_grade = [dic objectForKey:@"protection_grade"];
              }
                
              if ([[dic allKeys] containsObject:@"user_name"]){
                  _user_name = [dic objectForKey:@"user_name"];
              }
              if ([[dic allKeys] containsObject:@"whether_tube"]){
                  _whether_tube = [dic objectForKey:@"whether_tube"];
              }
               
                if ([_product_name isEqualToString:@"数据专线"]) {
                    
                    if ([[dic allKeys] containsObject:@"A_address"]){
                        _A_address = [dic objectForKey:@"A_address"];
                    }
                    if ([[dic allKeys] containsObject:@"Z_end"]){
                        _Z_end = [dic objectForKey:@"Z_end"];
                    }
                }
                
            }else if ([_product_name isEqualToString:@"IMS固话"]){
                _method = [dic objectForKey:@"method"];
                _postage = [dic objectForKey:@"postage"];
                _phone_Num = [dic objectForKey:@"phone_Num"];
                _needs = [dic objectForKey:@"needs"];
            }else if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"]){
                
                _method = [dic objectForKey:@"method"];
                _postage = [dic objectForKey:@"postage"];
                
            }else{
                
            }

        }
        
    }
    
    [self initData];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    
//    $user_name  用户姓名
//    $dep_name  部门名称
//    $company_name  集团名称
//    $company_num 集团编号
//    $product_name = 产品列表
    //type:  2--只读  0--可写  1--跳转列表 3 -- 附件上传  4 -- 当前页面选择
    dicArr = [NSMutableArray arrayWithObjects:
              @{@"title":@"申请人：",    @"type":@"2",  @"message":userEntity.name},
              @{@"title":@"所属部门：",    @"type":@"2",  @"message":userEntity.dep_name},
              @{@"title":@"客户经理电话号码：",@"type":@"2",@"message":_tel},
              @{@"title":@"集团单位：",@"type":@"1",@"message":_company_name},
              @{@"title":@"集团编号：",@"type":@"2",@"message":_company_num},
              @{@"title":@"处理时限：",@"type":@"0",@"message":_limit_time},
              @{@"title":@"产      品：",@"type":@"1",@"message":_product_name},
              @{@"title":@"附      件：",@"type":@"3",@"message":@""},
              @{@"title":@"备      注：",@"type":@"0",@"message":_marks},
              nil];
    if ([_product_name isEqualToString:@"互联网专线"] || [_product_name isEqualToString:@"数据专线"]) {
        
        [dicArr addObject:@{@"title":@"本地/省内跨区/跨省：",@"type":@"4",@"message":_province}];
        [dicArr addObject:@{@"title":@"带      宽：",@"type":@"0",@"message":_bandwidth}];
        [dicArr addObject:@{@"title":@"付费方式：",@"type":@"4",@"message":_method}];
        [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"0",@"message":_postage}];
        
        /*
         互联网专线产品提交信息的界面需提交关键字段：
         服务等级（金牌、银牌、铜牌、标准）
         保障等级（AAA、AA、A、普通）
         用户名（客户经理填写）
         是否省管（是、否）
         资费栏在后面限定单位 （填写）分/月
         
         数据专线除了以上内容，还要增加两个：
         A端地址（客户经理填写）
         Z端地址（客户经理填写）
         
         _service_level = [dic objectForKey:@"service_level"];
         _protection_grade = [dic objectForKey:@"protection_grade"];
         _user_name = [dic objectForKey:@"user_name"];
         _whether_tube = [dic objectForKey:@"whether_tube"];
         
         if ([_product_name isEqualToString:@"数据专线"]) {
         _A_address = [dic objectForKey:@"A_address"];
         _Z_end = [dic objectForKey:@"Z_end"];
         }
         
         */
        [dicArr addObject:@{@"title":@"服务等级：",@"type":@"4",@"message":_service_level}];
        [dicArr addObject:@{@"title":@"保障等级：",@"type":@"4",@"message":_protection_grade}];
        [dicArr addObject:@{@"title":@"用户名：",@"type":@"0",@"message":_user_name}];
        [dicArr addObject:@{@"title":@"是否省管：",@"type":@"4",@"message":_whether_tube}];
        
        if ([_product_name isEqualToString:@"数据专线"]) {
            [dicArr addObject:@{@"title":@"A端地址：",@"type":@"0",@"message":_A_address}];
            [dicArr addObject:@{@"title":@"Z端地址：",@"type":@"0",@"message":_Z_end}];
        }
        
    }else if ([_product_name isEqualToString:@"IMS固话"]){
        [dicArr addObject:@{@"title":@"号码个数：",@"type":@"0",@"message":_phone_Num}];
        [dicArr addObject:@{@"title":@"靓号需求：",@"type":@"0",@"message":_needs}];
        [dicArr addObject:@{@"title":@"付费方式：",@"type":@"4",@"message":_method}];
        [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"0",@"message":_postage}];
    }else if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"]){
        
        [dicArr addObject:@{@"title":@"付费方式：",@"type":@"4",@"message":_method}];
        [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"0",@"message":_postage}];
        
    }
    
    [dicArr addObject:@{@"title":@"下级执行人：",@"type":@"1",@"message":_order_user_name}];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TxtFieldTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.txtField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.txtField.tag = indexPath.row;
    cell.txtField.returnKeyType = UIReturnKeyDone;
    [cell.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    cell.titleLbl.text = dicArr[indexPath.row][@"title"];
    cell.txtField.text = dicArr[indexPath.row][@"message"];
    
    if ([dicArr[indexPath.row][@"type"] isEqualToString:@"1"] || [dicArr[indexPath.row][@"type"] isEqualToString:@"4"]) {
        cell.txtField.placeholder = @"请选择";
        cell.downArrowImageView.hidden = NO;
        cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
    }  else if ([dicArr[indexPath.row][@"type"] isEqualToString:@"3"]) {
        
        cell.txtField.placeholder = @"请上传相关资料";
        cell.txtField.text = self.uploadImagesArr.count>0?@"查看上传资料":nil;

    }  else{

        cell.txtField.placeholder = @"";
        cell.downArrowImageView.hidden = YES;
    }

    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_product_name isEqualToString:@"互联网专线"] || [_product_name isEqualToString:@"数据专线"]) {
        
        if ([dicArr[textField.tag][@"title"] isEqualToString:@"带      宽："]) {
            self.bandwidth = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"资费(分/月)："]) {
            self.postage = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"用户名："]) {
            self.user_name = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"A端地址："]) {
            self.A_address = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"Z端地址："]) {
            self.Z_end = textField.text;
        }
        
    }else if ([_product_name isEqualToString:@"IMS固话"]){

        if ([dicArr[textField.tag][@"title"] isEqualToString:@"号码个数："]) {
            self.phone_Num = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"靓号需求："]) {
            self.needs = textField.text;
        }else if ([dicArr[textField.tag][@"title"] isEqualToString:@"资费(分/月)："]) {
            self.postage = textField.text;
        }
        
    }else if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"]){
        
        if ([dicArr[textField.tag][@"title"] isEqualToString:@"资费(分/月)："]) {
            self.postage = textField.text;
        }
        
    }else{
        
    }
    
    switch (textField.tag) {
        case 2:
            self.tel = textField.text;
            break;
        case 5:
            self.limit_time = textField.text;
            break;
        case 8:
            self.marks = textField.text;
            break;
        default:
            break;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"2"]) {
        
        return NO;
        
    }
    
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] && textField.tag == 3) {
        
        CustomerViewController *vc = [[CustomerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.OderVC = self;
        vc.enter_type = 6;
        
        return NO;
    }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] && textField.tag == 6) {
        
        Product_listViewController *vc = [[Product_listViewController alloc]init];
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"] && textField.tag == [dicArr count] - 1) {
        
        OrderUserViewController *vc = [[OrderUserViewController alloc]init];
        
        vc.type = @"1";
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if ([dicArr[textField.tag][@"type"] isEqualToString:@"3"]){
        
        P_AddPhotoViewController *vc = [[P_AddPhotoViewController alloc] init];
        vc.imagesArr = self.uploadImagesArr;
        vc.delegate = self;
        vc.VC_Type = @"订单需求发起";
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
//    else if ([dicArr[textField.tag][@"type"] isEqualToString:@"4"] && [dicArr[textField.tag][@"title"] isEqualToString:@"本地/省内跨区/跨省："]){
//        
//        [self.view endEditing:YES];
//        [UIActionSheet showInView:self.view
//                        withTitle:@"本地/省内跨区/跨省"
//                cancelButtonTitle:@"取消"
//           destructiveButtonTitle:nil
//                otherButtonTitles:@[@"本地",@"省内跨区",@"跨省"]
//                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                             if (buttonIndex != actionSheet.cancelButtonIndex) {
//                                 
//                                 if (buttonIndex == 0) {
//                                     self.province = @"本地";
//                                 }else if(buttonIndex == 1){
//                                     self.province = @"省内跨区";
//                                 }else if(buttonIndex == 2){
//                                     self.province = @"跨省";
//                                 }
//                                 
//                                 [self initData];
//                             }
//                             
//                         }];
//        
//        return NO;
//    }
    else if ([dicArr[textField.tag][@"type"] isEqualToString:@"4"]){

        NSArray *Arr;
        NSString *titleStr = dicArr[textField.tag][@"title"];
        NSString *title_Str = [titleStr substringToIndex:[titleStr length] - 1];
        
        if ([titleStr isEqualToString:@"本地/省内跨区/跨省："]) {
            
            Arr = @[@"本地",@"省内跨区",@"跨省"];
            
        }else if ([titleStr isEqualToString:@"付费方式："]) {
            if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"])
            {
                Arr = @[@"统付",@"个付"];
            }else{
                Arr = @[@"预付费",@"后付费"];
            }
        }else if ([titleStr isEqualToString:@"服务等级："]) {
           
            Arr = @[@"金牌",@"银牌",@"铜牌",@"标准"];
        }else if ([titleStr isEqualToString:@"保障等级："]) {
            
            Arr = @[@"AAA",@"AA",@"A",@"普通"];
        }else if ([titleStr isEqualToString:@"是否省管："]) {
            
            Arr = @[@"是",@"否"];
        }
        
        
        [self.view endEditing:YES];
        [UIActionSheet showInView:self.view
                        withTitle:title_Str
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:Arr
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex != actionSheet.cancelButtonIndex) {
                                 
                                 if ([titleStr isEqualToString:@"本地/省内跨区/跨省："]) {
                                     
                                     if (buttonIndex == 0) {
                                         self.province = @"本地";
                                     }else if(buttonIndex == 1){
                                         self.province = @"省内跨区";
                                     }else if(buttonIndex == 2){
                                         self.province = @"跨省";
                                     }
                                     
                                 }else if ([titleStr isEqualToString:@"付费方式："]) {
                                     
                                     if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"])
                                     {
                                         if (buttonIndex == 0) {
                                             self.method = @"统付";
                                         }else if(buttonIndex == 1){
                                             self.method = @"个付";
                                         }
                                     }else{
                                         if (buttonIndex == 0) {
                                             self.method = @"预付费";
                                         }else if(buttonIndex == 1){
                                             self.method = @"后付费";
                                         }
                                     }
                                 }else if ([titleStr isEqualToString:@"服务等级："]) {
                                     
                                     if (buttonIndex == 0) {
                                         self.service_level = @"金牌";
                                     }else if(buttonIndex == 1){
                                         self.service_level = @"银牌";
                                     }else if(buttonIndex == 2){
                                         self.service_level = @"铜牌";
                                     }else if(buttonIndex == 3){
                                         self.service_level = @"标准";
                                     }
                                 }else if ([titleStr isEqualToString:@"保障等级："]) {
                                     
                                     if (buttonIndex == 0) {
                                         self.protection_grade = @"AAA";
                                     }else if(buttonIndex == 1){
                                         self.protection_grade = @"AA";
                                     }else if(buttonIndex == 2){
                                         self.protection_grade = @"A";
                                     }else if(buttonIndex == 3){
                                         self.protection_grade = @"普通";
                                     }
                                 }else if ([titleStr isEqualToString:@"是否省管："]) {
                                    
                                     if (buttonIndex == 0) {
                                         self.whether_tube = @"是";
                                     }else if(buttonIndex == 1){
                                         self.whether_tube = @"否";
                                     }
                                 }
                                 
                                
                                 [self initData];
                             }
                             
                         }];
        
        return NO;
    }
    
    return YES;
}

- (void)submitBtnClicked:(UIButton *)sender{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];

    if ([_tel isEqualToString:@""]) {

        ALERT_ERR_MSG(@"电话号码不能为空");
        isDone = YES;
        return;
    }else if ([_company_name isEqualToString:@""]){
        ALERT_ERR_MSG(@"集团单位不能为空");
        isDone = YES;
        return;
    }else if ([_limit_time isEqualToString:@""]){
        ALERT_ERR_MSG(@"截止时间不能为空");
        isDone = YES;
        return;
    }else if ([_product_name isEqualToString:@""]){
        ALERT_ERR_MSG(@"产品不能为空");
        isDone = YES;
        return;
    }else if ([_marks isEqualToString:@""]){
        ALERT_ERR_MSG(@"备注不能为空");
        isDone = YES;
        return;
    }else if ([_order_user_name isEqualToString:@""]){
        ALERT_ERR_MSG(@"下级执行人不能为空");
        isDone = YES;
        return;
    }
    
    
//    if (self.uploadImagesArr.count > 0) {
//        
//    }else{
//        ALERT_ERR_MSG(@"附件不能为空");
//        isDone = YES;
//        return;
//    }
    NSString *addition_infoStr = @"";
    if ([_product_name isEqualToString:@"互联网专线"] || [_product_name isEqualToString:@"数据专线"]) {
        
        if ([_province isEqualToString:@""]){
            ALERT_ERR_MSG(@"省区不能为空");
            isDone = YES;
            return;
        }else if ([_bandwidth isEqualToString:@""]){
            ALERT_ERR_MSG(@"带宽不能为空");
            isDone = YES;
            return;
        }else if ([_method isEqualToString:@""]){
            ALERT_ERR_MSG(@"付费方式不能为空");
            isDone = YES;
            return;
        }else if ([_postage isEqualToString:@""]){
            ALERT_ERR_MSG(@"资费不能为空");
            isDone = YES;
            return;
        }else if ([_service_level isEqualToString:@""]){
            ALERT_ERR_MSG(@"服务等级不能为空");
            isDone = YES;
            return;
        }else if ([_protection_grade isEqualToString:@""]){
            ALERT_ERR_MSG(@"保障等级不能为空");
            isDone = YES;
            return;
        }else if ([_user_name isEqualToString:@""]){
            ALERT_ERR_MSG(@"用户名不能为空");
            isDone = YES;
            return;
        }else if ([_whether_tube isEqualToString:@""]){
            ALERT_ERR_MSG(@"请选择是否省管");
            isDone = YES;
            return;
        }
        
        if ([_product_name isEqualToString:@"数据专线"]) {
            
            if ([_A_address isEqualToString:@""]){
                ALERT_ERR_MSG(@"A端地址不能为空");
                isDone = YES;
                return;
            }else if ([_Z_end isEqualToString:@""]){
                ALERT_ERR_MSG(@"Z端地址不能为空");
                isDone = YES;
                return;
            }
            
            addition_infoStr = [NSString stringWithFormat:@"province:%@;bandwidth:%@;method:%@;postage:%@;service_level:%@;protection_grade:%@;user_name:%@;whether_tube:%@;A_address:%@;Z_end:%@",_province,_bandwidth,_method,_postage,_service_level,_protection_grade,_user_name,_whether_tube,_A_address,_Z_end];
        }else{
             addition_infoStr = [NSString stringWithFormat:@"province:%@;bandwidth:%@;method:%@;postage:%@;service_level:%@;protection_grade:%@;user_name:%@;whether_tube:%@",_province,_bandwidth,_method,_postage,_service_level,_protection_grade,_user_name,_whether_tube];
        }
        
    }else if ([_product_name isEqualToString:@"IMS固话"]){

        if ([_phone_Num isEqualToString:@""]){
            ALERT_ERR_MSG(@"号码个数不能为空");
            isDone = YES;
            return;
        }else if ([_needs isEqualToString:@""]){
            ALERT_ERR_MSG(@"靓号需求不能为空");
            isDone = YES;
            return;
        }else if ([_method isEqualToString:@""]){
            ALERT_ERR_MSG(@"付费方式不能为空");
            isDone = YES;
            return;
        }else if ([_postage isEqualToString:@""]){
            ALERT_ERR_MSG(@"资费不能为空");
            isDone = YES;
            return;
        }

        
        addition_infoStr = [NSString stringWithFormat:@"phone_Num:%@;needs:%@;method:%@;postage:%@",_phone_Num,_needs,_method,_postage];

    }else if ([_product_name isEqualToString:@"集团v网（批量）"] || [_product_name isEqualToString:@"彩铃（批量）"])
    {
        if ([_method isEqualToString:@""]){
            ALERT_ERR_MSG(@"付费方式不能为空");
            isDone = YES;
            return;
        }else if ([_postage isEqualToString:@""]){
            ALERT_ERR_MSG(@"资费不能为空");
            isDone = YES;
            return;
        }
        
        
        addition_infoStr = [NSString stringWithFormat:@"method:%@;postage:%@",_method,_postage];
        
    }

    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSDictionary *dict = @{@"method":self.entity?@"update_order":@"create_order",
                           @"user_id":userEntity.user_id,
                           @"user_name":userEntity.name,
                           @"dep_name":userEntity.dep_name,
                           @"company_name":_company_name,
                           @"company_num":_company_num,
                           @"limit_time":_limit_time,
                           @"product_name":_product_name,
                           @"tel":_tel,
                           @"marks":_marks,
                           @"next_processor_id":_order_user_id,
                           @"addition_info":addition_infoStr,
                           @"order_id":self.entity?_entity.order_id:@""
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
            }else{
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    
                    if (_entity) {
                        Order_demandViewController *vc = [[Order_demandViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                    }else{
                       [self backBtnClicked:nil];
                    }
                    

                    
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
                           @"order_id":teamwork_id,
                           @"picname":imageName,
                           @"upload_type":@"order",
                           @"":imageData
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
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                    
                    if (_entity) {
                        Order_demandViewController *vc = [[Order_demandViewController alloc]init];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[vc class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                            
                        }
                    }else{
                        [self backBtnClicked:nil];
                    }
                    
                }];
            }
        }else{
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"附件提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
                if (_entity) {
                    Order_demandViewController *vc = [[Order_demandViewController alloc]init];
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[vc class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                        
                    }
                }else{
                    [self backBtnClicked:nil];
                }
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (void) setCustomerValue:(CompEntity *)ex
{
    self.compEntity = ex;
    
    if (ex == nil) {
        self.company_name = @"";
        self.company_num = @"";
    } else {
        self.company_name = _compEntity.name;
        self.company_num = _compEntity.num;
    }
    [self initData];
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)addPhotoViewController:(P_AddPhotoViewController *)vc didSelectImages:(NSArray *)imagesArr{
    
    self.uploadImagesArr = imagesArr;
    [self initData];
}

- (void)successProduct_listDelegate:(NSArray *)successdelegate{
    
    NSString *cusName = [[NSString alloc]init];
    
    for (NSDictionary *dic in successdelegate) {
        
        NSString *string = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        
        cusName = [cusName stringByAppendingFormat:@"%@;",string];
        
    }
    cusName = [cusName substringToIndex:cusName.length-1];
    self.product_name = cusName;
    
    [self initData];
}

- (void)successOrderUserDelegate:(NSDictionary *)successdelegate{
    
    self.order_user_name = [successdelegate objectForKey:@"name"];
    self.order_user_id = [successdelegate objectForKey:@"user_id"];
    
    [self initData];
}

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
