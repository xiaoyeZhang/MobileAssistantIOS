//
//  Exam_history_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Exam_history_DetailViewController.h"
#import "MBProgressHUD.h"
#import "Exam_History_DetailEntity.h"
#import "QRadioButton.h"

@interface Exam_history_DetailViewController ()<MBProgressHUDDelegate>
{
    UIButton *submitBtn;
    MBProgressHUD *HUD;
    float cellHeight;
    NSMutableArray *MuArr;
    NSMutableArray *MuArrtmp;
    NSMutableDictionary *answerMuDic;//答案的字典
}
@end

@implementation Exam_history_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"历史试卷";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    submitBtn = [self setNaviRightBtnWithTitle:@"只看错题"];
    
    submitBtn.frame = CGRectMake(0, 0, 100, 44);
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cellHeight = 200;
    
    answerMuDic = [[NSMutableDictionary alloc]init];
    
    MuArr = [[NSMutableArray alloc]init];
    MuArrtmp = [[NSMutableArray alloc]init];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClicked:(UIButton *)sender{

    [MuArr removeAllObjects];
    
    if ([submitBtn.titleLabel.text isEqualToString:@"只看错题"]) {
        
        [submitBtn setTitle:@"全部" forState:UIControlStateNormal];
        for (Exam_History_DetailEntity *entity in MuArrtmp) {
            
            if ([entity.is_right intValue] == 0) {
                [MuArr addObject:entity];
            }
            
        }
        
    }else if ([submitBtn.titleLabel.text isEqualToString:@"全部"]){
        
        [submitBtn setTitle:@"只看错题" forState:UIControlStateNormal];
        
        for (Exam_History_DetailEntity *entity in MuArrtmp) {
            
            [MuArr addObject:entity];
        }
        
    }
    


    [self.tableView reloadData];
    
}

- (void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"m_exam_history_detail", @"method",
                           self.entity.answer_id, @"answer_id",
                           nil];
    [service getNetWorkData:param Successed:^(id entity) {
        
        NSNumber *statee = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [statee intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                Exam_History_DetailEntity *entity = [[Exam_History_DetailEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                if (entity.right_answer.length > 0) {
                    
                    [answerMuDic setObject:entity.right_answer forKey:entity.subject_id];
                
                }
                [MuArr addObject:entity];
                [MuArrtmp addObject:entity];
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
    Exam_History_DetailEntity *entity = [MuArr objectAtIndex:indexPath.row];
    
    NSString *errorStr = @"(错误)";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",entity.title,errorStr]];
    
    UILabel *question = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 15, [self heightForString:[str string] fontSize:17 andWidth:self.view.frame.size.width - 15])];
    
    question.textColor = RGBCOLOR(60, 60, 60, 1);
    
    question.numberOfLines = 0;
    
    question.text = entity.title;
    
    [cell addSubview:question];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(entity.title.length, errorStr.length)];
    
    NSArray *optionArr = [entity.options componentsSeparatedByString:@";"];
    
    float optionHight = 0;
    
    if ([entity.type_id isEqualToString:@"0"]) {
        
        for (int i = 0 ; i < optionArr.count; i ++) {
            
            QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:entity.subject_id type:[entity.type_id intValue] answer:[NSString stringWithFormat:@"%d",i]];
            radio.userInteractionEnabled=NO;
            radio.frame = CGRectMake(20, question.frame.size.height + 5 + optionHight, cell.frame.size.width - 25, [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5);
            radio.titleLabel.numberOfLines = 0;
            [radio setTitle:optionArr[i] forState:UIControlStateNormal];
            [radio setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
            [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [cell addSubview:radio];
            
//            if ([[answerMuDic objectForKey:entity.subject_id] isEqualToString:optionArr[i]]) {
//                
//                [radio setImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateNormal];
//                
//            }else if ([entity.select_answer isEqualToString:optionArr[i]] && ![[answerMuDic objectForKey:entity.subject_id] isEqualToString:entity.select_answer]){
//                
//                 [radio setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
//                
//            }
            
            if([[answerMuDic allKeys] containsObject:entity.subject_id]) {
                
                if ([entity.select_answer rangeOfString:optionArr[i]].location != NSNotFound) {
                    
                    radio.checked = YES;
                    
                }else{
                    
                    radio.checked = NO;
                    
                }
            }
            
            if ([entity.is_right intValue] == 0) {
                
                question.attributedText = str;
             
                if ([entity.right_answer isEqualToString:optionArr[i]]) {
                    
                    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",optionArr[i]]];
                    
                    // 2.添加表情图片
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    // 表情图片
                    attch.image = [UIImage imageNamed:@"ic_right"];
                    // 设置图片大小
                    attch.bounds = CGRectMake(0, -5, 20, 20);
                    
                    // 创建带有图片的富文本
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [attri insertAttributedString:string atIndex:[optionArr[i] length] + 1];// 插入某个位置
                    
                    // 用label的attributedText属性来使用富文本
                    [radio setAttributedTitle:attri forState:UIControlStateNormal];
                    
                    
                }else{
                    
                }
            }
            
            optionHight = optionHight + [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5;
            
        }
        
    }else if ([entity.type_id isEqualToString:@"1"]){
        
        for (int i = 0 ; i < optionArr.count; i ++) {
            QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:[NSString stringWithFormat:@"%@+%@",[[NSUUID UUID] UUIDString],entity.subject_id] type:[entity.type_id intValue] answer:[NSString stringWithFormat:@"%d",i]];
            radio.userInteractionEnabled=NO;
            radio.frame = CGRectMake(20, question.frame.size.height + 5 + optionHight, cell.frame.size.width - 25, [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5);
            radio.titleLabel.numberOfLines = 0;
            [radio setTitle:optionArr[i] forState:UIControlStateNormal];
            [radio setTitleColor:RGBCOLOR(60, 60, 60, 1) forState:UIControlStateNormal];
            [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [cell addSubview:radio];
            
            optionHight = optionHight + [self heightForString:optionArr[i] fontSize:15 andWidth:cell.frame.size.width - 25] + 5;
            if([[answerMuDic allKeys] containsObject:entity.subject_id]) {
                
                if ([entity.select_answer rangeOfString:optionArr[i]].location != NSNotFound) {

                    radio.checked = YES;
                
                }else{
                
                    radio.checked = NO;
                
                }
            }
            
            if ([entity.is_right intValue] == 0) {
                
                question.attributedText = str;
            

                NSArray *right_answerArr = [entity.right_answer componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < right_answerArr.count; j ++) {
                    
                    if ([right_answerArr[j] isEqualToString:optionArr[i]]) {
                        
                        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",optionArr[i]]];
                        
                        // 2.添加表情图片
                        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                        // 表情图片
                        attch.image = [UIImage imageNamed:@"ic_right"];
                        // 设置图片大小
                        attch.bounds = CGRectMake(0, -5, 20, 20);
                        
                        // 创建带有图片的富文本
                        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                        [attri insertAttributedString:string atIndex:[optionArr[i] length] + 1];// 插入某个位置
                        
                        // 用label的attributedText属性来使用富文本
                        [radio setAttributedTitle:attri forState:UIControlStateNormal];
                        
                        
                    }else{
                        
                    }
                    

                }
                
                
                
            }else if ([entity.is_right intValue] == 1){
                
            }else{
                
            }
            
        }
        
    }
    
    cellHeight = optionHight + question.frame.size.height + 5;
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
