//
//  CustomerViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CustomerViewController.h"
#import "MBProgressHUD.h"
#import "ExecutorTableViewCell.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "CompEntity.h"
#import "CoustomerAddViewController.h"
#import "ConditionViewController.h"
#import "M_Order_Demand_SumiltViewController.h"
#import "Trouble_call_SumbitViewController.h"
#import "Business_change_SumbitViewController.h"
#import "SA_Special_SumbitViewController.h"

@interface CustomerViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSMutableArray *arrayCustomerTemp;

@end

@implementation CustomerViewController
@synthesize tableViewCutomer, arrayCutomer;
@synthesize tcVC,t_two_VC,OderVC;
@synthesize viewCondition;
@synthesize condition1, condition2, condition3, condition4;
@synthesize lable1, lable2, lable3, lable4;
@synthesize enter_type;
@synthesize tlVC;
@synthesize btnBack, btnReset, btnSure;
@synthesize addCusVC;
@synthesize textFieldKey;
@synthesize arrayCustomerTemp;

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
    tableViewCutomer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self select_logmodel:NSStringFromClass([self class])];
    
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
    
    if (enter_type == 0 || enter_type == 2) {
        self.title = @"客户列表";
        
        UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
        [nextButton addTarget:self action:@selector(doAddTask:) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
        nextButton.hidden = YES;
        
        UIButton *moreButton =[[UIButton alloc] initWithFrame:CGRectMake(40, 0, 60, 40)];
        [moreButton addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
        
        UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [viewRight addSubview:nextButton];
        [viewRight addSubview:moreButton];
        
//        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewRight];
//        self.navigationItem.rightBarButtonItem = nextButtonItem;
    } else {
        self.title = @"选择公司";
    }
    
    arrayCutomer = [[NSMutableArray alloc] init];
    arrayCustomerTemp = [[NSMutableArray alloc] init];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
    [self.view addSubview:viewCondition];
    viewCondition.frame = CGRectMake(320, 0, 200, 300);
    [self initConditionValue];
    [self setConditionView];
    
    self.tableViewCutomer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bt1"] forState:UIControlStateHighlighted];
    [btnSure setBackgroundImage:[UIImage imageNamed:@"bt1"] forState:UIControlStateHighlighted];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"bt1"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"CustomerViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setConditionView];
    [MobClick beginLogPageView:@"CustomerViewController"];
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
    return [arrayCustomerTemp count];
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
    
    CompEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
//    cell.labelSubName.text = entity.update_time;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [textFieldKey resignFirstResponder];
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    if (enter_type == 0) {
        [tcVC setCustomerValue:entity];
        [tcVC setCotactValue:nil];
    } else if (enter_type == 4){
        [addCusVC setCustomerValue:entity];
    } else if (enter_type == 5){
        [t_two_VC setCustomerValue:entity];
    } else if (enter_type == 6){
        [OderVC setCustomerValue:entity];
    } else if (enter_type == 7){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        M_Order_Demand_SumiltViewController *vc = [[M_Order_Demand_SumiltViewController alloc]init];
        
        vc.entity = entity;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return ;
    }  else if (enter_type == 8){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Trouble_call_SumbitViewController *vc = [[Trouble_call_SumbitViewController alloc]init];
        
        vc.entity = entity;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return ;
    }   else if (enter_type == 9){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Business_change_SumbitViewController *vc = [[Business_change_SumbitViewController alloc]init];
        
        vc.entity = entity;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return ;
    }   else if (enter_type == 10){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SA_Special_SumbitViewController *vc = [[SA_Special_SumbitViewController alloc]init];
    
        vc.product_name = _product_name;
        
        vc.entity = entity;
        
        [self.navigationController pushViewController:vc animated:YES];
        
//        M_Order_Demand_SumiltViewController *vc = [[M_Order_Demand_SumiltViewController alloc]init];
//        
//        vc.entity = entity;
//        
//        vc.contenDic = self.contenDic;
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
        return ;
    } else {
        [tlVC setCustomerValue:entity];
    }
    
    //add by xy
    if ([self.delegate respondsToSelector:@selector(customerViewController:didSelectCompany:)]) {
        [self.delegate customerViewController:self didSelectCompany:entity];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    //boss接口
    NSString *user_num = userEntity.num;
    NSString *num = @"";
    
    if (enter_type == 1 || enter_type == 2 || enter_type == 3 || enter_type == 4 || enter_type == 5) {
        user_num = userEntity.num;
    } else {
        user_num = tcVC.exEntity.user_id;
    }
    
    if ([userEntity.type_id isEqualToString:@"1"] == YES || [userEntity.is_first isEqualToString:@"1"] == YES) {
        
        if (enter_type == 5) {
        
            num = t_two_VC.exEntity.user_id;
        
        }else{
            
            if (tcVC.exEntity) {
                num = tcVC.exEntity.user_id;
            }else{
                num = userEntity.num;
            }

        }

    }else{
        num = userEntity.num;
    }
    
    CommonService *service = [[CommonService alloc] init];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:@"company_list" forKey:@"method"];
    [param setObject:num forKey:@"user_num"];
    [param setObject:userEntity.user_id forKey:@"user_id"];
    [param setObject:userEntity.is_first forKey:@"is_first"];

    if ([self.contenDic count] > 0) {
        [param setObject:[self.contenDic objectForKey:@"company_num"] forKey:@"GroupId"];
    }
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无执行人信息！" delegate:self cancelButtonTitle:@"确定"‘ otherButtonTitles:nil, nil];
//            [alert show];
        }
        else
        {
            if (enter_type == 1) {//筛选进入的方式
                CompEntity *entity = [[CompEntity alloc] init];
                entity.name = @"全部";
                entity.company_id=@"-1";
                [arrayCutomer addObject:entity];
                [arrayCustomerTemp addObject:entity];
            }
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayCutomer addObject:entity];
                [arrayCustomerTemp addObject:entity];
            }
            [self.tableViewCutomer reloadData];
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

