//
//  Business_Coloring_RingListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/28.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Coloring_RingListViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "MJRefresh.h"
#import "Colorint_RingModel.h"
#import "ContactTableViewCell.h"
#import "Business_Add_Coloring_RingViewController.h"
#import "Business_Coloring_RingDetailViewController.h"

@interface Business_Coloring_RingListViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    MJRefreshHeaderView *refreshHeader;
    NSMutableArray *selectArray;
    NSString *str;
    NSString *BillId;
    NSTimer* timer1;
    int count;
}

@end

@implementation Business_Coloring_RingListViewController

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
    
    self.textFieldKey.returnKeyType = UIReturnKeyDone;
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.arrayCutomer = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];
    selectArray = [[NSMutableArray alloc] init];
    
    [self addRefreshView];
    self.title = @"彩铃成员列表";
    self.output.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf initData];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCutomer count];
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
    
    Colorint_RingModel *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    cell.labelName.text = entity.CustName;
    cell.labelSubName.text = entity.ServiceNum;
    cell.imageView.image = [UIImage imageNamed:@"commonclient"];
    cell.IconImage.image = [UIImage imageNamed:@"c_right"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Business_Coloring_RingDetailViewController *vc = [[Business_Coloring_RingDetailViewController alloc]init];
    vc.entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    vc.compEntity = self.entity;
    vc.BillId = BillId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
    
}

- (void) getData
{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{@"method":@"whole_province",
                            @"oicode":@"OI_GetGroupOrder",
                            @"user_id":userEntity.user_id,
                            @"GroupId":self.entity.num,
                            @"OfferId":@"211230514400",
                            };
    
    [service getNetWorkData:dict1  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        if (state == 1) {
            NSDictionary *dic = entity[@"content"];
            NSMutableArray *array = [dic objectForKey:@"OfferInstInfo"];
            if ([array count] > 0) {
                
                BillId = [[array objectAtIndex:0] objectForKey:@"BillId"];
                if (BillId.length > 0) {
                    [HUD hide:YES];
                    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    HUD.delegate = self;
                    HUD.labelText = @"努力加载中...";
                    [self initData];
                }
                else{
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该集团尚未办理彩铃业务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该集团尚未办理彩铃业务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }

            
        }else if(state == -1){
            NSString *msg = entity[@"msg"];
            
            if (msg.length > 0) {
                ALERT_ERR_MSG(msg);
            }else{
                iToast *toast = [iToast makeText:@"暂无数据"];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:500];
                [toast show:iToastTypeNotice];
            }
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        [refreshHeader endRefreshing];
       
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
//        [UIView animateWithDuration:1 animations:^{
//            
//            self.output.alpha = 0;
//        }];
//        
//        return;
//    }
//    self.output.hidden = NO;
//}

- (void)initData{
    
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{@"method":@"whole_province",
                            @"oicode":@"OI_GetGroupProductMember",
                            @"user_id":userEntity.user_id,
                            @"GroupId":self.entity.num,
                            @"OfferId":@"211230514400",
                            };

    [service getNetWorkData:dict1  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        if (state == 1) {
            NSDictionary *dic = entity[@"content"];
            NSMutableArray *array = [dic objectForKey:@"MemberInfo"];
            if ([array count] > 0) {
                [self.arrayCutomer removeAllObjects];
                [self.arrayCustomerTemp removeAllObjects];
                for (NSDictionary* attributes in array) {
                    Colorint_RingModel *entity = [[Colorint_RingModel alloc]init];
                    entity = [entity initWithAttributes:attributes];
                    [self.arrayCutomer addObject:entity];
                    [self.arrayCustomerTemp addObject:entity];
                }
                [self.tableView reloadData];
            }else{
                
                
            }
            
            
        }else if(state == -1){
            NSString *msg = entity[@"msg"];
            
            if (msg.length > 0) {
                ALERT_ERR_MSG(msg);
            }else{
                iToast *toast = [iToast makeText:@"暂无数据"];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:500];
                [toast show:iToastTypeNotice];
            }
        }else if(state == 0){
            
            
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
    }];
    
}

- (IBAction)doAdd_V_Contact:(UIButton *)sender {
    
    Business_Add_Coloring_RingViewController *vc = [[Business_Add_Coloring_RingViewController alloc]init];
    vc.entity = self.entity;
    vc.BillId = BillId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {

    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
        [selectArray removeAllObjects];
        for (int i = 0; i < [self.arrayCustomerTemp count]; i++) {
            Colorint_RingModel *entity = [self.arrayCustomerTemp objectAtIndex:i];
            
            if ([entity.ServiceNum rangeOfString:self.textFieldKey.text].location != NSNotFound) {
                [selectArray addObject:entity];
            }
        }
        if ([selectArray count] == 0) {
            
            ALERT_ERR_MSG(@"没有你想要的！");
            return;
        }
        self.arrayCutomer = selectArray;
        [self.tableView reloadData];
        str = self.textFieldKey.text;
    }else{
        
        [self.arrayCutomer removeAllObjects];
        [self loadData];
    }

    
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [refreshHeader beginRefreshing];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self initData];
}


- (void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
