//
//  News_ProviceVIP_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/23.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_ProviceVIP_DetailViewController.h"
#import "CommonService.h"
#import "TwoLablesTableViewCell.h"
#import "ThreeLabelsTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "ThreeCheckBoxTableViewCell.h"
#import "News_ClickBtnTableViewCell.h"
#import "News_ProvinceVIP_List_DetailEntity.h"
#import "News_ProvinceVIP_List_ProcessAEntity.h"
#import "News_ProvinceVIP_List_OperEntity.h"
#import "MBProgressHUD.h"
#import "News_CustomerViewController.h"
#import "News_ProviceVIP_Edit_DetailViewController.h"
#import "BtnTableViewCell.h"
#import "ImagesBrowserViewController.h"
#import "News_ProvinceVIP_SubmitEntity.h"

@interface News_ProviceVIP_DetailViewController ()<MBProgressHUDDelegate,UITextFieldDelegate,News_CustomerViewControllerDelegate,ThreeCheckBoxTableViewCellDelegate,CheckBoxTableViewCellDelegate,XYDatePickerDelegate>
{
    UserEntity *userEntiy;
    MBProgressHUD *HUD;
    TwoLablesTableViewCell *cell1;
    TxtFieldTableViewCell *cell2;
    ThreeLabelsTableViewCell *cell3;
    CheckBoxTableViewCell *cell4;
    News_ClickBtnTableViewCell *cell5;
    ThreeCheckBoxTableViewCell *cell6;
    UIButton *submitBtn;
    
    NSMutableDictionary *submitDic;
    NSString *select_next_point_id;
    NSString *select_user_id;
    NSString *next_name;
    NSString *order_type;
    
    BOOL select_next_point;
    
    NSArray *imagesNameArr;
    
    NSString *order_time;//回款日期
    NSString *phone_num;//办理号码、回款金额
    
    NSString *keybordType;
}

@property (strong, nonatomic) NSMutableArray *DetailArr;
@property (strong, nonatomic) NSMutableArray *ProcessArr;
@property (strong, nonatomic) NSMutableArray *formsArr;
@property (strong, nonatomic) NSMutableArray *OperArr;
@property (assign, nonatomic) int num;
@property (assign, nonatomic) BOOL oper;

///处理意见
@property (nonatomic, copy) NSString *submitDesc;

@property (nonatomic,assign) BOOL isCheckBoxUnPass;

@property(nonatomic, copy) NSString *CheckBoxFile;//归档情况

@property(nonatomic, copy) NSString *CheckTwoBoxFile;//通过情况

@property(nonatomic, copy) NSString *CheckOneBoxFile;//通过情况

//@property (nonatomic, copy) NSString *
@end