- (void) doAddTask:(id)sender
{
    CoustomerAddViewController *vc = [[CoustomerAddViewController alloc]init];
    vc.cvc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doSelect:(id)sender
{
    viewCondition.frame = CGRectMake(100, 0, 220, 420);
}

- (IBAction)doHideSearchView:(id)sender
{
    viewCondition.frame = CGRectMake(320, 0, 220, 420);
}

- (void) addCompObj:(CompEntity *)entity
{
    [arrayCutomer addObject:entity];
    [arrayCustomerTemp addObject:entity];
    
    [tableViewCutomer reloadData];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////
- (void) getDataByCondition
{
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    /*
     [titleDataArray count], @"level",
     [titleDataArray count], @"visit",
     [titleDataArray count], @"type",
     [titleDataArray count], @"scope",
     */
    NSString *from = [NSString stringWithFormat:@"%d", [arrayCutomer count] ];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @"selectcomp", @"method",
//                           entity.user_id, @"user_id",
//                           from, @"from",
//                           @"", @"name",
//                           condition1.ID, @"level",
//                           condition2.ID, @"visit",
//                           condition3.ID, @"type",
//                           condition4.ID, @"scope",
//                           nil];
    //boss接口
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"company_list", @"method",
                           entity.num, @"user_num",
                           from, @"from",
                           @"", @"name",
                           condition1.ID, @"level",
                           condition2.ID, @"visit",
                           condition3.ID, @"type",
                           condition4.ID, @"scope",
                           nil];
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        [arrayCutomer removeAllObjects];
        [arrayCustomerTemp removeAllObjects];
        
        if ([strState isEqualToString:@"0"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有客户信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.tableViewCutomer reloadData];
        }
        else
        {
            NSMutableArray *array = [entity objectForKey:@"content"];
            
            for (NSDictionary* attributes in array) {
                CompEntity *entity = [[CompEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [arrayCutomer addObject:entity];
                [arrayCustomerTemp addObject:entity];
            }
            
            [self.tableViewCutomer reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (IBAction)doComfirm:(id)sender
{
    [HUD show:YES];
    [self getDataByCondition];
    viewCondition.frame = CGRectMake(320, 0, 220, 420);
    //[HUD showWhileExecuting:@selector(getDataByCondition) onTarget:self withObject:nil animated:YES];
}

- (IBAction)doReset:(id)sender
{
    [self initConditionValue];
    [self setConditionView];
}

- (IBAction)doSelectCustomerLevel:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 0;
    vc.cvc = self;
    vc.enter_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectTask:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 1;
    vc.cvc = self;
    vc.enter_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectCustomerType:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 2;
    vc.cvc = self;
    vc.enter_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSelectCustomerScope:(id)sender
{
    ConditionViewController *vc = [[ConditionViewController alloc] init];
    vc.type = 3;
    vc.cvc = self;
    vc.enter_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) initConditionValue
{
    //初始化筛选条件
    condition1 = [[ConditionEntity alloc] init];
    condition1.ID = @"-1";
    condition1.name = @"全部";
    condition2 = [[ConditionEntity alloc] init];
    condition2.ID = @"-1";
    condition2.name = @"全部";
    condition3 = [[ConditionEntity alloc] init];
    condition3.ID = @"-1";
    condition3.name = @"全部";
    condition4 = [[ConditionEntity alloc] init];
    condition4.ID = @"-1";
    condition4.name = @"全部";
    //
}

- (void) setConditionView
{
    lable1.text = condition1.name;
    lable2.text = condition2.name;
    lable3.text = condition3.name;
    lable4.text = condition4.name;
}

- (IBAction)doSelectByKey:(id)sender
{
    [self.view endEditing:YES];
    [arrayCustomerTemp removeAllObjects];
    
    NSString *strKey = textFieldKey.text;
    
    if (strKey == nil || strKey.length == 0) {
        for (int i = 0; i < [arrayCutomer count]; i++) {
            CompEntity *entity = [arrayCutomer objectAtIndex:i];
            [arrayCustomerTemp addObject:entity];
        }
        [tableViewCutomer reloadData];
        return;
    }
    
    for (int i = 0; i < [arrayCutomer count]; i++) {
        CompEntity *entity = [arrayCutomer objectAtIndex:i];
        
        NSRange range = [entity.name rangeOfString:strKey];//判断字符串是否包含

        if (range.length > 0)//包含
        {
            [arrayCustomerTemp addObject:entity];
        } else//不包含
        {
        }
    }
    
    [tableViewCutomer reloadData];
}

@end



