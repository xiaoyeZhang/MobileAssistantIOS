//
//  Business_Group_V_Net_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import "Business_Group_V_Net_DetailViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "ContactTableViewCell.h"
#import "Group_V_NetContactModel.h"
#import "Business_Group_V_Net_Contact_DetailTableViewController.h"
#import "Business_Add_Group_V_NetContactViewController.h"

@interface Business_Group_V_Net_DetailViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MJRefreshHeaderView *refreshHeader;
    MJRefreshFooterView *refreshFooter;
    NSMutableArray *selectArray;
    NSString *str;
    NSTimer *timer1;
    int count;
}

@end

@implementation Business_Group_V_Net_DetailViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    
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
    selectArray = [[NSMutableArray alloc]init];
    self.arrayCutomer = [[NSMutableArray alloc] init];
    self.arrayCustomerTemp = [[NSMutableArray alloc] init];

    self.title = @"V网成员列表";
    self.output.alpha = 0;
    [self addRefreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.startcurrentPage = 1;
        weakSelf.endcurrentPage = 20;
        [weakSelf getData:weakSelf.startcurrentPage withDate:weakSelf.endcurrentPage];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (weakSelf.arrayCutomer.count >= weakSelf.entity.MemberNum.intValue) {
            
            [refreshFooter endRefreshing];
            
        }else{
            
            [weakSelf getData:[weakSelf.arrayCutomer count] + 1 withDate:[weakSelf.arrayCutomer count] + 20];
        }
    };
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayCustomerTemp count];
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
    
    Group_V_NetContactModel *entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    cell.labelName.text = entity.MemberName;
    cell.labelSubName.text = entity.ServiceNum;
    cell.imageView.image = [UIImage imageNamed:@"commonclient"];
    cell.IconImage.image = [UIImage imageNamed:@"c_right"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business_Group_V_Net_Contact_DetailTableViewController *vc = [[Business_Group_V_Net_Contact_DetailTableViewController alloc]init];
    
    vc.entity = [self.arrayCustomerTemp objectAtIndex:indexPath.row];
    vc.compEntity = self.compEntity;
    vc.Group_V_NetEntity = self.entity;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)loadData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData:1 withDate:20];
    
}

- (void) getData:(int)startpage withDate:(int)endpage
{
    
    CommonService *service = [[CommonService alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    NSDictionary *dict1 = @{@"method":@"whole_province",
                            @"oicode":@"OI_QueryVmpnAllMemInfo",
                            @"user_id":userEntity.user_id,
                            @"VpmnId":self.entity.VpmnId,
                            @"EndIndex":@(endpage),
                            @"StartIndex":@(startpage),
//                            @"ServiceNum":self.textFieldKey.text,
                            };
    
    [service getNetWorkData:dict1  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
            NSDictionary *dic = [entity objectForKey:@"content"];
            NSMutableArray *array = [dic objectForKey:@"MemInfo"];
            
            if (startpage == 1) {
                [self.arrayCutomer removeAllObjects];
                [self.arrayCustomerTemp removeAllObjects];
                if ([array count] > 0) {
                    for (NSDictionary* attributes in array) {
                        Group_V_NetContactModel *entity = [[Group_V_NetContactModel alloc] init];
                        entity = [entity initWithAttributes:attributes];
                        [self.arrayCutomer addObject:entity];
                        [self.arrayCustomerTemp addObject:entity];
                    }
                    [self.tableView reloadData];
                }

            }else{
                

                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

                for (NSDictionary* attributes in array) {
                    Group_V_NetContactModel *entity = [[Group_V_NetContactModel alloc] init];
                    entity = [entity initWithAttributes:attributes];
                    [self.arrayCutomer addObject:entity];
                    [self.arrayCustomerTemp addObject:entity];
                    [indexPaths addObject:entity];
                }
                
                //插入数据
                [self.tableView reloadData];

            }
           
            
        }else if(state == -1){
            ALERT_ERR_MSG(entity[@"msg"]);
        }
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
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

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
}

- (IBAction)doAdd_V_Contact:(UIButton *)sender {
    
    Business_Add_Group_V_NetContactViewController *vc = [[Business_Add_Group_V_NetContactViewController alloc]init];
    vc.entity = self.entity;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
        if (self.textFieldKey.text.length > 0) {

        [selectArray removeAllObjects];
        for (int i = 0; i < [self.arrayCutomer count]; i++) {
            Group_V_NetContactModel *entity = [self.arrayCutomer objectAtIndex:i];
            
            if ([entity.ServiceNum rangeOfString:self.textFieldKey.text].location != NSNotFound) {
                [selectArray addObject:entity];
            }
        }
        if ([selectArray count] == 0) {
            
            ALERT_ERR_MSG(@"当前数据查询未有结果，请上拉页面加载更多数据后重试！");
            return;
        }
        self.arrayCustomerTemp = selectArray;
        [self.tableView reloadData];
        str = self.textFieldKey.text;
    }else{
        
        [self.arrayCustomerTemp removeAllObjects];
        [self loadData];
    }
//    [self getData:1 withDate:20];
}

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据
    [refreshHeader beginRefreshing];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData:1 withDate:20];
}

- (void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
