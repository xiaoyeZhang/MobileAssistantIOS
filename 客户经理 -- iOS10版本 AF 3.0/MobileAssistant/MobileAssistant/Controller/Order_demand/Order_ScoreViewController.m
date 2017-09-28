//
//  Order_ScoreViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/2/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Order_ScoreViewController.h"
#import "PushSettingTableViewCell.h"
#import "Order_demandViewController.h"
#import "MBProgressHUD.h"

@interface Order_ScoreViewController ()<UITextViewDelegate,MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    NSMutableString *marks;
    NSString *Message;
    NSArray *dataArr;
    MBProgressHUD *HUD;
}
@end

@implementation Order_ScoreViewController

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
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"确定"];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    Message = @"";
    
    dataArr = @[
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"9分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"8分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"7分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1分",@"title",@(NO),@"select",nil],
                [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0分",@"title",@(NO),@"select",nil],
                ];
    
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(id)sender
{
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    int index = 0;
    for (NSDictionary *dict in dataArr) {
        
        BOOL isSelect = [dict[@"select"] boolValue];
        if (isSelect) {
            marks = [NSMutableString stringWithFormat:@"本次评分:%@",dict[@"title"]];
            break;
        }
        
        index++;
    }

    [marks appendString:[NSString stringWithFormat:@" 意见:%@",Message]];
    
    if (index > 2) {
        if(Message.length == 0){
            ALERT_ERR_MSG(@"意见不能为空");
            isDone = YES;
            return;
        }
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"change_order_state",@"method",
                                _order_id,@"order_id",
                                userEntity.user_id,@"user_id",
                                @"evaluate",@"op",
                                marks,@"marks",
                                nil];
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state > 0) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                Order_demandViewController *vc = [[Order_demandViewController alloc]init];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[vc class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
                
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return dataArr.count;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 35;
    }else{
        return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 40;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"请为本次订单服务进行评价：";
    }else if (section == 1) {
        title = @"请为本次订单服务留下您的宝贵意见：";
    }
    
    return title;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:RGBA(49, 49, 49, 1)];
    [header.textLabel setFont:[UIFont systemFontOfSize:15]];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PushSettingTableViewCell";
    
    if (indexPath.section == 0) {
        PushSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        }
        
        NSDictionary *dict = dataArr[indexPath.row];
        
        
        cell.titleLbl.text = dict[@"title"];
        cell.checkBoxBtn.selected = [dict[@"select"] boolValue];
        
        
        return cell;
    }else{
        
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:identifier];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines = 0;
        }
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 170)];
        textView.returnKeyType = UIReturnKeyDone;
        textView.font = [UIFont systemFontOfSize:16];
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = RGBA(195, 195, 195, 1).CGColor;
        textView.delegate = self;
        
        [cell addSubview:textView];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    for (int i = 0; i < dataArr.count; i ++) {
        NSDictionary *dict = dataArr[i];
        
        [dict setValue:@(NO) forKey:@"select"];

    }
    
    NSDictionary *dict = dataArr[indexPath.row];

    BOOL isSelected = [dict[@"select"] boolValue];
    isSelected = !isSelected;
    [dict setValue:@(isSelected) forKey:@"select"];
    
    [tableView reloadData];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    Message = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
