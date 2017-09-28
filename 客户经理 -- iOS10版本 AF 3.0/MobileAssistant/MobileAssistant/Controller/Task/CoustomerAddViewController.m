//
//  CoustomerAddViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-10-8.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "CoustomerAddViewController.h"
#import "MBProgressHUD.h"
#import "ExecutorTableViewCell.h"
#import "CommonService.h"
#import "UserEntity.h"
#import "CompEntity.h"
#import "Utilies.h"
#import "StateViewController.h"
#import "LevelEntity.h"

@interface CoustomerAddViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation CoustomerAddViewController
@synthesize textField1;
@synthesize textField2;
@synthesize textField3;
@synthesize textField4;
@synthesize textField5;
@synthesize textField6;
@synthesize textField7;
@synthesize textField8;
@synthesize textField9;
@synthesize textField10;
@synthesize textField11;
@synthesize cvc;
@synthesize scrollView;
@synthesize mutableArray1, mutableArray2, mutableArray3;
@synthesize stateEntity1, stateEntity2, stateEntity3;
@synthesize cmvc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加客户信息";
    
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
    
    UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 32)];
    [nextButton addTarget:self action:@selector(fininCreate:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
//    textField3.enabled = NO;
//    textField4.enabled = NO;
//    textField5.enabled = NO;
    textField3.delegate = self;
    textField4.delegate = self;
    textField5.delegate = self;
    textField6.delegate = self;
    textField7.delegate = self;
    textField8.delegate = self;
    textField9.delegate = self;
    textField10.delegate = self;
    textField11.delegate = self;
    textField1.delegate = self;
    textField2.delegate = self;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    
    if (width == 480.0) {
        [scrollView setContentSize: CGSizeMake(320, 960)];
    } else {
        [scrollView setContentSize: CGSizeMake(320, 600)];
    }
    mutableArray1 = [[NSMutableArray alloc] init];
    mutableArray2 = [[NSMutableArray alloc] init];
    mutableArray3 = [[NSMutableArray alloc] init];

    //{{改为从服务器获取
//    stateEntity1 = [[StateEntity alloc]init];
//    stateEntity1.tid = @"0";
//    stateEntity1.name = @"普通";
//    [mutableArray1 addObject:stateEntity1];
//    textField3.text = stateEntity1.name;
//    
//    StateEntity *stateEntity11 = [[StateEntity alloc]init];
//    stateEntity11.tid = @"1";
//    stateEntity11.name = @"重要";
//    [mutableArray1 addObject:stateEntity11];
    //}}
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"CoustomerAddViewController"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"CoustomerAddViewController"];
    
    textField3.text = stateEntity1.name;
    textField4.text = stateEntity2.name;
    textField5.text = stateEntity3.name;
}

- (void)fininCreate:(id)sender
{
    [HUD show:YES];
    
    if (textField1.text.length == 0) {
        [HUD hide:YES];
        ALERT_ERR_MSG(@"名称不能为空");
        return;
    }
    
    if (textField6.text.length == 0) {
        [HUD hide:YES];
        ALERT_ERR_MSG(@"联系人不能空");
        return;
    }
    
    if (textField7.text.length == 0) {
        [HUD hide:YES];
        ALERT_ERR_MSG(@"联系人电话不能为空");
        return;
    }
    
    if (textField8.text.length == 0) {
        [HUD hide:YES];
        ALERT_ERR_MSG(@"联系人职务不能为空");
        return;
    }
    
    if (textField11.text.length == 0) {
        [HUD hide:YES];
        ALERT_ERR_MSG(@"地址不能为空");
        return;
    }
    
    [self doTask];
}


- (void) doTask
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.user_id, @"user_id",
                           textField1.text, @"name",
                           textField2.text, @"num",
                           stateEntity1.tid, @"level_id",
                           stateEntity2.tid, @"type_id",
                           stateEntity3.tid, @"scope_id",
                           textField6.text, @"contact",
                           textField7.text, @"tel",
                           textField8.text, @"job",
                           textField9.text, @"key_name",
                           textField10.text, @"key_tel",
                           textField11.text, @"address",
                           @"addcomp", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        if ([strState isEqualToString:@"0"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"新增联系人信息失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *compId= [entity objectForKey:@"content"];//addCompObj:
            CompEntity *entity = [[CompEntity alloc]init];
            //entity = [entity initWithAttributes:dicEntity];
            //
            entity.company_id = compId;
            entity.name = textField1.text;
            entity.num = textField2.text;
            entity.type = stateEntity2.tid;
            entity.scope = stateEntity3.tid;
            entity.contact = textField6.text;
            entity.tel = textField7.text;
            entity.key_name = textField9.text;
            entity.key_tel = textField10.text;
            entity.address = textField11.text;
            
            if (cvc != nil) {
                [cvc addCompObj:entity];
            } else if (cmvc != nil) {
                [cmvc addCompObj:entity];
            }
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"新增客户信息成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField3 == textField) {
        StateViewController *vc = [[StateViewController alloc]init];
        vc.mutableArry = mutableArray1;
        vc.caVC = self;
        vc.item = 1;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if (textField4 == textField) {
        StateViewController *vc = [[StateViewController alloc]init];
        vc.caVC = self;
        vc.mutableArry = mutableArray2;
        vc.item = 2;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if (textField5 == textField) {
        StateViewController *vc = [[StateViewController alloc]init];
        vc.mutableArry = mutableArray3;
        vc.caVC = self;
        vc.item = 3;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    if (textField == self.textField5) {
        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    } else if (textField == self.textField6) {
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (textField == self.textField7) {
        [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    } else if (textField == self.textField8) {
        [scrollView setContentOffset:CGPointMake(0, 180) animated:YES];
    }
    
    if (textField == self.textField9) {
        [scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
    }
    if (textField == self.textField10) {
        [scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
    }
    if (textField == self.textField11) {
        [scrollView setContentOffset:CGPointMake(0, 290) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.textField1) {
        [textField2 becomeFirstResponder];
    } else if (textField == self.textField2) {
        [textField3 becomeFirstResponder];
    } else if (textField == self.textField3) {
        [textField4 becomeFirstResponder];
    } else if (textField == self.textField4) {
        [textField5 becomeFirstResponder];
    } else if (textField == self.textField6) {
        [textField7 becomeFirstResponder];
    } else if (textField == self.textField7) {
        [textField8 becomeFirstResponder];
    } else if (textField == self.textField8) {
        [textField9 becomeFirstResponder];
    } else if (textField == self.textField9) {
        [textField10 becomeFirstResponder];
    } else if (textField == self.textField10) {
        [textField11 becomeFirstResponder];
    } else if (textField == self.textField11) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [textField11 resignFirstResponder];
    }
    return YES;
}

- (void) getData
{
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userEntity.area_id, @"area_id",
                           @"compst", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSString *strState = [entity valueForKeyPath:@"state"];
        if ([strState isEqualToString:@"0"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"no data" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSDictionary *scopeEntity = [entity objectForKey:@"scope"];
            NSDictionary *typeEntity = [entity objectForKey:@"type"];
            NSDictionary *levelEntity = [entity objectForKey:@"level"];
            
            for (NSDictionary* attributes in scopeEntity) {
                StateEntity *entity = [[StateEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArray3 addObject:entity];
            }
            
            for (NSDictionary* attributes in typeEntity) {
                StateEntity *entity = [[StateEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArray2 addObject:entity];
            }
            
            for (NSDictionary* attributes in levelEntity) {
                StateEntity *entity = [[StateEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [mutableArray1 addObject:entity];
            }
        }
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
    }
    if (0==buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了确认按钮");
    }
}

@end



