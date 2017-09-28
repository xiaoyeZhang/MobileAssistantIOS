//
//  CoustomerDetailViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-5.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CoustomerDetailViewController.h"
#import "MBProgressHUD.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "CompEntity.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "ContactTableViewCell.h"
#import "SIAlertView.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "TaskCreateViewController.h"
#import "ExecutorEntity.h"
#import "ContactAddViewController.h"
#import "Coustomer_EditViewController.h"
#import "recommendedViewController.h"
#import "SMS_MessageViewController.h"

@interface CoustomerDetailViewController ()<MBProgressHUDDelegate,MFMessageComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation CoustomerDetailViewController
@synthesize mutableArry, tableView, compEntity;
@synthesize mainVC;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系人列表";
    
    [self select_logmodel:NSStringFromClass([self class])];
    
//    UIButton *backButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"添加" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
    mutableArry = [[NSMutableArray alloc] init];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"CoustomerDetailViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"CoustomerDetailViewController"];
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
    static NSString *couponTableViewCellIdentifier=@"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponTableViewCellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ContactEntity *entity = [mutableArry objectAtIndex:indexPath.row];
    
    cell.labelName.text = entity.name;
    cell.labelSubName.text = entity.tel;
    cell.IconImage.hidden = YES;
    cell.deleteBtn.hidden = NO;
    cell.editBtn.hidden = NO;
    cell.deleteBtn.tag = indexPath.row;
    cell.editBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteCustomer:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.editBtn addTarget:self action:@selector(editCustomer:) forControlEvents:UIControlEventTouchUpInside];
    if (entity.MemberLevel.intValue == 9) {
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactEntity * entity = [mutableArry objectAtIndex:indexPath.row];
    if ([self.type isEqualToString:@"1"]) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:entity.name andMessage:@""];
      
        [alertView addButtonWithTitle:@"发送祝福短信"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                                  NSArray *numbers = [NSArray arrayWithObject:entity.tel];
                                  
                                  [self sendSMS:self.message recipientList:numbers];
                              }];
   
        [alertView addButtonWithTitle:@"取   消"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                              }];
        
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didDismissHandler", alertView);
        };
        [alertView show];

    }else{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:entity.name andMessage:@""];
        [alertView addButtonWithTitle:@"制定拜访任务"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button1 Clicked");
                                  TaskCreateViewController *vc = [[TaskCreateViewController alloc]init];
                                  ExecutorEntity *ee = [[ExecutorEntity alloc]init];
                                  UserEntity *ue = [UserEntity sharedInstance];
                                  ee.user_id = ue.user_id;
                                  ee.name = ue.name;
                                  ee.tel = ue.tel;
                                  vc.fromCoustomer = YES;
                                  vc.exEntity = ee;
                                  vc.compEntity = compEntity;
                                  vc.contactEntity = entity;
                                  //                              [mainVC.navigationController pushViewController:vc animated:YES];
                                  [self.navigationController pushViewController:vc animated:YES];
                              }];
        [alertView addButtonWithTitle:@"呼叫"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button2 Clicked");
                                  NSString *strTel = [NSString stringWithFormat:@"tel://%@", entity.tel];
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strTel]];
                              }];
        [alertView addButtonWithTitle:@"发送祝福短信"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                                  NSArray *numbers = [NSArray arrayWithObject:entity.tel];
//
//                                  [self sendSMS:self.message recipientList:numbers];
                                  SMS_MessageViewController *vc = [[SMS_MessageViewController alloc]init];
                                  
                                  vc.type = @"1";
                                  vc.telArr = numbers;
                                  
                                  [self.navigationController pushViewController:vc animated:YES];
                              }];
        
        [alertView addButtonWithTitle:@"APP应用推荐"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  recommendedViewController *vc = [[recommendedViewController alloc]init];
                                  vc.tel = entity.tel;
                                  //                              [mainVC.navigationController pushViewController:vc animated:YES];
                                  [self.navigationController pushViewController:vc animated:YES];
                                  
                              }];
        
        [alertView addButtonWithTitle:@"取   消"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                              }];

        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler", alertView);
        };
        alertView.didShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didShowHandler", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didDismissHandler", alertView);
        };
        [alertView show];

    }
   
}

