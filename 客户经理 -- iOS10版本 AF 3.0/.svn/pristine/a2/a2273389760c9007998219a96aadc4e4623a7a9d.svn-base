//
//  Examination_SeconViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/8.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Examination_SeconViewController.h"
#import "Examination_SeconTableViewCell.h"
#import "Examination_DetailViewController.h"
#import "MBProgressHUD.h"
#import "Exam_listEntity.h"

@interface Examination_SeconViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
@end

@implementation Examination_SeconViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的试卷";
    
    userEntity = [UserEntity sharedInstance];
    
    self.arrayCustomerTemp = [NSMutableArray array];
    
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
    [self getExmList];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Examination_SeconTableViewCell";
    Examination_SeconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    Exam_listEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.titleLable.text = entity.title;
    
    NSString *start_time;
    NSString *end_time;
    
    if ([entity.can_resit intValue] == 1) {
        
        start_time = entity.resit_start_time;
        end_time = entity.resit_end_time;
        
    }else{
        
        start_time = entity.start_time;
        end_time = entity.end_time;
    
    }
    
    cell.start_time.text = [NSString stringWithFormat:@"考试开始时间：%@",start_time];
    cell.end_time.text = [NSString stringWithFormat:@"考试结束时间：%@",end_time];
    cell.task_time.text = [NSString stringWithFormat:@"考试时长：%@分钟",entity.exam_time];
    
//    if ([entity.first_result intValue] != -1) {
//        
////        NSString *numStr;
////        if ([entity.first_result intValue] < 60 && [entity.second_result intValue] != -1) {
////            
////            numStr = entity.second_result;
////            
////        }else{
////            
////            numStr = entity.first_result;
////        
////        }
////        
////        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@分",numStr]];
////        
////        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, numStr.length)];
////        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, numStr.length)];
////        
//        if ([entity.second_result intValue] == -1) {
//            
//            cell.Test_scores.text = @"(补考)";
//            
//        }else{
//
//            cell.Test_scores.text = @"(不可考)";
//
//        }
//        
//    }else{
//        
//        cell.Test_scores.text = @"(正常)";
// 
//    }
    
    if ([entity.can_answer intValue] == 0) {
        
        if ([entity.can_resit intValue] == 0) {
            cell.Test_scores.text = @"(不可考)";
        }else{
            cell.Test_scores.text = @"(补考)";
        }
        
    }else if ([entity.can_answer intValue] == 1){
        
        cell.Test_scores.text = @"(正常)";
        
    }else{
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Exam_listEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];

    if ([entity.can_answer intValue] == 1 || [entity.can_resit intValue] == 1) {
    
        Examination_DetailViewController *vc = [[Examination_DetailViewController alloc]init];
        
        vc.entity = entity;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
}

- (void)getExmList{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_exam_list",
                           @"user_id":userEntity.user_id,
                           @"dep_id":userEntity.dep_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            [self.arrayCustomerTemp removeAllObjects];
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Exam_listEntity *entity = [[Exam_listEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCustomerTemp addObject:entity];
            }
            
        }
        else
        {
            

        }
        
        [self.tableview reloadData];
        
        [HUD hide:YES];

    } Failed:^(int errorCode, NSString *message) {

        [HUD hide:YES];
        
    }];
    
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    
    [self getExmList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