@implementation News_ProviceVIP_DetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userEntiy = [UserEntity sharedInstance];
    self.oper = NO;
    self.num = 0;
    
    select_next_point = YES;
    
    self.isCheckBoxUnPass = NO; //默认通过
    
    self.DetailArr = [[NSMutableArray alloc]init];
    self.ProcessArr = [[NSMutableArray alloc]init];
    self.formsArr = [[NSMutableArray alloc]init];
    self.OperArr = [[NSMutableArray alloc]init];
    
    submitDic = [[NSMutableDictionary alloc]init];
    
    self.navigationItem.title = self.name;
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self getDate];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (order_type.length > 0) {
        return 3;
    }else{
      return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (order_type.length > 0) {
        if (section == 0) {
            
            if (self.oper) {
                News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
                
                if (!([entity.button_infos isEqualToString:@"-1"] || [entity.button_infos isEqualToString:@"-99"])) {
                    self.num ++;
                    
                }
                
                if ([entity.marks_flag isEqualToString:@"1"]) {
                    self.num ++;
                }
                
                if (![entity.select_next_point_id isEqualToString:@"-2"] && select_next_point) {
                    self.num ++;
                }
                
            }
            
            if (self.DetailArr.count > 0) {
                return [self.DetailArr count] + self.num + self.formsArr.count + 1;
            }else{
                return [self.DetailArr count] + self.num + self.formsArr.count;
            }
            
            
        }else if (section == 1){
            
            NSArray *deviceArr = [order_type componentsSeparatedByString:@";"];
            
            return deviceArr.count + 1;
            
        }else{
             return [self.ProcessArr count] + 1;
         }
        
    }else{
        if (section == 0) {
            
            if (self.oper) {
                News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
                
                if (!([entity.button_infos isEqualToString:@"-1"] || [entity.button_infos isEqualToString:@"-99"])) {
                    self.num ++;
                    
                }
                
                if ([entity.marks_flag isEqualToString:@"1"]) {
                    self.num ++;
                }
                
                if (![entity.select_next_point_id isEqualToString:@"-2"] && select_next_point) {
                    self.num ++;
                }
                
            }
            
            if (self.DetailArr.count > 0) {
                return [self.DetailArr count] + self.num + self.formsArr.count + 1;
            }else{
                return [self.DetailArr count] + self.num + self.formsArr.count ;
            }
            
            
            
        }else{
         
            return [self.ProcessArr count] + 1;
    
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [cell1.subTitleLbl sizeThatFits:CGSizeMake(cell1.subTitleLbl.frame
                                                             .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 44;
    }
    return size.height + 26;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"TxtFieldTableViewCell";
    static NSString *identifier3 = @"ThreeLabelsTableViewCell";
    static NSString *identifier4 = @"CheckBoxTableViewCell";
    static NSString *identifier5 = @"News_ClickBtnTableViewCell";
    static NSString *identifier6 = @"ThreeCheckBoxTableViewCell";
    static NSString *identifier7 = @"BtnTableViewCell";
    if (indexPath.section == 0) {
        
        cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell1) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        
        if (self.OperArr.count > 0) {
            News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
            
            if (indexPath.row == self.DetailArr.count + 1) {
                
                cell4 = [tableView dequeueReusableCellWithIdentifier:identifier4];
                if (!cell4) {
                    cell4 = [[[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil] firstObject];
                    cell4.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell4.delegate = self;
                }
                
                cell5 = [tableView dequeueReusableCellWithIdentifier:identifier5];
                if (!cell5) {
                    cell5 = [[[NSBundle mainBundle] loadNibNamed:identifier5 owner:nil options:nil] firstObject];
                    cell5.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell6 = [tableView dequeueReusableCellWithIdentifier:identifier6];
                if (!cell6) {
                    cell6 = [[[NSBundle mainBundle] loadNibNamed:identifier6 owner:nil options:nil] firstObject];
                    cell6.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell6.delegate = self;
                }
                
                cell4.titleLbl.text = @"审  核:";
                cell6.titleLbl.text = @"审  核:";
                
                NSArray *arr = [entity.button_infos componentsSeparatedByString:@";"];
                NSMutableArray *typearr = [[NSMutableArray alloc]init];
                for (NSString *str in arr) {
                    
                    NSRange range;
                    range = [str rangeOfString:@":"];
                    
                    if (range.location != NSNotFound) {
                        
                        [typearr addObject:[str substringToIndex:range.location]];
                        
                    }else{
                        
                        NSLog(@"Not Found");
                        
                    }
                    
                }
                
                if (typearr.count == 2) {
                    
                    [cell4 setSelectDataWithArray:@[typearr[0],typearr[1]]];
                    
                    if (!self.isCheckBoxUnPass) {
                        [cell4 setSelectBtnIndex:1];
                    }else{
                        [cell4 setSelectBtnIndex:2];
                    }
                    
                    return cell4;
                }else if (typearr.count == 3){
                    
                    [cell6 setSelectDataWithArray:@[typearr[0],typearr[1],typearr[2]]];
                    
                    NSMutableArray *typeArr = [self addtypeArr];
                    
                    if ([self.CheckBoxFile isEqualToString:typeArr[0]]) {
                        [cell6 setSelectBtnIndex:1];
                    }else if ([self.CheckBoxFile isEqualToString:typeArr[1]]){
                        [cell6 setSelectBtnIndex:2];
                    }else if ([self.CheckBoxFile isEqualToString:typeArr[2]]){
                        [cell6 setSelectBtnIndex:3];
                    }
                    
                    return cell6;
                }else{
                    
                    NSString *str = entity.button_infos;
                    
                    NSRange range;
                    range = [str rangeOfString:@":"];
                    
                    if (range.location != NSNotFound) {
                        
                        self.CheckOneBoxFile = [str substringFromIndex:range.location+range.length];
                        
                    }
                    
                    cell5.titleLabel.text = @"审  核:";
                    cell5.clickBtn.selected = YES;
                    
                    [cell5.clickBtn setImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateNormal];
                    
                    [cell5.clickBtn setTitle:[str substringToIndex:range.location] forState:UIControlStateNormal];
                    
                    [cell5.clickBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
                    return cell5;
                }
                
            }else{
                if (indexPath.row < self.DetailArr.count) {
                    News_ProvinceVIP_List_DetailEntity *entity1 = [self.DetailArr objectAtIndex:indexPath.row];
                    
                    if (entity1.form_type.intValue == 5) {
                        
                        BtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier7];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:identifier7 owner:nil options:nil] firstObject];
                            
                            [cell.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        cell.btn.tag = indexPath.row;
                        
                        cell.titleLbl.text = entity1.title;
                        
                        if (entity1.value.length > 0) {
                            NSString *names = [entity1.value substringFromIndex:1];
                            if (names.length > 0) {
                                imagesNameArr = [entity1.value componentsSeparatedByString:@";"];
                                if (imagesNameArr.count > 0) {
                                    [cell.btn setTitle:@"查看" forState:UIControlStateNormal];
                                }else{
                                    [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                                }
                            }
                        }else{
                            [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                        }
                        return cell;
                        
                    }else{
                        
                        
                        cell1.titleLbl.text = entity1.title;
                        cell1.subTitleLbl.text = entity1.value;
                        
                    }
                    
                    //                    [submitDic setObject:cell1.subTitleLbl.text forKey:entity1.title];
                    
                }else{
                    
                   
                    cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
                    if (!cell2) {
                        cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
                        cell2.txtField.delegate = self;
                        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell2.txtField.tag = indexPath.row;
                    
                    if (indexPath.row == self.DetailArr.count) {
                        cell1.titleLbl.text = @"状态：";
                        cell1.subTitleLbl.text = self.state_name;
                    }
                    
                    if (self.formsArr.count > 0 && indexPath.row > self.DetailArr.count) {
                        
                        News_ProvinceVIP_SubmitEntity *entity = [self.formsArr objectAtIndex:indexPath.row - self.DetailArr.count - 2];
                        cell2.titleLbl.text = entity.name;
                        
//                        if ([entity.constraint isEqualToString:@"3"]) {
//                            
//                            keybordType = @"3";
////                            cell2.txtField.keyboardType = UIKeyboardTypeNumberPad;
////                            cell2.txtField.returnKeyType = UIReturnKeyGo;
////                            cell2.txtField.autocorrectionType = UITextAutocorrectionTypeYes;
//                        }
                        
                        if (indexPath.row == self.DetailArr.count + 2) {
                            
                            cell2.txtField.text = phone_num;
                            cell2.txtField.placeholder = @"";
                            
                        }else if (indexPath.row == self.DetailArr.count + 3) {
                            
                            cell2.isNeedSelect = YES;
                            cell2.txtField.placeholder = @"请选择回款日期";
                            cell2.txtField.text = order_time;
                        }
                    
//                        cell2.isNeedSelect = YES;
//                        cell2.txtField.placeholder = @"请选择回款日期";
//                        cell2.txtField.text = order_time;
                        
                        return cell2;
                        
                    }else{
                        
                        if ([entity.select_next_point_id isEqualToString:@"-2"] || (![entity.select_next_point_id isEqualToString:@"-2"] && !select_next_point)) {
                            
                            if ([entity.marks_flag isEqualToString:@"1"]) {
                                if (indexPath.row == self.DetailArr.count + 2) {
                                    
                                    cell2.titleLbl.text = @"处理意见：";
                                    cell2.txtField.placeholder = @"请填写处理意见";
                                    cell2.isNeedSelect = YES;
                                    cell2.txtField.text = self.submitDesc;
                                    return cell2;
                                }
                                
                                
                            }
                            
                        }else if(![entity.select_next_point_id isEqualToString:@"-2"] && select_next_point){
                            
                            if ([entity.marks_flag isEqualToString:@"1"]) {
                                
                              if (indexPath.row == self.DetailArr.count) {
                                    
                                    
                                  cell1.titleLbl.text = @"状态：";
                                  cell1.subTitleLbl.text = self.state_name;
                                  
                                  return cell1;
                                  
                                }else if (indexPath.row == self.DetailArr.count + 2) {
                                    
                                    cell2.titleLbl.text = @"审核领导:";
                                    cell2.txtField.placeholder = @"请选择审核领导";
                                    cell2.txtField.text = next_name;
                                }else if (indexPath.row == self.DetailArr.count + 3) {
                                    
                                    
                                    cell2.titleLbl.text = @"处理意见：";
                                    cell2.txtField.placeholder = @"请填写处理意见";
                                    cell2.isNeedSelect = YES;
                                    cell2.txtField.text = self.submitDesc;
                                    
                                }
                                
                                return cell2;
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            if (indexPath.row == self.DetailArr.count) {
                
                
                cell1.titleLbl.text = @"状态：";
                cell1.subTitleLbl.text = self.state_name;
                
                
            }else{
                
                News_ProvinceVIP_List_DetailEntity *entity = [self.DetailArr objectAtIndex:indexPath.row];
                
                
                if (entity.form_type.intValue == 5) {
                    
                    BtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier7];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:identifier7 owner:nil options:nil] firstObject];
                        
                        [cell.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    cell.btn.tag = indexPath.row;
                    
                    cell.titleLbl.text = entity.title;
                    
                    if (entity.value.length > 0) {
                        NSString *names = [entity.value substringFromIndex:1];
                        if (names.length > 0) {
                            imagesNameArr = [entity.value componentsSeparatedByString:@";"];
                            if (imagesNameArr.count > 0) {
                                [cell.btn setTitle:@"查看" forState:UIControlStateNormal];
                            }else{
                                [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                            }
                        }
                    }else{
                        [cell.btn setTitle:@"暂无" forState:UIControlStateNormal];
                    }
                    return cell;
                    
                }else{
                    
                    cell1.titleLbl.text = entity.title;
                    cell1.subTitleLbl.text = entity.value;
                    
                }
            }
        }
        return cell1;
    }else{
        if (order_type.length > 0) {
            if (indexPath.section == 1) {
                
                cell3 = [tableView dequeueReusableCellWithIdentifier:identifier3];
                if (!cell3) {
                    cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                    cell3.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
                if (indexPath.row == 0) {
                    cell3.leftLbl.text = @"到货机型";
                    cell3.middleLbl.text = @"数量";
                    cell3.rightLbl.text = @"颜色";

                }else{
                  
                    NSArray *deviceArr = [order_type componentsSeparatedByString:@";"];
                    NSString *deviceStr = deviceArr[indexPath.row-1];
                    
                    NSArray *infoArr = [deviceStr componentsSeparatedByString:@","];
                    if (infoArr.count == 3) {
                        cell3.leftLbl.text = infoArr[0];
                        cell3.middleLbl.text = infoArr[1];
                        cell3.rightLbl.text = infoArr[2];
                    }
                }
                
                return cell3;
                
            }else if (indexPath.section == 2){
                cell3 = [tableView dequeueReusableCellWithIdentifier:identifier3];
                if (!cell3) {
                    cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                    cell3.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (indexPath.row == 0) {
                    cell3.leftLbl.text = @"状态";
                    cell3.middleLbl.text = @"受理人";
                    cell3.rightLbl.text = @"时间";
                }else{
                    
                    News_ProvinceVIP_List_ProcessAEntity *entity = [self.ProcessArr objectAtIndex:indexPath.row - 1];
                    
                    cell3.leftLbl.text = entity.state;
                    cell3.middleLbl.text = entity.name;
                    cell3.rightLbl.text = entity.time;
                    
                }
                return cell3;
            }
            
        }else{
            cell3 = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell3) {
                cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
                cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (indexPath.row == 0) {
                cell3.leftLbl.text = @"状态";
                cell3.middleLbl.text = @"受理人";
                cell3.rightLbl.text = @"时间";
            }else{
                
                News_ProvinceVIP_List_ProcessAEntity *entity = [self.ProcessArr objectAtIndex:indexPath.row - 1];
                
                cell3.leftLbl.text = entity.state;
                cell3.middleLbl.text = entity.name;
                cell3.rightLbl.text = entity.time;
                
            }
            return cell3;
        }
        
    }
    
    return nil;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    return [self validateNumber:string];
// 
//}
//- (BOOL)validateNumber:(NSString*)number {
//    
//    if ([keybordType isEqualToString:@"3"]) {
//        if (number.length == 0)  //删除操作
//            return YES;
//        
//        int asciiCode = [number characterAtIndex:0];
//        
//        if (asciiCode >= 48 && asciiCode <= 57)
//            return YES;
//        else
//            return NO;
//    }else{
//        
//       return YES;
//    
//    }
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == [tableView numberOfSections]-1) {
        if (indexPath.row == 0) {
            
        }else{
            News_ProvinceVIP_List_ProcessAEntity *model = self.ProcessArr[indexPath.row-1];
            if (![model.marks isEqualToString:@"-1"]) {
                
                iToast *toast = [iToast makeText:model.marks];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:3000];
                [toast show:iToastTypeNotice];
            }
        }
        
    }
}


#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (order_type.length > 0) {
      
        if (section == 1) {
            return @"> 申请机型列表";
        }else if (section == 2){
            return @"> 处理记录";
        }
    
    }else{
        
        if (section == [tableView numberOfSections]-1) {
            title = @"> 处理记录";
        }
        return title;
    }
    
    return nil;
}

- (void)getDate{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic = @{
                          @"method":@"m_business_detail",
                          @"user_id":userEntity.user_id,
                          @"business_id":self.business_id,
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];

        if ([strState isEqualToString:@"1"]) {
            
            NSMutableArray *datil = [entity objectForKey:@"detail"];
            NSMutableArray *process = [entity objectForKey:@"process"];
            NSMutableArray *forms = [entity objectForKey:@"forms"];
            
            if ([[entity allKeys] containsObject:@"oper"]) {
                
                self.oper = YES;
                
                NSDictionary *oper = [entity objectForKey:@"oper"];
                
                if ([[oper objectForKey:@"button_infos"] isEqualToString:@"-99"] || [[oper objectForKey:@"button_infos"] isEqualToString:@"-1"]) {
                    
                    submitBtn = [self setNaviRightBtnWithTitle:@"编辑"];
           
                }else{
                    submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
                    
                }
                
               [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                News_ProvinceVIP_List_OperEntity *entity = [[News_ProvinceVIP_List_OperEntity alloc]init];
                
                entity = [entity initWithAttributes:oper];
                [self.OperArr addObject:entity];
                
                select_next_point_id = entity.select_next_point_id;
                
                NSMutableArray *typearr = [self addtypeArr];
                
                if (typearr.count == 2) {
                    
                    self.CheckTwoBoxFile = typearr[0];
                    
                }else if (typearr.count == 3){
                    
                    self.CheckBoxFile = typearr[0];
                    
                }
                
                
            }
            
            for (NSDictionary *attributes in datil) {
                News_ProvinceVIP_List_DetailEntity *entity = [[News_ProvinceVIP_List_DetailEntity alloc]init];
                
                entity = [entity initWithAttributes:attributes];
                
                [self.DetailArr addObject:entity];
                if (entity.form_type.intValue == 6) {
                    order_type = [entity valueForKey:@"value"];
                    
                    if (order_type.length > 0) {
                        [self.DetailArr removeObject:entity];
                    }
                    
                }
                
                
            }
            
            for (NSDictionary *attributes in process) {
                News_ProvinceVIP_List_ProcessAEntity *entity = [[News_ProvinceVIP_List_ProcessAEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                [self.ProcessArr addObject:entity];
            }
            
            
            for (NSDictionary *attributes in forms) {
                News_ProvinceVIP_SubmitEntity *entity = [[News_ProvinceVIP_SubmitEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                [self.formsArr addObject:entity];
//                [submitDic setObject:@"" forKey:entity.submit_num];

            }

            
            [self.tableView reloadData];
        }
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
    }];
    
}

- (void)submitBtnClicked:(UIButton *)sender
{
    static BOOL isDone = YES;
    
    [self.view endEditing:YES];
    
    [submitDic setValue:@"m_business_change"  forKey:@"method"];
    [submitDic setValue:self.business_id  forKey:@"business_id"];
    [submitDic setValue:userEntiy.user_id  forKey:@"user_id"];
    
    if ([sender.titleLabel.text isEqualToString:TYPE_EDIT]) {
        
        News_ProviceVIP_Edit_DetailViewController *vc = [[News_ProviceVIP_Edit_DetailViewController alloc]init];
        
        vc.business_id = self.business_id;
        vc.name = self.name;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
        
    }else if ([sender.titleLabel.text isEqualToString:TYPE_SUBMIT]) {

        if (!isDone) {
            return;
        }
        
        isDone = NO;
        
        if (self.OperArr.count > 0) {
            
            News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
            
            NSMutableArray *typearr = [self addtypeArr];
            
            if (typearr.count == 2) {
                
                [submitDic setObject:self.CheckTwoBoxFile forKey:@"point_id"];
                
            }else if (typearr.count == 3){
                
                [submitDic setObject:self.CheckBoxFile forKey:@"point_id"];
                
            }else{
                if (self.CheckOneBoxFile.length == 0 ) {
                    ALERT_ERR_MSG(@"请选择");
                    isDone = YES;
                    return;
                }

                 [submitDic setObject:self.CheckOneBoxFile forKey:@"point_id"];
            }
            
            if (self.submitDesc.length == 0 && [entity.marks_flag isEqualToString:@"1"]) {
                ALERT_ERR_MSG(@"请填写处理意见");
                isDone = YES;
                return;
            }
        
            
        }
        
        
        if (self.formsArr.count > 0) {
            NSString *msg;
            for (int i = 0; i < self.formsArr.count; i++) {
                News_ProvinceVIP_SubmitEntity *entity = [self.formsArr objectAtIndex:i];
                
                if (entity.form_type.intValue == 0) {
                    if (phone_num.length == 0) {
                        msg = [NSString stringWithFormat:@"请填写%@",entity.name];
                    }
                    
                }else if (entity.form_type.intValue == 4){
                    if (order_time.length == 0) {
                        msg = [NSString stringWithFormat:@"请选择%@",entity.name];
                    }
                    
                }

            }
            if (msg.length > 0) {
                ALERT_ERR_MSG(msg);
                isDone = YES;
                return;
            }

    }
    
    
        [submitDic setObject:self.submitDesc?self.submitDesc:@"-1" forKey:@"marks"];
        
        [submitDic setObject:select_next_point_id?select_next_point_id:@"-2" forKey:@"select_point_id"];
        
        [submitDic setObject:select_user_id?select_user_id:@"-1" forKey:@"select_user_id"];
        

    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];

    [service getNetWorkData:submitDic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
            }];
        }
        
        [HUD hide:YES];
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
        [HUD hide:YES];
    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField.tag=%d",textField.tag);
    News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
    
    if (![entity.select_next_point_id isEqualToString:@"-2"] && textField.tag == self.DetailArr.count + 2 && select_next_point) {
        [self.view endEditing:YES];
        
        News_CustomerViewController *vc = [[News_CustomerViewController alloc]init];
        
        vc.delegate = self;
    
        vc.data_source = entity.select_next_method;
        
        vc.dep_id = userEntiy.dep_id;
        
        [vc getData_Next];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else{
        
        if (self.formsArr.count > 0) {
            
            News_ProvinceVIP_SubmitEntity *entity = [self.formsArr objectAtIndex:textField.tag - self.DetailArr.count - 2];
            if ([entity.form_type isEqualToString:@"4"]) {
                [self.view endEditing:YES];
                
                //预约时间
                XYDatePicker *datePicker = [XYDatePicker datePicker];
                datePicker.delegate = self;
                datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [datePicker show];
                return NO;
            }
        }
    }
    
    return YES;
    
}

#pragma mark - XYDatePickerDelegate

- (void)datePickerDonePressed:(XYDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
    self.num = 0;
    order_time = dateStr;

    for (int i = 0; i < self.formsArr.count; i++) {
        News_ProvinceVIP_SubmitEntity *entity = [self.formsArr objectAtIndex:i];
        
        if (entity.form_type.intValue == 4) {
            
            [submitDic setObject:order_time forKey:entity.submit_num];
            
        }
    }
    
    
    [_tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    TxtFieldTableViewCell *cell = (TxtFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    if ([cell isMemberOfClass:[TxtFieldTableViewCell class]]) {
        
        if (self.formsArr.count > 0) {
            News_ProvinceVIP_SubmitEntity *entity = [self.formsArr objectAtIndex:textField.tag - self.DetailArr.count - 2];
            phone_num = textField.text;
            [submitDic setObject:textField.text forKey:entity.submit_num];
            
//            for (NSString *key in submitDic) {
//                
//                if ([entity.submit_num isEqualToString:key]) {
//                    
//                    [submitDic setObject:textField.text forKey:entity.submit_num];
//                    return;
//                }
//                
//            }
        }else{
            
            if (cell.isNeedSelect) {
                self.submitDesc = textField.text;
            }
        }
       
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)News_Next_CustomerViewControllerViewController:(News_CustomerViewController *)vc didSelectCompany:(News_PtovinceVip_Next_CustomerEntity *)entity{
    
    self.num = 0;
    
    next_name = entity.name;
    select_user_id = entity.user_id;
    
    [_tableView reloadData];
    
}

#pragma mark - CheckBoxTableViewCellDelegate

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    NSMutableArray *typearr = [self addtypeArr];
    self.num = 0;
    
    if (selectedIndex == 1) {
        
        self.isCheckBoxUnPass = NO;
        self.CheckTwoBoxFile = typearr[0];
        
        select_next_point = YES;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        
        
        self.isCheckBoxUnPass = YES;
        self.CheckTwoBoxFile = typearr[1];
        select_user_id = @"-1";
        select_next_point_id = @"-2";
        select_next_point = NO;

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

- (void)ThreecheckBoxTableViewCell:(ThreeCheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    NSMutableArray *typearr = [self addtypeArr];
    self.num = 0;
    if (selectedIndex == 1) {
        self.CheckBoxFile = typearr[0];
        select_next_point = YES;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
    }else if(selectedIndex == 2){
        
        self.CheckBoxFile = typearr[1];
        select_next_point_id = @"-2";
        
        select_next_point = NO;
        select_user_id = @"-1";
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        self.CheckBoxFile = typearr[2];
        select_next_point = YES;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)checkBtn:(UIButton *)sender{
    
    
    if (sender.selected) {
        
        [cell5.clickBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        sender.selected = NO;
        NSLog(@"未选中状态");
        
        self.CheckOneBoxFile = @"";
    }else{
        
        NSLog(@"选中状态");
        
        [cell5.clickBtn setImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateNormal];
        sender.selected = YES;
        
        News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];

        NSString *str = entity.button_infos;
        
        NSRange range;
        range = [str rangeOfString:@":"];
        
        if (range.location != NSNotFound) {
            self.CheckOneBoxFile = [str substringFromIndex:range.location+range.length];
            
        }
        
    }
    
    
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

- (NSMutableArray *)addtypeArr{
    
    News_ProvinceVIP_List_OperEntity *entity = [self.OperArr objectAtIndex:0];
    
    NSArray *arr = [entity.button_infos componentsSeparatedByString:@";"];
    NSMutableArray *typearr = [[NSMutableArray alloc]init];
    for (NSString *str in arr) {
        NSRange range;
        range = [str rangeOfString:@":"];
        
        if (range.location != NSNotFound) {
            [typearr addObject:[str substringFromIndex:range.location+range.length]];
            
        }
    }
    return typearr;
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    if (imagesNameArr.count > 0) {

        ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
        vc.imagesNameArray = imagesNameArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
