//
//  Integral_rankingViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/9.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Integral_rankingViewController.h"
#import "Integral_rankingListTableViewCell.h"
#import "Integral_rankingListHeadView.h"
#import "MBProgressHUD.h"
#import "Exam_study_listEntity.h"

@interface Integral_rankingViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UserEntity *userEntity;
    MBProgressHUD *HUD;
}
@end

@implementation Integral_rankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分排名";
    
    userEntity = [UserEntity sharedInstance];
    
    self.arrayCustomerTemp = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *searchBtn = [self setNaviRightBtnWithTitle:@"筛选"];
//    
//    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getExm_study_List];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//筛选
- (void)searchBtnClicked:(id)sender{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCustomerTemp.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    Integral_rankingListHeadView *view = [[[NSBundle mainBundle] loadNibNamed:@"Integral_rankingListHeadView" owner:nil options:nil] firstObject];
    view.backgroundColor = RGBA(231, 231, 231, 1);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Integral_rankingListTableViewCell";
    Integral_rankingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBA(246, 246, 246, 1);

    }
    
    Exam_study_listEntity *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = entity.name;
    cell.companyLabel.text = entity.dep_name;
    
    if (indexPath.row == 0) {
        cell.rankingLabel.alpha = 0;
        cell.image.image = [UIImage imageNamed:@"one"];
    }else if (indexPath.row == 1){
        cell.rankingLabel.alpha = 0;
        cell.image.image = [UIImage imageNamed:@"银牌"];
    }else if (indexPath.row == 2){
        cell.rankingLabel.alpha = 0;
        cell.image.image = [UIImage imageNamed:@"铜牌"];
    }else{
        cell.image.alpha = 0;
        cell.rankingLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }

    cell.integralLabel.text = entity.point;
    
    return cell;
}

- (void)getExm_study_List{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"m_exam_study_list",
                           @"user_id":userEntity.user_id,
                           @"name":self.searchTextFile.text,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state intValue] >= 0) {
            

            if ([state intValue] > 0) {
                
                self.rank_numLabel.text = [NSString stringWithFormat:@"你当前排在第%@位",state];
                
            }
            
            [self.arrayCustomerTemp removeAllObjects];
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                Exam_study_listEntity *entity = [[Exam_study_listEntity alloc] init];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
 
    [self getExm_study_List];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
