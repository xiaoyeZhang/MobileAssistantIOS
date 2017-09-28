//
//  Customer_epresentativeViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/11.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Customer_epresentativeViewController.h"
#import "MBProgressHUD.h"
#import "ExecutorTableViewCell.h"
#import "ExecutorEntity.h"

@interface Customer_epresentativeViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *arrayCustomer;
    NSMutableArray *arrayCustomerTemp;
}


@end


@implementation Customer_epresentativeViewController


@synthesize tcVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首席客户代表";
    
    arrayCustomer = [[NSMutableArray array]init];
    arrayCustomerTemp = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self doTask];
    
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    ExecutorEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
//    cell.labelSubName.text = entity.tel;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExecutorEntity *entity = [arrayCustomerTemp objectAtIndex:indexPath.row];
    
    if (_enter_type == 1) {
         [_t_two_cVC setCustomer_epresentative:entity];
    }else{
         [tcVC setCustomer_epresentative:entity];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_textFieldKey resignFirstResponder];
    
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    [self.view endEditing:YES];
    [arrayCustomerTemp removeAllObjects];
    
    NSString *strKey = self.textFieldKey.text;
    
    if (strKey == nil || strKey.length == 0) {
        for (int i = 0; i < [arrayCustomer count]; i++) {
            CompEntity *entity = [arrayCustomer objectAtIndex:i];
            [arrayCustomerTemp addObject:entity];
        }
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < [arrayCustomer count]; i++) {
        CompEntity *entity = [arrayCustomer objectAtIndex:i];
        
        NSRange range = [entity.name rangeOfString:strKey];//判断字符串是否包含
        
        if (range.length > 0)//包含
        {
            [arrayCustomerTemp addObject:entity];
        } else//不包含
        {
        }
    }
    
    [self.tableView reloadData];
    
}

- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.dep_id, @"dep_id",
                           @"get_chief_list", @"method", nil];
    
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
                [arrayCustomer addObject:entity];
                [arrayCustomerTemp addObject:entity];
            }
            [self.tableView reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
