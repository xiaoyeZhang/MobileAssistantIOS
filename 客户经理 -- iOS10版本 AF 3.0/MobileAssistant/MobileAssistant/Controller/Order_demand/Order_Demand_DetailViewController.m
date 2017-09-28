//
//  Order_Demand_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/28.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Order_Demand_DetailViewController.h"
#import "TwoLablesTableViewCell.h"
#import "LineTwoLabelTableViewCell.h"
#import "BtnTableViewCell.h"
#import "ImagesBrowserViewController.h"
#import "ThreeLabelsTableViewCell.h"
#import "TxtFieldTableViewCell.h"
#import "OrderUserViewController.h"
#import "CheckBoxTableViewCell.h"
#import "Order_Demand_SumiltViewController.h"
#import "Order_ScoreViewController.h"
#import "MBProgressHUD.h"

@interface Order_Demand_DetailViewController ()<UITextFieldDelegate,OrderUserViewControllerDelegate,CheckBoxTableViewCellDelegate,MBProgressHUDDelegate>
{
//    TwoLablesTableViewCell *cell;
    LineTwoLabelTableViewCell *cell;
    NSMutableArray *dicArr;
    NSArray *processMuArr;
    NSString *order_state;
    UIButton *submitBtn;
    UserEntity *userEntity;
    NSString *marks;
    NSString *op;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSString *order_user_name;//下级执行人姓名
@property (strong, nonatomic) NSString *order_user_id;//下级执行人ID

@end

@implementation Order_Demand_DetailViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    processMuArr = [[NSMutableArray alloc] init];
    
    order_state = @"";
    _order_user_name = @"";
    _order_user_id = @"";
    marks = @"";
    
    self.isCheckBoxUnPass = NO; //默认通过
    
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
    //type:  2--只读  0--可写  1--跳转列表 3 -- 附件上传 4 -- 单选
    dicArr = [NSMutableArray arrayWithObjects:
              @{@"title":@"申请人：",    @"type":@"2",  @"message":_entity.user_name},
              @{@"title":@"所属部门：",    @"type":@"2",  @"message":_entity.dep_name},
              @{@"title":@"电话号码：",@"type":@"2",@"message":_entity.tel},
              @{@"title":@"集团单位：",@"type":@"2",@"message":_entity.company_name},
              @{@"title":@"集团编号：",@"type":@"2",@"message":_entity.company_num},
              @{@"title":@"处理时限：",@"type":@"2",@"message":_entity.limit_time},
              @{@"title":@"产      品：",@"type":@"2",@"message":_entity.product_name},
              @{@"title":@"附      件：",@"type":@"2",@"message":_entity.imgs},
              @{@"title":@"备      注：",@"type":@"2",@"message":_entity.marks},
              nil];
    
