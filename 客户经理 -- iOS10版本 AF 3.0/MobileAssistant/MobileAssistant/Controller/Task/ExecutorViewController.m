//
//  ExecutorViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ExecutorViewController.h"
#import "MBProgressHUD.h"
#import "ExecutorTableViewCell.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "ExecutorEntity.h"

@interface ExecutorViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation ExecutorViewController
@synthesize tableViewExecutor, arrayExecutor;
@synthesize tcVC,t_two_VC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText.text];
     if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
     NSLog(@"pinyin: %@", ms);
     }
     if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
     NSLog(@"pinyin: %@", ms);
     }
     pinyinLab.text = [ms copy];
     */
    tableViewExecutor.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.title = @"执行人列表";
    
    NSInteger height = [self getBoardHeight:YES];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //bgImageView.backgroundColor = GrayBackgroundColor;
    bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImageView];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    arrayExecutor = [[NSMutableArray alloc] init];
    ExecutorEntity *entity = [[ExecutorEntity alloc] init];
    UserEntity *userEntity = [UserEntity sharedInstance];
    entity.user_id = userEntity.user_id;
    entity.name = userEntity.name;
    entity.tel = userEntity.tel;
    [arrayExecutor addObject:entity];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ExecutorViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ExecutorViewController"];
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
    return [arrayExecutor count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"ExecutorTableViewCell";
    ExecutorTableViewCell *cell = (ExecutorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ExecutorTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    ExecutorEntity *entity = [arrayExecutor objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
    cell.labelSubName.text = entity.tel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExecutorEntity *entity = [arrayExecutor objectAtIndex:indexPath.row];
    
    if (self.enter_type == 1) {
        [t_two_VC setExecutorValue:entity];
        [t_two_VC setCustomerValue:nil];
        [t_two_VC setCotactValue:nil];
    }else{
        [tcVC setExecutorValue:entity];
        [tcVC setCustomerValue:nil];
        [tcVC setCotactValue:nil];
    }

    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.dep_id, @"dep_id",
                           @"userinfo", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无执行人信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        } else {
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                ExecutorEntity *entity = [[ExecutorEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayExecutor addObject:entity];
            }
            [self.tableViewExecutor reloadData];
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
@end
