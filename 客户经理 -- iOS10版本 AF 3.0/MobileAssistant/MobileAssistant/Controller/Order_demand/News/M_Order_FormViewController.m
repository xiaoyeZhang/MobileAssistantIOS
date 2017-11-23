//
//  M_Order_FormViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/11/23.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_Order_FormViewController.h"
#import "MBProgressHUD.h"
#import "M_OrderFormEntity.h"

@interface M_Order_FormViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *arrayCutomer;
    NSString *message;
}
@end

@implementation M_Order_FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _methodEntity.title;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    arrayCutomer = [NSMutableArray array];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return arrayCutomer.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    
    M_OrderFormEntity *entity = [arrayCutomer objectAtIndex:indexPath.row];
    
    cell.textLabel.text = entity.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    M_OrderFormEntity *entity = [arrayCutomer objectAtIndex:indexPath.row];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (message.length > 0 ) {
        
        message = [message stringByAppendingFormat:@"/%@",entity.name];

    }else{
        
        message = entity.name;
    
    }
    
    if ([entity.type isEqualToString:@"1"]) {
        
        _Id = entity.Id;
        
        self.navigationItem.title = entity.name;
        
        [self getData];
        
    }else if ([entity.type isEqualToString:@"2"]){
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(successM_OrderFormDelegate:)]){
            
            NSDictionary *dic = @{@"message":message,
                                  @"name":_methodEntity.name};
            
            [_delegate successM_OrderFormDelegate:dic];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else{
        
    }
}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dic;
    
    dic = @{@"method":@"m_order_dep",
                @"user_id":userEntity.user_id,
                @"id":_Id,
                @"type":_methodEntity.name};
    
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            [arrayCutomer removeAllObjects];
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                M_OrderFormEntity *entity = [[M_OrderFormEntity alloc]init];
                
                entity = [entity initWithAttributes:dic];
                
                [arrayCutomer addObject:entity];
                
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

@end

