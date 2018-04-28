//
//  Policy_distributionListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2018/3/23.
//  Copyright © 2018年 avatek. All rights reserved.
//

#import "Policy_distributionListViewController.h"
#import "UserEntity.h"
#import "strategy_listEntity.h"
#import "Policy_distribtionDetailViewController.h"
#import "strategy_listTableViewCell.h"
#import "MBProgressHUD.h"

@interface Policy_distributionListViewController ()<MBProgressHUDDelegate>
{
    NSMutableDictionary *MuDic;
    UserEntity *userEntity;
    
    MBProgressHUD *HUD;
}

@property (assign,nonatomic) int state_id;
@property (copy,nonatomic)  NSString *type_id;
@property (copy,nonatomic)  NSString *s_id;

@property (strong,nonatomic)  NSMutableArray *list_Arr;

@end

@implementation Policy_distributionListViewController

static BOOL isDone = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _state_id = 1;
    
    self.navigationItem.title = @"策略集中分发";
    
    userEntity = [UserEntity sharedInstance];
    
    self.list_Arr = [[NSMutableArray alloc]init];
    
    MuDic = [NSMutableDictionary dictionary];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.type_id = @"-1";
    self.s_id = @"-1";
    
    NSDictionary *dict = @{
                           @"type_id":self.type_id,
                           @"s_id":self.s_id
                           };
    
    [self.list_Arr addObject:dict];
    
    [self getData:self.type_id addS_ID:self.s_id];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    if (self.list_Arr.count == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if (!isDone) {
            return;
        }
        
        isDone = NO;
        
        [self.list_Arr removeLastObject];
        
        NSDictionary *dict = [self.list_Arr lastObject];
        
        _type_id = dict[@"type_id"];
        _s_id = dict[@"s_id"];
        
        [self getData:_type_id addS_ID:_s_id];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[MuDic objectForKey:@(_state_id)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"strategy_listTableViewCell";
    strategy_listTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];

        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    strategy_listEntity *entity = [[MuDic objectForKey:@(_state_id)] objectAtIndex:indexPath.row];
    
    
    if ([entity.type_id isEqualToString:@"9"]) {
        
        NSArray *Arr= [entity.name componentsSeparatedByString:@"@"];
        
        cell1.titleLabel.text = [NSString stringWithFormat:@"%@",Arr[0]];
        cell1.subTitle.text = [NSString stringWithFormat:@"结束时间：%@",Arr[1]];
        cell1.numLabel.text = entity.num;
        
        return cell1;
    }else{
        
        cell.textLabel.text = entity.name;
        
        cell.detailTextLabel.text = entity.num;

        cell.detailTextLabel.textColor = [UIColor redColor];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    strategy_listEntity *entity = [[MuDic objectForKey:@(_state_id)] objectAtIndex:indexPath.row];

    if (![entity.type_id isEqualToString:@"9"]) {
        
        NSDictionary *dict = @{
                               @"type_id":entity.type_id,
                               @"s_id":entity.s_id
                               };
        
        [self.list_Arr addObject:dict];
        
        [self getData:entity.type_id addS_ID:entity.s_id];

    }else{
        
        Policy_distribtionDetailViewController *vc = [[Policy_distribtionDetailViewController alloc]init];
        
        vc.name = [[entity.name componentsSeparatedByString:@"@"] objectAtIndex:0];
        
        vc.s_id = entity.s_id;
        vc.type_id = entity.type_id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)getData:(NSString *)type_id addS_ID:(NSString *)s_id {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    NSDictionary *dict = @{@"method":@"strategy_list",
                           @"user_id":userEntity.user_id,
                           @"type_id":type_id,
                           @"s_id":s_id
                           };
    

    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      _state_id = state;
                    
                      if (state == 9) {
                          
                      }else{
                          
                          NSMutableArray *array = [NSMutableArray array];
                          
                          if ([[entity objectForKey:@"content"] count] > 0) {
                              
                              for (NSDictionary* attributes in [entity objectForKey:@"content"]) {
                                  strategy_listEntity *entity = [[strategy_listEntity alloc] init];
                                  [entity setValuesForKeysWithDictionary:attributes];
                                  [array addObject:entity];
                              }
                              
                              [MuDic setObject:array forKey:@(_state_id)];
                              
                          }
                      }
                      
                      [self.tableView reloadData];
                      
                      [HUD hide:YES];
                      isDone = YES;
                  } Failed:^(int errorCode, NSString *message) {
                      
                      [self.list_Arr removeLastObject];
                      isDone = YES;
                      [HUD hide:YES];
                      
                  }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
