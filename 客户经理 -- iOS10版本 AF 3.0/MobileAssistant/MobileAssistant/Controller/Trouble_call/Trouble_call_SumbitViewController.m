//
//  Trouble_call_SumbitViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/4.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Trouble_call_SumbitViewController.h"
#import "MBProgressHUD.H"
#import "AFNetworking.h"
#import "M_Order_Demand_SumiltEntity.h"
#import "UIActionSheet+Block.h"
#import "M_Product_listViewController.h"
#import "Trouble_callListViewController.h"
#import "M_OrderUserViewController.h"
#import "M_Order_FormViewController.h"

@interface Trouble_call_SumbitViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,M_Product_listViewControllerDelegate,M_OrderUserViewControllerDelegate,M_Order_FormViewControllerDelegate>
{
    TxtFieldTableViewCell *cell;
    UserEntity *userEntity;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) NSMutableDictionary *submitDic;
@property (strong, nonatomic) NSMutableDictionary *dicCutomer;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation Trouble_call_SumbitViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"故障投诉";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    userEntity = [UserEntity sharedInstance];
    
    self.listArr = [[NSMutableArray alloc]init];
    self.submitDic = [[NSMutableDictionary alloc]init];
    self.dicCutomer = [[NSMutableDictionary alloc]init];
    self.arrayCutomer = [[NSMutableArray alloc]init];

    [self getDate];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDate{
    
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{
                          @"method":@"m_get_order_form",
                          @"user_id":userEntity.user_id,
                          @"company_name":_entity.name,
                          @"company_num":_entity.num,
                          @"type":@"1",
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"]) {
            
            
        }else{
            
            NSMutableArray *arr = [entity objectForKey:@"content"];
            
            for (NSDictionary *attributes in arr) {
                M_Order_Demand_SumiltEntity *entity = [[M_Order_Demand_SumiltEntity alloc]init];
                entity = [entity initWithAttributes:attributes];
                
                
                if ([entity.Init_type isEqualToString:@"0"]) {

                    [self.listArr addObject:entity];
                    
                }
                
                [self.submitDic setObject:@"" forKey:entity.name];
                
                if ([entity.type_id isEqualToString:@"0"] || [entity.type_id isEqualToString:@"1"]) {
                    
                    if ([entity.data_info isEqualToString:@"-1"]) {
                        
                    }else{
                        
                        [self.submitDic setObject:entity.data_info forKey:entity.name];
                        
                    }
                    
                }
//                [self.submitDic setObject:_entity.name forKey:@"company_name"];
//                
//                [self.submitDic setObject:_entity.num forKey:@"company_num"];

                [self.dicCutomer setObject:entity forKey:entity.form_id];

                [self.arrayCutomer addObject:entity];
            }
            
            [_tableView reloadData];
        }
        
    } Failed:^(int errorCode, NSString *message) {
        
    }];
    
}