    if ([_entity.addition_info isEqualToString:@""]) {
        
    }else{
        NSArray *imagesNameArr = [_entity.addition_info componentsSeparatedByString:@";"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < imagesNameArr.count; i++) {
            
            if ([imagesNameArr[i] rangeOfString:@":"].location != NSNotFound){
                NSArray *arr = [imagesNameArr[i] componentsSeparatedByString:@":"];
                
                [dic setObject:arr[1] forKey:arr[0]];
            }

        }
        
        if ([_entity.product_name isEqualToString:@"互联网专线"] || [_entity.product_name isEqualToString:@"数据专线"]) {
            
            [dicArr addObject:@{@"title":@"本地/省内跨区/跨省：",@"type":@"2",@"message":[dic objectForKey:@"province"]}];
            [dicArr addObject:@{@"title":@"带      宽：",@"type":@"2",@"message":[dic objectForKey:@"bandwidth"]}];
            [dicArr addObject:@{@"title":@"付费方式：",@"type":@"2",@"message":[dic objectForKey:@"method"]}];
            [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"2",@"message":[dic objectForKey:@"postage"]}];
            
            if ([[dic allKeys] containsObject:@"service_level"]) {
                
                [dicArr addObject:@{@"title":@"服务等级：",@"type":@"2",@"message":[dic objectForKey:@"service_level"]}];

            }
            if ([[dic allKeys] containsObject:@"protection_grade"]){
                 [dicArr addObject:@{@"title":@"保障等级：",@"type":@"2",@"message":[dic objectForKey:@"protection_grade"]}];
            }
            if ([[dic allKeys] containsObject:@"user_name"]){
                [dicArr addObject:@{@"title":@"用户名：",@"type":@"2",@"message":[dic objectForKey:@"user_name"]}];
            }
            if ([[dic allKeys] containsObject:@"whether_tube"]){
                [dicArr addObject:@{@"title":@"是否省管：",@"type":@"2",@"message":[dic objectForKey:@"whether_tube"]}];
            }
            
            if ([_entity.product_name isEqualToString:@"数据专线"]) {
                
                if ([[dic allKeys] containsObject:@"A_address"]){
                    [dicArr addObject:@{@"title":@"A端地址：",@"type":@"2",@"message":[dic objectForKey:@"A_address"]}];
                }
                if ([[dic allKeys] containsObject:@"Z_end"]){
                    [dicArr addObject:@{@"title":@"Z端地址：",@"type":@"2",@"message":[dic objectForKey:@"Z_end"]}];
                }
            }
            
        }else if ([_entity.product_name isEqualToString:@"IMS固话"]){
            [dicArr addObject:@{@"title":@"号码个数：",@"type":@"2",@"message":[dic objectForKey:@"phone_Num"]}];
            [dicArr addObject:@{@"title":@"靓号需求：",@"type":@"2",@"message":[dic objectForKey:@"needs"]}];
            [dicArr addObject:@{@"title":@"付费方式：",@"type":@"2",@"message":[dic objectForKey:@"method"]}];
            [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"2",@"message":[dic objectForKey:@"postage"]}];
        }else if ([_entity.product_name isEqualToString:@"集团v网（批量）"] || [_entity.product_name isEqualToString:@"彩铃（批量）"]){
            
            [dicArr addObject:@{@"title":@"付费方式：",@"type":@"2",@"message":[dic objectForKey:@"method"]}];
            [dicArr addObject:@{@"title":@"资费(分/月)：",@"type":@"2",@"message":[dic objectForKey:@"postage"]}];
            
        }else{
            
        }

    }
    
    switch ([_entity.state intValue]) {
        case -1:
            order_state = @"已驳回";
            break;
        case 0:
            order_state = @"已提交";
            break;
        case 1:
            order_state = @"已派发";
            break;
        case 2:
            order_state = @"已处理";
            break;
        case 3:
            order_state = @"已评价";
            break;
        default:
            break;
    }
    
    [dicArr addObject:@{@"title":@"状      态：",@"type":@"2",@"message":order_state}];
    
    processMuArr = [_entity.processor_infos componentsSeparatedByString:@";"];
    
    processMuArr = (NSMutableArray *)[[processMuArr reverseObjectEnumerator] allObjects];
    
    [self reloadSubmitData];
    
    [_tableView reloadData];
}

