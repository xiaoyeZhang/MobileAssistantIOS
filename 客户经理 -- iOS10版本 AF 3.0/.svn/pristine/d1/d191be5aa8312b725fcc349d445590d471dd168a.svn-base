//
//  Birthday_departmentViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/10.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Birthday_departmentViewController.h"
#import "MBProgressHUD.h"
#import "NewsTableViewCell.h"

@interface Birthday_departmentViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *arrayCutomer;
}

@end

@implementation Birthday_departmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"集团列表";
    
    arrayCutomer = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    [self getData];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    
    
    cell.labelTitle.text = [[arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.labelDate.text = @"";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(self.delegate&&[self.delegate respondsToSelector:@selector(successBirthday_departmentdelegate:)]){
        
        NSDictionary *dict = @{
                               @"dep_id":[[arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"dep_id"],
                               };
        
        [_delegate successBirthday_departmentdelegate:dict];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)getData{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"get_dep_list",
                           @"user_id":userEntity.user_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {

            arrayCutomer = [entity objectForKey:@"content"];
            
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
