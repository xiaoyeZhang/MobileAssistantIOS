//
//  Matching_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/15.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Matching_ListViewController.h"
#import "Matching_ListTableViewCell.h"
#import "Matching_SectgionView.h"
#import "MBProgressHUD.h"
#import "MatchingEntity.h"

@interface Matching_ListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableDictionary *selectedDic;//二级列表是否展开状态
    NSMutableArray *One_SectonArr;
    NSMutableArray *Two_SectonArr;
}
@end

@implementation Matching_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行资金入账匹配";
    
    One_SectonArr = [[NSMutableArray alloc]init];
    Two_SectonArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.backgroundColor = RGBA(242, 242, 242, 1);
    self.view.backgroundColor = RGBA(242, 242, 242, 1);

    if (!selectedDic) {
        selectedDic = [[NSMutableDictionary alloc]init];
    }
    
    [selectedDic setObject:@"1" forKey:@"0"];
    [selectedDic setObject:@"1" forKey:@"1"];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return One_SectonArr.count;
    }else{
        return Two_SectonArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 2;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        return 110;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier1 = @"Matching_ListTableViewCell";
    
    Matching_ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.clipsToBounds = YES;
        cell.ArrearsLabel.textColor = [UIColor redColor];
    }
    
    NSString *str1;
    NSString *str2;
    if (indexPath.section == 0) {
        MatchingEntity *entity = [One_SectonArr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = entity.company_name;
        str1 = [NSString stringWithFormat:@"资金入账:%@",entity.receive_num];
        str2 = [NSString stringWithFormat:@"挂账:%@",entity.target_num];
        cell.timeLabel.text = entity.date_time;
        cell.ArrearsLabel.text = [NSString stringWithFormat:@"欠款:%@",entity.matching_num];
        
    }else{
        
        MatchingEntity *entity = [Two_SectonArr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = entity.company_name;
        str1 = [NSString stringWithFormat:@"资金入账:%@",entity.receive_num];
        str2 = [NSString stringWithFormat:@"发票:%@",entity.target_num];
        cell.timeLabel.text = entity.date_time;
        cell.ArrearsLabel.text = [NSString stringWithFormat:@"欠款:%@",entity.matching_num];
        
    }
    
 
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@     %@",str1,str2]];
    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length - str3.length,  str3.length)];
    
    cell.TwoLabel.attributedText = str;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Matching_SectgionView *view = [[[NSBundle mainBundle] loadNibNamed:@"Matching_SectgionView" owner:nil options:nil] firstObject];
    
    view.sectionName.textColor = RGBA(65, 65, 65, 1);
    
    view.backgroundColor = RGBA(234, 234, 234, 1);
    if(section == 0){
          view.sectionName.text = @"银行入账资金与挂账匹配情况";
    }else{
          view.sectionName.text = @"银行入账资金与发票匹配情况";
    }
  
    view.tag = section;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTop:)];
    singleRecognizer.numberOfTapsRequired = 1;//点击的次数。＝1 单击
    [singleRecognizer setNumberOfTapsRequired:1];//1个手指操作
    [view addGestureRecognizer:singleRecognizer];//添加一个手势监测
    
    return view;
}
- (void)SingleTop:(UITapGestureRecognizer *)recognizer{
    
    NSInteger didsection = recognizer.view.tag;

    NSString *key = [NSString stringWithFormat:@"%ld",(long)didsection];
    
    if (![selectedDic objectForKey:key]) {
        [selectedDic setObject:@"1" forKey:key];
    }else{
        [selectedDic removeObjectForKey:key];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didsection] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic = @{
                          @"method":@"matching_list",
                          @"user_id":userEntity.user_id,
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"]) {

            
        }else if ([strState isEqualToString:@"1"]){
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"books"];
            for (NSDictionary* attributes in array) {
                MatchingEntity *entity = [[MatchingEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [One_SectonArr addObject:entity];
            }
            

        }else if ([strState isEqualToString:@"2"]){
            
            NSMutableArray *array = [[entity objectForKey:@"content"] objectForKey:@"bills"];
            for (NSDictionary* attributes in array) {
                MatchingEntity *entity = [[MatchingEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [Two_SectonArr addObject:entity];
            }
            
        }else if ([strState isEqualToString:@"3"]){
            
            NSMutableArray *books_Array = [[entity objectForKey:@"content"] objectForKey:@"books"];
            for (NSDictionary* attributes in books_Array) {
                MatchingEntity *entity = [[MatchingEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [One_SectonArr addObject:entity];
            }
            
            NSMutableArray *bills_Array = [[entity objectForKey:@"content"] objectForKey:@"bills"];
            for (NSDictionary* attributes in bills_Array) {
                MatchingEntity *entity = [[MatchingEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [Two_SectonArr addObject:entity];
            }
            
        }else{
            
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
