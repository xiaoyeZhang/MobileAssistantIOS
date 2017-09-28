//
//  Business_AddclientViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/11.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_AddclientViewController.h"
#import "ContactTableViewCell.h"
#import "Business_ContactAddViewController.h"
#import "Business_ContactDetailViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UIAlertView+Blocks.h"
#import "UserEntity.h"
#import "ContactEntity.h"
#import "GroupContact.h"

@interface Business_AddclientViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *selectArray;
    NSString *str;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_AddclientViewController

- (void)dealloc
{
    [refreshHeader free];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textfile.returnKeyType = UIReturnKeyDone;
    [self.textfile addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    selectArray = [[NSMutableArray alloc]init];
    self.arrayContact = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    self.title = @"集团成员列表";
    self.output.alpha = 0;
    [self addRefreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.arrayContact removeAllObjects];
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableview;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf doTask];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayContact count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    GroupContact *entity = [self.arrayContact objectAtIndex:indexPath.row];
    cell.labelName.text = entity.CustName;
    cell.labelSubName.text = entity.ServiceNum;
    cell.imageView.image = [UIImage imageNamed:@"commonclient"];
    cell.IconImage.image = [UIImage imageNamed:@"c_right"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Business_ContactDetailViewController *vc = [[Business_ContactDetailViewController alloc]init];
    vc.entity = [self.arrayContact objectAtIndex:indexPath.row];
    vc.CompEntity = self.entity;
    vc.power = self.power;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_GetGroupMember",
                           @"user_id":userEntity.user_id,
                           @"GroupId":self.entity.num,
                           @"user_num":userEntity.num,
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            [self.arrayContact removeAllObjects];
            [self.arrayCustomerTemp removeAllObjects];
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                GroupContact *entity = [[GroupContact alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayContact addObject:entity];
                [self.arrayCustomerTemp addObject:entity];
            }
            [self.tableview reloadData];
      
        }
        else
        {
            iToast *toast = [iToast makeText:@"暂无数据"];
            [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
            [toast setDuration:500];
            [toast show:iToastTypeNotice];
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [HUD hide:YES];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
}

//- (void)aleartShow:(NSString *)message{
//    
//    if ([message isEqualToString:@"似乎已断开与互联网的连接。"]) {
//        ALERT_ERR_MSG(@"无法连接到后台服务器，请检查网络!");
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 1;
//        }];
//        
//        timer1 = [NSTimer scheduledTimerWithTimeInterval:1
//                                                  target:self
//                                                selector:@selector(show)
//                                                userInfo:nil
//                                                 repeats:YES];
//        [timer1 fire];
//    }
//}
//
//- (void)show{
//    
//    if (count++ >= 2) {
//        [timer1 invalidate];
//        count = 0;
//        
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}

-(void)loadData{
    
    [self getData];
    
}

- (void) getData
{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    
    NSDictionary *dict1 = @{@"method":@"whole_province",
                            @"oicode":@"checkCanEditGroup",
                            @"GroupId":self.entity.num,
                            @"user_num":userEntity.num,
                            @"user_id":userEntity.user_id,
                            };
    
    [service getNetWorkData:dict1  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            self.power = YES;
            
        }else if(state == -1){
            self.power = NO;
            self.addContact.hidden = YES;
        }

    } Failed:^(int errorCode, NSString *message) {

    }];
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textfile resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {

    [self.view endEditing:YES];
    if (self.textfile.text.length > 0) {
//        if (![str isEqualToString:self.textfile.text]) {
            [selectArray removeAllObjects];
            for (int i = 0; i < [self.arrayCustomerTemp count]; i++) {
                GroupContact *entity = [self.arrayCustomerTemp objectAtIndex:i];
                
                if ([entity.ServiceNum rangeOfString:self.textfile.text].location != NSNotFound) {
                    [selectArray addObject:entity];
                }
            }
            if ([selectArray count] == 0) {
                
            }
            self.arrayContact = selectArray;
            [self.tableview reloadData];
//        }else{
//            
//        }
        str = self.textfile.text;
    }else{
        
        [self.arrayContact removeAllObjects];
        [self Refresh];
    }
    
}

- (IBAction)addAddclient:(UIButton *)sender {

    Business_ContactAddViewController *vc = [[Business_ContactAddViewController alloc]init];
    vc.Compentity = self.entity;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [refreshHeader beginRefreshing];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
}

- (void)Refresh{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
