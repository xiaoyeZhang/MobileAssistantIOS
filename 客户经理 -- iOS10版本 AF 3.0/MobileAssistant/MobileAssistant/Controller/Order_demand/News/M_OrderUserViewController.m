//
//  M_OrderUserViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/18.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_OrderUserViewController.h"
#import "MBProgressHUD.H"

@interface M_OrderUserViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation M_OrderUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下级执行人";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    if ([_type_id isEqualToString:@"1"]) {//详情进来
        
        
    }else{
        
        self.arrayCutomer = [NSMutableArray array];
        
        [self loadData];
        
    }
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCutomer.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    CGSize size = [cell.textLabel sizeThatFits:CGSizeMake(cell.textLabel.frame
//                                                          .size.width, MAXFLOAT)];
//    if (size.height == 0) {
//        return 50;
//    }
//
//    return 34 + size.height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = [[self.arrayCutomer objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(successM_OrderUserDelegate:)]){
        
        
        [_delegate successM_OrderUserDelegate:[self.arrayCutomer objectAtIndex:indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData];
}

- (void)getData{
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic;
    if (_Type.length > 0) {
        
        dic = @{@"method":@"m_get_order_user_list",
                @"dep_id":userEntity.dep_id,
                @"type_id":_Type};
    
    }else{
        
        dic = @{@"method":@"m_get_order_user_list",
                @"order_id":_order_id};
    }

    
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                [self.arrayCutomer addObject:dic];
                
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
