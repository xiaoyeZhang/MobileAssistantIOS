//
//  Examination_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/9.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Examination_DetailViewController.h"
#import "QRadioButton.h"
#import "MBProgressHUD.h"
#import "TestScoresViewController.h"
#import "Exam_DetailEntity.h"

@interface Examination_DetailViewController ()<QRadioButtonDelegate,MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    MBProgressHUD *HUD;
    NSMutableArray *MuArr;
    float cellHeight;
    NSMutableDictionary *answerMuDic;//答案的字典
}

@end

@implementation Examination_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userEntity = [UserEntity sharedInstance];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 44);
    
    [backBtn setTitle:@"保存并返回" forState:UIControlStateNormal];
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self setNaviBarLeftView:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.title = [NSString stringWithFormat:@"%@:00",self.entity.exam_time];

    self.navigationItem.title = @"考试";
    
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    UIButton *submitBtn = [self setNaviRightBtnWithTitle:@"交卷"];
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cellHeight = 200;
    
    answerMuDic = [[NSMutableDictionary alloc]init];
    
    MuArr = [[NSMutableArray alloc]init];
    
    [self getData];
}

//提交并返回
- (void)backBtnClicked:(id)sender
{
    
    NSUserDefaults *answerMuDicDefaults = [NSUserDefaults standardUserDefaults];
    
    [answerMuDicDefaults setObject:answerMuDic forKey:self.entity.exam_id];
    
    [Examination_DetailViewController cancelPreviousPerformRequestsWithTarget:self];

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

    [Examination_DetailViewController cancelPreviousPerformRequestsWithTarget:self];

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
                           self.entity.exam_id, @"exam_id",
                           userEntity.user_id,@"user_id",
                           answerStr,@"answers",
                           self.entity.type_id,@"type_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state intValue] > 0) {
            
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[entity valueForKeyPath:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.entity.exam_id];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TestScoresViewController *vc = [[TestScoresViewController alloc]init];
            
            vc.Scores = [NSString stringWithFormat:@"%@",[entity valueForKeyPath:@"content"]];
            
            vc.type = @"0";
            
            [self.navigationController pushViewController:vc animated:YES];
            
//            }];
            
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
                           @"m_exam_detail", @"method",
                           self.entity.exam_id, @"exam_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *statee = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [statee intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            [self changeTime:[NSString stringWithFormat:@"%d",[self.entity.exam_time intValue]*60]];

            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Exam_DetailEntity *entity = [[Exam_DetailEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                [answerMuDic setObject:@"" forKey:entity.subject_id];
                [MuArr addObject:entity];
            }
            
            NSUserDefaults *answerMuDicDefaults = [NSUserDefaults standardUserDefaults];
            
            if([answerMuDicDefaults objectForKey:self.entity.exam_id]) {
                
                [answerMuDic setDictionary:[answerMuDicDefaults objectForKey:self.entity.exam_id]];
                
            }else{
                
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
    
    NSArray *optionArr = [entity.options componentsSeparatedByString:@";"];
    
    float optionHight = 0;
    
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

- (void)changeTime:(NSString *)Time{
    
    if ([Time integerValue] <= 0){
        
        self.navigationItem.title = [NSString stringWithFormat:@"0:00"];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"考试时间到！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            [self submitAnswer];
            
        }];
        
    }else{
        
        int min = [Time intValue]/60 ;
        int second = [Time integerValue]%60;
        
        [self performSelector:@selector(changeTime:) withObject:[NSNumber numberWithInt:[Time intValue]-1] afterDelay:1];
        
        if(second < 10){
            
            self.navigationItem.title = [NSString stringWithFormat:@"%d:0%d",min,second];

        }else{
            
            self.navigationItem.title = [NSString stringWithFormat:@"%d:%d",min,second];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
