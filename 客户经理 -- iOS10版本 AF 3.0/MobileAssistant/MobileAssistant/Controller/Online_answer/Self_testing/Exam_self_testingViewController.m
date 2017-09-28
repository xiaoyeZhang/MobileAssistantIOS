//
//  Exam_self_testingViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Exam_self_testingViewController.h"
#import "QRadioButton.h"
#import "MBProgressHUD.h"
#import "TestScoresViewController.h"
#import "Exam_DetailEntity.h"

@interface Exam_self_testingViewController ()<QRadioButtonDelegate,MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    NSMutableArray *MuArr;
    float cellHeight;
    NSMutableDictionary *answerMuDic;//答案的字典
}
@end

@implementation Exam_self_testingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自测";
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"交卷"];
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    cellHeight = 200;
    
    answerMuDic = [[NSMutableDictionary alloc]init];
    
    MuArr = [[NSMutableArray alloc]init];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
- (void)submitBtnClicked:(UIButton *)sender
{
    
    for (NSString *key in [answerMuDic allKeys]) {
        if ([[answerMuDic objectForKey:key] isEqual:@""]) {
            
            ALERT_MSG(@"警告",@"还有题目未填写！");
            
            return;
        }
    }
    
    [self submitAnswer];
}

#pragma mark - 提交
- (void)submitAnswer{
    
    static BOOL isDone = YES;
    if (!isDone) {
        return;
    }
    
    isDone = NO;
    
    [self.view endEditing:YES];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    
    NSMutableArray *answerArray = [NSMutableArray array];
    
    for (NSString *key in [answerMuDic allKeys]) {
        
        for (Exam_DetailEntity *entity in MuArr) {
            
            if ([key isEqualToString:entity.subject_id]) {
                
                //去除字符串中多余的逗号
                NSArray *parts = [[answerMuDic objectForKey:key] componentsSeparatedByString:@","];
                NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
                NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
                NSString *ResultStr = [filteredArray componentsJoinedByString:@","];
                
                NSString *submit_answer = [NSString stringWithFormat:@"%@:%@",key,ResultStr];
                
                [answerArray addObject:submit_answer];
            }
        }
        
        
    }
    
    NSString *answerStr = [answerArray componentsJoinedByString:@";"];
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"m_exam_submit", @"method",
                           @"", @"exam_id",
                           userEntity.user_id,@"user_id",
                           answerStr,@"answers",
                           @"2",@"type_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state intValue] > 0) {
            

            TestScoresViewController *vc = [[TestScoresViewController alloc]init];
            
            vc.Scores = [NSString stringWithFormat:@"%@",[entity valueForKeyPath:@"content"]];
            
            vc.type = @"1";
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
        
        [HUD hide:YES];
        
        isDone = YES;
        
    } Failed:^(int errorCode, NSString *message) {
        
        isDone = YES;
        
        [HUD hide:YES];
        
    }];
}