- (void)reloadSubmitData{
    

    
    int state = [_entity.state intValue];
    int to_do_flag = [_entity.to_do_flag intValue];
    
    if (to_do_flag == 1) {
        
        if (state == -1) {
            submitBtn = [self setNaviRightBtnWithTitle:@"编辑"];
            
            
        }else if (state == 0) {
            submitBtn = [self setNaviRightBtnWithTitle:@"派发"];
            
            [dicArr addObject:@{@"title":@"处理意见：",@"type":@"0",@"message":marks}];
            [dicArr addObject:@{@"title":@"下级执行人：",@"type":@"1",@"message":_order_user_name}];
            
            op = @"distribution";
            
        }else if (state == 1) {
            submitBtn = [self setNaviRightBtnWithTitle:@"提交"];
            
            [dicArr addObject:@{@"title":@"审      核：",@"type":@"4",@"message":@""}];
            [dicArr addObject:@{@"title":@"处理意见：",@"type":@"0",@"message":marks}];
            
            op = @"process";
            
//            op = @"reject";//驳回
            
        }else if (state == 2) {
            submitBtn = [self setNaviRightBtnWithTitle:@"评价"];
            
//            [dicArr addObject:@{@"title":@"评      价：",@"type":@"0",@"message":marks}];
            
            op = @"evaluate";
            
        }else if (state == 3) {
            
        }else{
            
        }
        if (state == -1) {
            [submitBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if (state == 2){
            [submitBtn addTarget:self action:@selector(ScoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }

    }else{
        
        if (state == 1 && [_entity.user_id isEqualToString:userEntity.user_id]) {
            
            submitBtn = [self setNaviRightBtnWithTitle:@"催单"];
            
            [submitBtn addTarget:self action:@selector(urgeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"1"]) {
        
        OrderUserViewController *vc = [[OrderUserViewController alloc]init];
        
        vc.type = @"25";
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;

    }else if([dicArr[textField.tag][@"type"] isEqualToString:@"0"]) {
        
    }else{
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([dicArr[textField.tag][@"type"] isEqualToString:@"0"]) {
        marks = textField.text;
    }
    
}

- (void)urgeBtnClicked:(id)sender{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"order_urge",@"method",
                                _entity.order_id,@"order_id",
                                nil];
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已催单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            [self backBtnClicked:nil];
            
        }];

        
        if (state > 0) {
            
        }else{
            
        }
        
        isDone = YES;
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
        [HUD hide:YES];
    }];
    
}

- (void)ScoreBtnClicked:(id)sender{
    Order_ScoreViewController *vc = [[Order_ScoreViewController alloc]init];
    
    vc.order_id = _entity.order_id;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editBtnClicked:(id)sender
{
    Order_Demand_SumiltViewController *vc = [[Order_Demand_SumiltViewController alloc]init];
    
    vc.entity = _entity;
    if (_entity.imgs.length > 0) {
        
        NSArray *namesArr = [_entity.imgs componentsSeparatedByString:@","];

        vc.uploadImagesArr = namesArr;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitBtnClicked:(UIButton *)sender{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    if ([op isEqualToString:@"reject"]) {
        
        if (marks.length == 0) {
            ALERT_ERR_MSG(@"处理意见不能为空！");
            isDone = YES;
            return;
        }
    }
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"change_order_state",@"method",
                                _entity.order_id,@"order_id",
                                userEntity.user_id,@"user_id",
                                op,@"op",
                                marks,@"marks",
                                nil];
    if ([op isEqualToString:@"distribution"]) {
        [dic setObject:_order_user_id forKey:@"next_processor_id"];
    }
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {

            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self backBtnClicked:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
            }];
            
        }else{
        
        }
        
        isDone = YES;
    } Failed:^(int errorCode, NSString *message) {
        isDone = YES;
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
         return dicArr.count;
    }else{
        return [processMuArr count] + 1;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    
        CGSize size = [cell.subTitleLbl sizeThatFits:CGSizeMake(cell.subTitleLbl.frame
                                                                 .size.width, MAXFLOAT)];
        if (size.height == 0) {
            return 44;
        }
        return size.height + 26;
        
    }else{
        
        return 44;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"LineTwoLabelTableViewCell";
    static NSString *identifier2 = @"BtnTableViewCell";
    static NSString *identifier3 = @"ThreeLabelsTableViewCell";
    static NSString *identifier4 = @"TxtFieldTableViewCell";
    static NSString *identifier5 = @"CheckBoxTableViewCell";
    
    if (indexPath.section == 0) { //详情
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([[[dicArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"1"] || [[[dicArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"0"]) {
            TxtFieldTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:identifier4
                                                      owner:nil
                                                    options:nil] firstObject];
                cell2.txtField.delegate = self;
            }
            
            cell2.indexPath = indexPath;
            cell2.txtField.tag = indexPath.row;
            [cell2.txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell2.titleLbl.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            if ([[[dicArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"0"]) {
                
                cell2.txtField.placeholder = [NSString stringWithFormat:@"请填写处理意见"];
                cell2.txtField.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"message"];
                cell2.isNeedSelect = NO;
                cell2.downArrowImageView.hidden = YES;
                
            }else if ([[[dicArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"1"]) {
                cell2.txtField.placeholder = [NSString stringWithFormat:@"请选择下级执行人"];
                cell2.txtField.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"message"];
                cell2.isNeedSelect = YES;
                cell2.downArrowImageView.hidden = NO;
            }else{
                
            }
            
            return cell2;
        }else if ([[[dicArr objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"4"]){
            
            CheckBoxTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:identifier5];
            if (!cell3) {
                cell3 = [[[NSBundle mainBundle] loadNibNamed:identifier5 owner:nil options:nil] firstObject];
                cell3.delegate = self;
            }
            cell3.indexPath = indexPath;
            cell3.titleLbl.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell3 setSelectDataWithArray:@[@"通过",@"不通过"]];
            
            if (!self.isCheckBoxUnPass) {
                [cell3 setSelectBtnIndex:1];
            }else{
                [cell3 setSelectBtnIndex:2];
            }
            
            return cell3;
        }else{
            if (indexPath.row == 7) {
                BtnTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if (!cell1) {
                    cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
                    
                    [cell1.btn addTarget:self action:@selector(btnTableViewCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                cell1.btn.tag = indexPath.row;
                
                cell1.titleLbl.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"title"];
                NSString *names = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"message"];
                
                if (names.length > 0) {
                    NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
                    if (imagesNameArr.count > 0) {
                        [cell1.btn setTitle:@"查看" forState:UIControlStateNormal];
                    }else{
                        [cell1.btn setTitle:@"暂无" forState:UIControlStateNormal];
                    }
                }else{
                    [cell1.btn setTitle:@"暂无" forState:UIControlStateNormal];
                }
                
                return cell1;
            }else{
                cell.titLabel.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"title"];
                
                cell.subTitleLbl.text = [[dicArr objectAtIndex:indexPath.row] objectForKey:@"message"];
                return cell;
            }
        }
      
    }else{
        ThreeLabelsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell1) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil] firstObject];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell1.leftLbl.text = @"状态";
            cell1.middleLbl.text = @"受理人";
            cell1.rightLbl.text = @"时间";
        }else{
            
            NSArray *processArr = [processMuArr[indexPath.row - 1] componentsSeparatedByString:@","];
            
            cell1.leftLbl.text = processArr[2];
            cell1.middleLbl.text = processArr[1];
            cell1.rightLbl.text = processArr[3];
        }
        
        return cell1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 处理记录";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [tableView numberOfSections]-1) {
        if (indexPath.row == 0) {
            
        }else{
            NSArray *processArr = [processMuArr[indexPath.row - 1] componentsSeparatedByString:@","];
            
            if ([NSString stringWithFormat:@"%@",processArr[4]].length > 0) {
                
                iToast *toast = [iToast makeText:processArr[4]];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:3000];
                [toast show:iToastTypeNotice];
                
            }
        }
        
    }
}

- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex
{
    if (selectedIndex == 1) {
        self.isCheckBoxUnPass = NO;
        op = @"process";
        
    }else{
        self.isCheckBoxUnPass = YES;
        op = @"reject";//驳回
        
    }
}

- (void)btnTableViewCellBtnClicked:(id)sender
{
    if (self.entity.imgs.length > 0) {
        NSString *names = [self.entity.imgs substringFromIndex:1];
        if (names.length > 0) {
            NSArray *imagesNameArr = [names componentsSeparatedByString:@","];
            
            ImagesBrowserViewController *vc = [[ImagesBrowserViewController alloc] init];
            vc.imagesNameArray = imagesNameArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)successOrderUserDelegate:(NSDictionary *)successdelegate{
    
    self.order_user_name = [successdelegate objectForKey:@"name"];
    self.order_user_id = [successdelegate objectForKey:@"user_id"];
    
    [self initData];
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
