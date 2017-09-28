//
//  Exam_historylistViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/27.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Exam_historylistViewController.h"
#import "MBProgressHUD.h"
#import "Examination_SeconTableViewCell.h"
#import "Exam_historylistEntity.h"
#import "Exam_history_DetailViewController.h"

@interface Exam_historylistViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UserEntity *userEntity;
}
@end

@implementation Exam_historylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"历史试卷";
    
    userEntity = [UserEntity sharedInstance];
    
    self.arrayCustomerTemp = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getExm_history_List];

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
    
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Examination_SeconTableViewCell";
    Examination_SeconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    cell.end_time.alpha = 0;
    cell.task_time.alpha = 0;
    
    Exam_historylistEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.titleLable.text = entity.title;
    
    cell.start_time.text = [NSString stringWithFormat:@"考试时间：%@",entity.time];
    
    NSString *numStr = entity.score;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@分",numStr]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, numStr.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, numStr.length)];

            
    cell.Test_scores.attributedText = str;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    Exam_historylistEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    Exam_history_DetailViewController *vc = [[Exam_history_DetailViewController alloc]init];
    
    vc.entity = entity;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getExm_history_List{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_exam_history",
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Exam_historylistEntity *entity = [[Exam_historylistEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCustomerTemp addObject:entity];
            }
            
        }
        else
        {
            
            
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
        
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
