//
//  ConditionViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-7.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "ConditionViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "ConditionTableViewCell.h"
#import "ConditionEntity.h"
#import "UserEntity.h"

@interface ConditionViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation ConditionViewController
@synthesize mutableArry, tableView, type;
@synthesize cmn, cvc;
@synthesize enter_type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择筛选条件";
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    mutableArry = [[NSMutableArray alloc] init];
    
    if (type == 0) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"努力加载中...";
        [self getData];
        //{{改从服务器获取
//        ConditionEntity *entity1 = [[ConditionEntity alloc]init];
//        entity1.ID = @"-1";
//        entity1.name = @"全部";
//        ConditionEntity *entity2 = [[ConditionEntity alloc]init];
//        entity2.ID = @"0";
//        entity2.name = @"普通";
//        ConditionEntity *entity3 = [[ConditionEntity alloc]init];
//        entity3.ID = @"1";
//        entity3.name = @"重要";
//        [mutableArry addObject:entity1];
//        [mutableArry addObject:entity2];
//        [mutableArry addObject:entity3];
    //}}
    } else if (type == 1){
        ConditionEntity *entity1 = [[ConditionEntity alloc]init];
        entity1.ID = @"-1";
        entity1.name = @"全部";
        ConditionEntity *entity2 = [[ConditionEntity alloc]init];
        entity2.ID = @"0";
        entity2.name = @"本月已拜访";
        ConditionEntity *entity3 = [[ConditionEntity alloc]init];
        entity3.ID = @"1";
        entity3.name = @"本月未拜访";
        [mutableArry addObject:entity1];
        [mutableArry addObject:entity2];
        [mutableArry addObject:entity3];
    } else if (type == 2 || type == 3) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"努力加载中...";
        [self getData];
        //[HUD showWhileExecuting:@selector(getData) onTarget:self withObject:nil animated:YES];
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ConditionViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ConditionViewController"];
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
    return [mutableArry count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponTableViewCellIdentifier=@"ConditionTableViewCell";
    ConditionTableViewCell *cell = (ConditionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ConditionTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ConditionEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConditionEntity * entity = [mutableArry objectAtIndex:indexPath.row];
    
    if (enter_type == 0) {
        if (type == 0) {
            cmn.condition1 = entity;
        } else if (type == 1){
            cmn.condition2 = entity;
        } else if (type == 2) {
            cmn.condition3 = entity;
        } else if (type == 3) {
            cmn.condition4 = entity;
        }
        
        [cmn setConditionView];
    } else {
        if (type == 0) {
            cvc.condition1 = entity;
        } else if (type == 1){
            cvc.condition2 = entity;
        } else if (type == 2) {
            cvc.condition3 = entity;
        } else if (type == 3) {
            cvc.condition4 = entity;
        }
        [cvc setConditionView];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getData
{
    UserEntity *entity = [UserEntity sharedInstance];
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"gettypeandscope", @"method",
                           entity.user_id, @"user_id",
                           nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"加载客户失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else
        {
            if (type == 3) {
                ConditionEntity *entity1 = [[ConditionEntity alloc]init];
                entity1.ID = @"-1";
                entity1.name = @"全部";
                [mutableArry addObject:entity1];
                NSMutableArray *array = [entity objectForKey:@"scope"];
                NSMutableArray *arrayLevel = [entity objectForKey:@"level"];
                
                for (NSDictionary* attributes in array) {
                    ConditionEntity *entity = [[ConditionEntity alloc] init];
                    entity = [entity initWithAttributes:attributes];
                    [mutableArry addObject:entity];
                }
                [self.tableView reloadData];
            } else if (type == 2) {
                ConditionEntity *entity1 = [[ConditionEntity alloc]init];
                entity1.ID = @"-1";
                entity1.name = @"全部";
                [mutableArry addObject:entity1];
                
                NSMutableArray *array = [entity objectForKey:@"type"];
                
                for (NSDictionary* attributes in array) {
                    ConditionEntity *entity = [[ConditionEntity alloc] init];
                    entity = [entity initWithAttributes:attributes];
                    [mutableArry addObject:entity];
                }
                [self.tableView reloadData];
            } else if (type == 0) {
                ConditionEntity *entity1 = [[ConditionEntity alloc]init];
                entity1.ID = @"-1";
                entity1.name = @"全部";
                [mutableArry addObject:entity1];
                
                NSMutableArray *array = [entity objectForKey:@"level"];
                
                for (NSDictionary* attributes in array) {
                    ConditionEntity *entity = [[ConditionEntity alloc] init];
                    entity = [entity initWithAttributes:attributes];
                    [mutableArry addObject:entity];
                }
                [self.tableView reloadData];
            }

            
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

@end