- (void)submitBtnClicked:(UIButton *)sender{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    //    NSArray *listArr = [_listDic allValues];
    
    for (M_Order_Demand_SumiltEntity *entity in _listArr) {
        if ([_submitDic[entity.name] length] == 0) {
            ALERT_ERR_MSG(@"还有内容未填写！");
            isDone = YES;
            return;
        }
        
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //    1. 创建工单 m_create_order
    //    user_id 用户唯一ID
    //    dep_id  部门唯一ID
    //    next_processor_id 下级执行人
    //    next_processor_name  下级执行人姓名
    //    其他的根据定制的表单提交
    
    //    m_order_update
    //    self.entity?@"update_order":@"create_order"

        
    [dict setObject:@"m_create_order" forKey:@"method"];

    [dict setObject:userEntity.user_id forKey:@"user_id"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:userEntity.dep_id forKey:@"dep_id"];
    [dict setObject:_submitDic[@"next_processor_id"] forKey:@"next_processor_id"];
    [dict setObject:_submitDic[@"next_processor_name"] forKey:@"next_processor_name"];
    
    for (M_Order_Demand_SumiltEntity *entity in _listArr) {
        
        [dict setObject:_submitDic[entity.name] forKey:entity.name];
    }
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
                Trouble_callListViewController *vc = [[Trouble_callListViewController alloc]init];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[vc class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                    
                }
            }];
        }else{
            
        }
        
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        isDone = YES;
        [HUD hide:YES];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_listArr.count > 0) {
        
        return _listArr.count + 1;
        
    }else{
        
        return _listArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    M_Order_Demand_SumiltEntity *entity;
    
    if (indexPath.row == _listArr.count){
        
    }else{
        
        entity = [_listArr objectAtIndex:indexPath.row];
        
    }
    
    
    cell.titleLbl.text = entity.title;
    
//    if (indexPath.row == 0) {
//        
//        cell.txtField.text = userEntity.name;
//        [self.submitDic setObject:userEntity.name forKey:entity.name];
//    }else if (indexPath.row == 1){
//        
//        cell.txtField.text = userEntity.tel;
//        [self.submitDic setObject:userEntity.tel forKey:entity.name];
//        
//    }else if (indexPath.row == 2){
//        
//        cell.txtField.text = userEntity.dep_name;
//        [self.submitDic setObject:userEntity.dep_name forKey:entity.name];
//        
//    }else
//        
    if (indexPath.row == _listArr.count){
        
        cell.titleLbl.text = @"下级执行人";
        cell.txtField.placeholder = @"请选择";
        cell.downArrowImageView.hidden = NO;
        cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
        
        cell.txtField.text = self.submitDic[@"next_processor_name"];
        
    }else{
    
        
        cell.txtField.text = self.submitDic[entity.name];
        
        if ([entity.type_id isEqualToString:@"1"]) {
            
            cell.txtField.placeholder = entity.Init_data;
            
            cell.downArrowImageView.hidden = YES;
            
        }else if ([entity.type_id isEqualToString:@"2"]) {
            
            cell.txtField.placeholder = @"请选择";
            cell.downArrowImageView.hidden = NO;
            cell.downArrowImageView.image = [UIImage imageNamed:@"right"];
            
            
        }else if ([entity.type_id isEqualToString:@"4"]) {
            
            cell.txtField.placeholder = @"请选择";
            cell.downArrowImageView.hidden = YES;
            
            
        }else if ([entity.type_id isEqualToString:@"5"]) {
            
            cell.txtField.placeholder = @"请选择";
            cell.downArrowImageView.hidden = YES;
            
            
        }else{
            
            cell.txtField.placeholder = @"";
            
            cell.downArrowImageView.hidden = YES;
            
        }
    }
    
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*
     type_id = 0 表示文本框只读，从data_info中直接取数据
     type_id = 1 表示文本框（直接录入）
     type_id = 2 表示列表选择，从data_info取数据，每一项用;隔开
     type_id = 3 表示附件上传
     type_id = 4 表示下拉菜单选择，从data_info取数据，每一项用;隔开
     type_id = 5 表示下拉菜单选择，从data_info取接口名，重新请求数据
     */
    
    if (textField.tag == _listArr.count) {
        M_OrderUserViewController *vc = [[M_OrderUserViewController alloc]init];
        
        vc.order_id = @"-1";
        
        vc.Type = @"2";
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
        
    }else{
        
        M_Order_Demand_SumiltEntity *entity = [_listArr objectAtIndex:textField.tag];
        
        if ([entity.type_id isEqualToString:@"0"]) {
            
            return NO;
        }else if ([entity.type_id isEqualToString:@"1"]){
            
            
        }else if ([entity.type_id isEqualToString:@"2"]){
            
            M_Product_listViewController *vc = [[M_Product_listViewController alloc]init];
            
            vc.delegate = self;
            
            vc.entity = entity;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            return NO;
            
        }else if ([entity.type_id isEqualToString:@"4"]){
            [self.view endEditing:YES];
            
            NSArray *data_arr= [entity.data_info componentsSeparatedByString:@";"];
            
            
            [UIActionSheet showInView:self.view
                            withTitle:entity.title
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:data_arr
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 for (int i = 0; i < data_arr.count; i ++ ) {
                                     if (buttonIndex == i) {
                                         for (NSString *key in self.submitDic) {
                                             
                                             if ([entity.name isEqualToString:key]) {
                                                 
                                                 [self.submitDic setObject:data_arr[i] forKey:key];
                                                 
                                                 [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag inSection:0]]
                                                                   withRowAnimation:UITableViewRowAnimationFade];
                                                 return ;
                                             }
                                             
                                         }
                                         
                                     }
                                 }
                             }];
            return NO;
        }else if ([entity.type_id isEqualToString:@"5"]){
            
            M_Order_FormViewController *vc = [[M_Order_FormViewController alloc]init];
            
            vc.delegate = self;
            
            vc.methodEntity = entity;
            
            vc.Id = @"";
            
            [self.navigationController pushViewController:vc animated:YES];
            
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    M_Order_Demand_SumiltEntity *entity = [_listArr objectAtIndex:textField.tag];
    
    for (NSString *key in _submitDic) {
        
        if ([entity.name isEqualToString:key]) {
            
            [self.submitDic setObject:textField.text forKey:key];
            
            if (entity.Init_data.length < 2 && [[self.submitDic objectForKey:key] rangeOfString:entity.Init_data].location == NSNotFound) {
                
                textField.text = [NSString stringWithFormat:@"%@%@",[self.submitDic objectForKey:key],entity.Init_data];
                
            }
            
            return;
        }
        
    }
}