- (void)deleteCustomer:(UIButton*)sender{

    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"努力加载中...";
            CommonService *service = [[CommonService alloc] init];
    
            NSDictionary *dict;
            ContactEntity *entity = [mutableArry objectAtIndex:sender.tag];
            UserEntity *userEntity = [UserEntity sharedInstance];
            
            dict = @{
                        @"method":@"whole_province",
                        @"oicode":@"OI_UpdateGroupKeyManAndLinkManInfo",
                        @"user_id":userEntity.user_id,
                        @"OperType":@"2",
                        @"GroupId":self.compEntity.num,
                        @"MemUserId":entity.MemUserId,
                         };

            [service getNetWorkData:dict  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                if ([strState isEqualToString:@"1"] == YES) {
                    iToast *toast = [iToast makeText:@"删除成功！"];
                    [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                    [toast setDuration:500];
                    [toast show:iToastTypeNotice];
                    [HUD hide:YES];
                    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    HUD.delegate = self;
                    HUD.labelText = @"努力加载中...";
                    [self getData];

                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [HUD hide:YES];
            } Failed:^(int errorCode, NSString *message) {
                
                [HUD hide:YES];
                iToast *toast = [iToast makeText:@"网络连接失败"];
                [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
                [toast setDuration:500];
                [toast show:iToastTypeNotice];
            }];
            
        }
        else{
            
        }
    }];
    
}

- (void)subVCBackNeedRefresh:(id)sender
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
}

- (void)editCustomer:(UIButton*)sender{

    Coustomer_EditViewController *vc = [[Coustomer_EditViewController alloc]init];
    vc.compEntity = compEntity;
    vc.entity = [mutableArry objectAtIndex:sender.tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) getData
{
    UserEntity *entity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    /*
     [titleDataArray count], @"level",
     [titleDataArray count], @"visit",
     [titleDataArray count], @"type",
     [titleDataArray count], @"scope",
     */
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @"clientinfo", @"method",
//                           entity.user_id, @"user_id",
//                           compEntity.company_id, @"company_id",
//                           
//                           nil];
    NSDictionary *param = @{@"method":@"client_list",
                            @"company_num":compEntity.num,
                            @"user_num":entity.num,
                            };
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"0"] == YES) {
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"加载客户失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else
        {
            NSMutableArray *array = [entity objectForKey:@"content"];
            [mutableArry removeAllObjects];
            for (NSDictionary* attributes in array) {
                ContactEntity *entity = [[ContactEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArry addObject:entity];
            }
            [self.tableView reloadData];
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        iToast *toast = [iToast makeText:@"网络连接失败"];
        [toast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-30];
        [toast setDuration:500];
        [toast show:iToastTypeNotice];
        [HUD hide:YES];
    }];
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];

    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            ;
        }];
    }
}


// 处理发送完的响应结果
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //Notifies users about errors associated with the interface
    switch (result) {
        case MessageComposeResultCancelled:
            DebugLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            DebugLog(@"Result: Sent");
            break;
        case MessageComposeResultFailed:
            DebugLog(@"Result: Failed");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)TextFieldEndEdited:(UITextField *)TextField
{
    
    [TextField resignFirstResponder];
    
}
- (void)fininCreate:(id)sender
{
//    ALERT_ERR_MSG(@"boss系统暂未开放，暂时无法添加");
    
    ContactAddViewController *vc = [[ContactAddViewController alloc]init];
    vc.coustomerDetailVC = self;
    vc.compEntity = compEntity;
    vc.enter_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) addContactObj:(ContactEntity *)entity
{
    [mutableArry addObject:entity];
    [self.tableView reloadData];
}

@end