- (void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"m_exam_study", @"method",
                           userEntity.user_id, @"user_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *statee = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [statee intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Exam_DetailEntity *entity = [[Exam_DetailEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                [answerMuDic setObject:@"" forKey:entity.subject_id];
                [MuArr addObject:entity];
            }
            
        }else{
            
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return MuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeight;
}
//type  0:单选题  1:多选题  2:是非题
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    Exam_DetailEntity *entity = [MuArr objectAtIndex:indexPath.row];
    
    UILabel *question = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 15, [self heightForString:entity.title fontSize:17 andWidth:self.view.frame.size.width - 15])];
    
    question.textColor = RGBCOLOR(60, 60, 60, 1);
    
    question.numberOfLines = 0;
    
    question.text = entity.title;
    
    [cell addSubview:question];
    
    float optionHight = 0;
    
    NSArray *optionArr = [entity.options componentsSeparatedByString:@";"];
    
    if ([entity.type_id isEqualToString:@"0"]) {
        
        for (int i = 0 ; i < optionArr.count; i ++) {
            
            QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:entity.subject_id type:[entity.type_id intValue] answer:[NSString stringWithFormat:@"%d",i]];
            radio.frame = CGRectMake(20, question.frame.size.height + 5 + optionHight, cell.frame.size.width - 25, [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5);
            radio.titleLabel.numberOfLines = 0;
            [radio setTitle:optionArr[i] forState:UIControlStateNormal];
            [radio setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
            [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [cell addSubview:radio];
            
            if([[answerMuDic allKeys] containsObject:entity.subject_id]) {
                
                if ([[answerMuDic objectForKey:entity.subject_id] isEqualToString:optionArr[i]]) {
                    
                    radio.checked = YES;
                }else{
                    radio.checked = NO;
                }
            }
            optionHight = optionHight + [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5;
        }
        
    }else if ([entity.type_id isEqualToString:@"1"]){
        
        for (int i = 0 ; i < optionArr.count; i ++) {
            QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:[NSString stringWithFormat:@"%@+%@",[[NSUUID UUID] UUIDString],entity.subject_id] type:[entity.type_id intValue] answer:[NSString stringWithFormat:@"%d",i]];
            radio.frame = CGRectMake(20, question.frame.size.height + 5 + optionHight, cell.frame.size.width - 25, [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5);
            radio.titleLabel.numberOfLines = 0;
            [radio setTitle:optionArr[i] forState:UIControlStateNormal];
            [radio setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
            [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [cell addSubview:radio];
            
            
            if([[answerMuDic allKeys] containsObject:entity.subject_id]) {
                
                NSArray *right_answerArr = [[answerMuDic objectForKey:entity.subject_id] componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < right_answerArr.count; j ++) {
                    
                    if ([right_answerArr[j] isEqualToString:optionArr[i]]) {
                        
                        radio.checked = YES;
                        
                    }else{
                        //                        radio.checked = NO;
                    }
                    
                }

                
//                if ([[answerMuDic objectForKey:entity.subject_id] rangeOfString:optionArr[i]].location != NSNotFound) {
//                    
//                    radio.checked = YES;
//                }else{
//                    radio.checked = NO;
//                }
            }
            optionHight = optionHight + [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5;
        }
        
    }
    
    cellHeight = optionHight + question.frame.size.height + 5;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated{
    
}

#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId type:(int)type answer:(NSString *)answer{
    
    //    NSLog(@"did selected radio:%@ groupId:%@ type:%d answer:%@", radio.titleLabel.text, groupId, type, answer);
    
    if (type == 0) {
        
        [answerMuDic setObject:radio.titleLabel.text forKey:[NSString stringWithFormat:@"%d",[groupId intValue]]];
        
    }else if (type == 1){
        
        NSArray *array = [groupId componentsSeparatedByString:@"+"]; //从字符A中分隔成2个元素的数组
        
        if ([[answerMuDic allKeys] containsObject:[NSString stringWithFormat:@"%d",[array[1] intValue]]]){
            
            [answerMuDic setObject:[NSString stringWithFormat:@"%@,%@",[answerMuDic objectForKey:[NSString stringWithFormat:@"%d",[array[1] intValue]]],radio.titleLabel.text] forKey:[NSString stringWithFormat:@"%d",[array[1] intValue]]];
            
            
        }else{
            
            [answerMuDic setObject:radio.titleLabel.text forKey:[NSString stringWithFormat:@"%d",[array[1] intValue]]];
            
        }
        
        
    }else if (type == 2){
        
        [answerMuDic setObject:radio.titleLabel.text forKey:[NSString stringWithFormat:@"%d",[groupId intValue]]];
        
    }else{
        
    }
    
}

- (void)didDeselectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId type:(int)type answer:(NSString *)answer{
    
    NSLog(@"did selected radio:%@ groupId:%@ type:%d answer:%@", radio.titleLabel.text, groupId, type, answer);
    
    NSArray *array = [groupId componentsSeparatedByString:@"+"]; //从字符A中分隔成2个
    NSString *answerStr = [answerMuDic objectForKey:[NSString stringWithFormat:@"%d",[array[1] intValue]]];
    
    NSArray *answerArr = [answerStr componentsSeparatedByString:@","];
    
    NSMutableArray *answerMuarr = [NSMutableArray arrayWithArray:answerArr];
    
    for (int i = 0; i< answerMuarr.count; i++) {
        
        if ([answerMuarr[i] isEqualToString:radio.titleLabel.text] && [answerMuarr[i] length] > 0) {
            
            [answerMuarr removeObject:answerMuarr[i]];
            
        }else{
            
        }
    }
    if ([answerMuarr count] == 0) {
        answerStr = @"";
    }else{
        
        answerStr = [answerMuarr componentsJoinedByString:@","];
    }
    
    
    //    answerStr = [answerStr stringByReplacingOccurrencesOfString:radio.titleLabel.text withString:@""];
    
    //去除字符串中多余的逗号
    NSArray *parts = [answerStr componentsSeparatedByString:@","];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    NSString *ResultStr = [filteredArray componentsJoinedByString:@","];
    
    [answerMuDic setObject:ResultStr forKey:[NSString stringWithFormat:@"%d",[array[1] intValue]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
