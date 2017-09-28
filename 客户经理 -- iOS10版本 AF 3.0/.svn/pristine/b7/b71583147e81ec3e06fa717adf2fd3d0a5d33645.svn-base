//
//  No_visit_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/3.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "No_visit_listViewController.h"
#import "Ooe_LabelTableViewCell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "No_visit_listEntity.h"
#import "No_visit_baselistViewController.h"

@interface No_visit_listViewController ()<MBProgressHUDDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_fooder;
    MBProgressHUD *HUD;
    NSMutableArray *deleteArr;
    
    UIButton *rightBtn;

}

@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation No_visit_listViewController

- (void)dealloc{
    
    [_header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deleteArr = [[NSMutableArray alloc]init];
    
    self.tableView.editing = YES;
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"选择客户经理";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    rightBtn = [self setNaviRightBtnWithTitle:@"确定"];
    
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf.arrayCutomer removeAllObjects];
        
        [weakSelf getData];
    };
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [deleteArr removeObject:self.arrayCutomer[indexPath.row]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [deleteArr addObject:[self.arrayCutomer objectAtIndex:indexPath.row]];
    
//    No_visit_listEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    
//    No_visit_baselistViewController *vc = [[No_visit_baselistViewController alloc]init];
//    
//    vc.num = entity.num;
//    vc.user_id = entity.user_id;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtnClicked:(UIButton *)sender{
    
    [_tcVC setCustomer:deleteArr];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"method":@"userinfo",
                           @"dep_id":userEntity.dep_id,
                           @"type_id":userEntity.type_id,
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
        [_header endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"无法连接到服务器"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:5000];
        [toast show:iToastTypeNotice];
        
        [HUD hide:YES];
        [_header endRefreshing];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