-(void)successM_OrderFormDelegate:(NSDictionary *)successdelegate{
    
    [self.submitDic setObject:[successdelegate objectForKey:@"message"] forKey:[successdelegate objectForKey:@"name"]];
    
    [_tableView reloadData];
}

- (void)successM_OrderUserDelegate:(NSDictionary *)successdelegate{
    
    [self.submitDic setObject:[successdelegate objectForKey:@"user_id"] forKey:@"next_processor_id"];
    [self.submitDic setObject:[successdelegate objectForKey:@"name"] forKey:@"next_processor_name"];
    
    [_tableView reloadData];
}

- (void)successM_Product_listViewDelegate:(NSDictionary *)successdelegate{
    
    M_Order_Demand_SumiltEntity *entity = [successdelegate objectForKey:@"entity"];
    
    [self.submitDic setObject:[successdelegate objectForKey:@"message"] forKey:entity.name];
    
    if (![entity.show_list isEqual:@"-1"]) {
        
        NSArray *data_info_arr= [entity.show_list componentsSeparatedByString:@";"];
        
        [self reloadTabele];
        
        for (NSString *str in data_info_arr) {
            
            NSRange range;
            range = [str rangeOfString:@"=>"];
            
            if (range.location != NSNotFound) {
                
                if ([[str substringToIndex:range.location] isEqualToString:[successdelegate objectForKey:@"message"]]) {
                    
                    NSArray *data_arr= [[str substringFromIndex:range.location+range.length] componentsSeparatedByString:@","];
                    
                    for (NSString *str in data_arr) {
                        
                        if([[self.dicCutomer allKeys] containsObject:str]) {
                            [self.listArr addObject:self.dicCutomer[str]];
                        }
                    }
                    
                }
                
            }else{
                
                NSLog(@"Not Found");
                
            }
            
        }
        
    }
    
    [_tableView reloadData];
}

-(void)reloadTabele{
    
    //    [self.listDic removeAllObjects];
    [self.listArr removeAllObjects];
    for (M_Order_Demand_SumiltEntity *entity in self.arrayCutomer) {
        
        if ([entity.Init_type isEqualToString:@"0"]) {
            
            //            [self.listDic setObject:entity forKey:entity.form_id];
            [self.listArr addObject:entity];
        }
        
    }
    
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
