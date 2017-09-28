//
//  ContactViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ContactViewController.h"
#import "MBProgressHUD.h"
#import "ContactTableViewCell.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "ContactEntity.h"
#import "ContactAddViewController.h"

@interface ContactViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation ContactViewController

@synthesize tableViewContact, arrayContact;
@synthesize tcVC, compEntity;
@synthesize t_two_cVC;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系人列表";
    [self select_logmodel:NSStringFromClass([self class])];
    
    tableViewContact.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //bgImageView.backgroundColor = GrayBackgroundColor;
    bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImageView];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"添加" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
    arrayContact = [[NSMutableArray alloc] init];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ContactViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ContactViewController"];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayContact count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"ContactTableViewCell";
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    ContactEntity *entity = [arrayContact objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
    cell.labelSubName.text = entity.tel;
    
    if ([entity.level intValue] == 0) {
        cell.imageView.image = [UIImage imageNamed:@"commonclient"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"keyclient"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactEntity *entity = [arrayContact objectAtIndex:indexPath.row];
    if (tcVC != nil) {
        [tcVC setCotactValue:entity];
    } else if (t_two_cVC != nil) {
        [t_two_cVC setCotactValue:entity];
    }
    
    //add by xy
    if ([self.delegate respondsToSelector:@selector(contactViewController:didSelectClient:)]) {
        [self.delegate contactViewController:self didSelectClient:entity];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           tcVC.exEntity.user_id, @"user_id",
//                           compEntity.company_id, @"company_id",
//                           @"clientinfo", @"method", nil];
//    //{{业务办理选择联系人
//    if (poVC != nil || businessVC != nil) {
//        param = [NSDictionary dictionaryWithObjectsAndKeys:
//                               userEntity.user_id, @"user_id",
//                               compEntity.company_id, @"company_id",
//                               @"clientinfo", @"method", nil];
//    }
//    //}}
    
//    NSDictionary *param = nil;
//    if (tcVC) {
//        param = [NSDictionary dictionaryWithObjectsAndKeys:
//                               tcVC.exEntity.user_id, @"user_id",
//                               compEntity.company_id, @"company_id",
//                               @"clientinfo", @"method", nil];
//    }else{
//        param = [NSDictionary dictionaryWithObjectsAndKeys:
//                 userEntity.user_id, @"user_id",
//                 compEntity.company_id, @"company_id",
//                 @"clientinfo", @"method", nil];
//    }
    //boss接口
    NSString *num;
    
    if ([userEntity.type_id isEqualToString:@"1"] == YES || [userEntity.is_first isEqualToString:@"1"] == YES) {
        
        if (t_two_cVC != nil) {
            num = self.compEntity.is_fist_UserNum;
        }else {
            num = tcVC.exEntity.user_id;
        }
        
    }else{
        num = userEntity.num;
    }
//    self.bListModel?self.bListModel.business_id:@""
    NSDictionary *param = @{@"method":@"client_list",
                            @"company_num":compEntity?compEntity.num:self.num,
                            @"user_num":num,
                            };
    //以上 modified by xy
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"0"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无联系人信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {
                ContactEntity *entity = [[ContactEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayContact addObject:entity];
            }
            [self.tableViewContact reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (NSInteger)getBoardHeight:(BOOL)isShowNavigationBar
{
    if (isShowNavigationBar) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 7.0f) {
            return self.view.frame.size.height - 64.0f;
        }
        else
            return self.view.frame.size.height - 44.0;
    }
    else {
        return self.view.frame.size.height;
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fininCreate:(id)sender
{
//    ALERT_ERR_MSG(@"boss系统暂未开放，暂时无法添加");
    
    ContactAddViewController *vc = [[ContactAddViewController alloc]init];
    vc.contactVC = self;
    vc.compEntity = compEntity;
    vc.enter_type = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)subVCBackNeedRefresh:(id)sender
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
}

- (void) addContactObj:(ContactEntity *)entity
{
    [arrayContact addObject:entity];
    [self.tableViewContact reloadData];
}

@end
