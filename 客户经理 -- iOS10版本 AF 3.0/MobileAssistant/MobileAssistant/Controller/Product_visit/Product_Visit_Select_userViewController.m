//
//  Peoduct_Visit_Select_userViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/7/20.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "Product_Visit_Select_userViewController.h"
#import "Ooe_LabelTableViewCell.h"
#import "MBProgressHUD.h"
@interface Product_Visit_Select_userViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSMutableArray *arrayCutomer;

@end

@implementation Product_Visit_Select_userViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"选择客户经理";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
}


//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Ooe_LabelTableViewCell";
    
    Ooe_LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    No_visit_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = entity.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addProduct_VisitViewController:didSelectUser:)]){
        
        No_visit_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
        
        [_delegate addProduct_VisitViewController:self didSelectUser:entity];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"userinfo",
                           @"dep_id":userEntity.dep_id,
//                           @"type_id":userEntity.type_id,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *arr = [entity valueForKey:@"content"];
            for (NSDictionary *Attributes in arr) {
                No_visit_listEntity *entity = [[No_visit_listEntity alloc]init];
                entity = [entity initWithAttributes:Attributes];
                
                [self.arrayCutomer addObject:entity];
            }
            
            
        }else{
            
            
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:5000];
            [toast show:iToastTypeNotice];
        }
        [self.tableView reloadData];
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:5000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
