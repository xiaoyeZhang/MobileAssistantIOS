//
//  News_CustomerViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/3/24.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "News_CustomerViewController.h"
#import "News_CustomerTableViewCell.h"
#import "News_ProvinceVIP_CustomerListEntity.h"
#import "UserEntity.h"
#import "MBProgressHUD.h"

@interface News_CustomerViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSArray *data_source_additionArr;
    
}
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation News_CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择列表";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    data_source_additionArr = [self.data_source_addition componentsSeparatedByString:@";"];
    
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayCutomer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"News_CustomerTableViewCell";
    News_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:couponTableViewCellIdentifier owner:nil options:nil] firstObject];
        
    }
    if (self.dep_id.length == 0) {
        News_ProvinceVIP_CustomerListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row]
        ;
        
        cell.titleLabel.text = entity.title;
    }else{
        
        News_PtovinceVip_Next_CustomerEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row]
        ;
        
        cell.titleLabel.text = entity.name;
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_textFieldKey resignFirstResponder];
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dep_id.length == 0) {
         
        News_ProvinceVIP_CustomerListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

        for (int i = 0; i < data_source_additionArr.count; i ++) {

            [dic setObject:[entity.content objectForKey:data_source_additionArr[i]] forKey:data_source_additionArr[i]];
            
        }
        
        if ([self.delegate respondsToSelector:@selector(News_CustomerViewControllerViewController:didSelectCompany:)]) {
            [self.delegate News_CustomerViewControllerViewController:self didSelectCompany:dic];
        }
    }else{
        
        News_PtovinceVip_Next_CustomerEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(News_Next_CustomerViewControllerViewController:didSelectCompany:)]) {
            
            [self.delegate News_Next_CustomerViewControllerViewController:self didSelectCompany:entity];
            
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.data_source forKey:@"method"];
    [dic setObject:userEntity.user_id forKey:@"user_id"];
    [dic setValuesForKeysWithDictionary:self.dic];
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        for (NSDictionary *attributes in entity) {
            
            News_ProvinceVIP_CustomerListEntity *entity = [[News_ProvinceVIP_CustomerListEntity alloc]init];
            entity = [entity initWithAttributes:attributes];
            
            [self.arrayCutomer addObject:entity];
        }
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        
        [HUD hide:YES];
    }];

    
    
}

- (void)getData_Next{
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{
                          @"method":self.data_source,
                          @"dep_id":self.dep_id?self.dep_id:@""
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                News_PtovinceVip_Next_CustomerEntity *entity = [[News_PtovinceVip_Next_CustomerEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            }

        }
        
        [self.tableView reloadData];
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];

    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
