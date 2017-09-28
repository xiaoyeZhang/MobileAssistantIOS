//
//  VisitTaskDetailViewController.m
//  MobileAssistant
//
//  Created by 房 国生 on 14-9-27.
//  Copyright (c) 2014年 avatek. All rights reserved.
//

#import "VisitTaskDetailViewController.h"
#import "DXAlertView.h"
#import "CommonService.h"
#import "Utilies.h"
#import "ActionViewController.h"
#import "SIAlertView.h"
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "UserEntity.h"
#import "MALocationEntity.h"
#import "UIAlertView+Blocks.h"
#import <AVFoundation/AVFoundation.h>

@interface VisitTaskDetailViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    CalendarHomeViewController *chvc;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    NSString *locaLatitude;
    NSString *locaLongitude;
    NSString *address;
    NSArray *summaryArr;
    NSString *refuse_reason;
}
@property (nonatomic, strong) NSMutableArray *arrayAddress;

@end

@implementation VisitTaskDetailViewController

@synthesize arrayAddress;

@synthesize labelTitle;
@synthesize labelActor;
@synthesize labelCustomer;
@synthesize labelContact;
@synthesize labelJob;
@synthesize labelAddress;
@synthesize labelDate;
@synthesize labelDes;
@synthesize labelTel;
@synthesize end_date;
@synthesize scrollView;
@synthesize visiteTask;

@synthesize labelLocation;
@synthesize labelLoactionAddress;
@synthesize labelSummary;

@synthesize viewLocation;
@synthesize viewSummary;
@synthesize strSummery;

@synthesize alertCancel;
@synthesize alertModify;

@synthesize viewModify;
@synthesize dateButton;
@synthesize labelActor1;
@synthesize labelAdd1;
@synthesize labelAdd2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"任务详情";
    refuse_reason = @"";
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
    
    UserEntity *userEntity = [UserEntity sharedInstance];
    
    UIScreen *currentScreen = [UIScreen mainScreen];
    
    if ([visiteTask.state isEqualToString:@"0"] == YES || [visiteTask.state isEqualToString:@"-1"] == YES) {
        viewLocation.hidden = YES;
        viewSummary.hidden = YES;
        
        if ([visiteTask.state isEqualToString:@"0"] == YES) {
            

            UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];

            if ([userEntity.user_id isEqualToString:visiteTask.actor_id] == YES) {//只有0：客户经理有此权限，1：部门主管没有
                UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 32)];
                [nextButton addTarget:self action:@selector(doActionTask:) forControlEvents:UIControlEventTouchUpInside];
                [nextButton setTitle:@"执行" forState:UIControlStateNormal];
                nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [viewRight addSubview:nextButton];
                
                UIButton *moreButton =[[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
                [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                [moreButton setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
                [viewRight addSubview:moreButton];
                
                UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewRight];
                self.navigationItem.rightBarButtonItem = nextButtonItem;
                
            }
            
        }
        
        if (currentScreen.applicationFrame.size.height == 460.000000) {
            scrollView.contentSize = CGSizeMake(320,750);
        } else {
            scrollView.contentSize = CGSizeMake(320,650);
        }
        
    } else if ([visiteTask.state isEqualToString:@"1"] == YES) {
        viewSummary.hidden = YES;
        viewLocation.hidden = NO;
        NSString *strLocation = [NSString stringWithFormat:@"%@, %@", visiteTask.lat, visiteTask.lont];
        labelLocation.text = strLocation;
        labelLoactionAddress.text = visiteTask.baidu_addr;
        
        if ([userEntity.user_id isEqualToString:visiteTask.actor_id] == YES) {//只有0：客户经理有此权限，1：部门主管没有
            UIButton *nextButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 32)];
            [nextButton addTarget:self action:@selector(writeSummery:) forControlEvents:UIControlEventTouchUpInside];
            [nextButton setTitle:@"填写纪要" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
            UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
            self.navigationItem.rightBarButtonItem = nextButtonItem;
        }
        
        if (currentScreen.applicationFrame.size.height == 460.000000) {
            scrollView.contentSize = CGSizeMake(320,750);
        } else {
            scrollView.contentSize = CGSizeMake(320,710);
        }
        
    } else if ([visiteTask.state isEqualToString:@"2"] == YES) {
        viewLocation.hidden = NO;
        viewSummary.hidden = NO;
        NSString *strLocation = [NSString stringWithFormat:@"%@, %@", visiteTask.lat, visiteTask.lont];
        labelLocation.text = strLocation;
        labelLoactionAddress.text = visiteTask.baidu_addr;
        
        summaryArr = [visiteTask.summary componentsSeparatedByString:@","];
        
        labelSummary.text = [summaryArr lastObject];
        
        if (currentScreen.applicationFrame.size.height == 460.000000) {
            scrollView.contentSize = CGSizeMake(320,860);
        } else {
            scrollView.contentSize = CGSizeMake(320,810);
        }
        
        self.sendMsgBgView.hidden = NO;
    }else if ([visiteTask.state isEqualToString:@"-2"] == YES){
        
        if ([userEntity.is_first isEqualToString:@"1"]) {
            
            UIButton *rightBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtnTwo.frame = CGRectMake(0, 0, 44, 44);
            [rightBtnTwo setTitle:@"接受" forState:UIControlStateNormal];
            rightBtnTwo.titleLabel.font = [UIFont systemFontOfSize:15];
            rightBtnTwo.tag = 0;
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(0, 0, 44, 44);
            [rightBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            rightBtn.tag = -1;
            
            UIBarButtonItem *rightBtnTwoitem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnTwo];
            UIBarButtonItem *rightBtnitem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            
            [rightBtnTwo addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.rightBarButtonItems = @[rightBtnTwoitem,rightBtnitem];
            
        }
        
    }
    
    labelTitle.text = visiteTask.title;
    labelActor.text = visiteTask.maker_name;
    labelActor1.text = visiteTask.actor_name;
    labelCustomer.text = visiteTask.company_name;
    labelContact.text = visiteTask.name;
    labelJob.text = visiteTask.job;
    labelAddress.text = visiteTask.address;
    labelDate.text = visiteTask.time;
    labelDes.text = visiteTask.reason;
    labelTel.text = visiteTask.tel;
    labelAdd1.text = visiteTask.add1;
    labelAdd2.text = visiteTask.add2;
    end_date.text = visiteTask.up_date;
    
    if (summaryArr.count >= 2) {
        
        UILabel *ServiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, labelSummary.frame.size.height + labelSummary.frame.origin.y + 5, self.view.frame.size.width - 14, 21)];
        ServiceLabel.font = [UIFont systemFontOfSize:15];
        ServiceLabel.text = [NSString stringWithFormat:@"推荐业务： %@",summaryArr[0]];
        [viewSummary addSubview:ServiceLabel];
        
        UILabel *OperationsLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, ServiceLabel.frame.size.height + ServiceLabel.frame.origin.y + 5, self.view.frame.size.width - 14, 21)];
        OperationsLabel.font = [UIFont systemFontOfSize:15];
        OperationsLabel.text = [NSString stringWithFormat:@"挖掘业务： %@",summaryArr[1]];
        [viewSummary addSubview:OperationsLabel];
        
    }

    
    arrayAddress = [[NSMutableArray alloc] init];
    //[[LocationManagement sharedInstance] startUpdatingLocation];
    
    
    if ([visiteTask.cacsi isEqualToString:@"-1"]) {
        self.sendMsgBtn.hidden = NO;
//        self.sendMsgBtn.hidden = YES;
        self.rateLbl.text = @"未回复";
    }else{
        self.sendMsgBtn.hidden = YES;
        self.rateLbl.text = [NSString stringWithFormat:@"%@分",visiteTask.cacsi];
    }
    
    NSUserDefaults *locationDefaults = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    locaLatitude = [locationDefaults objectForKey:@"locaLatitude"];
    locaLongitude = [locationDefaults objectForKey:@"locaLongitude"];
    address = [locationDefaults objectForKey:@"address"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"VisitTaskDetailViewController"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"VisitTaskDetailViewController"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectByCondition:(id)sender
{
}

- (void)moreAction:(id)sender
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"更多操作" andMessage:@""];
    [alertView addButtonWithTitle:@"撤   销"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button1 Clicked");
                              alertCancel = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要撤销任务吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                              [alertCancel show];
                          }];
    [alertView addButtonWithTitle:@"变   更"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button2 Clicked");
                              viewModify.frame = CGRectMake(0, 0, 320, 900);
                              self.dateButton.titleLabel.text = self.visiteTask.time;
                              [self.view addSubview:viewModify];
                              
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
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    [alertView show];
}

- (void)doActionTask:(id)sender
{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString* str=[NSString stringWithFormat:@"请退出客户经理，在【设置>隐私>相机>客户经理】授权相机访问"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
//            
//        }];
        [alert show];
        
        return;
    }else{
        ActionViewController *vc = [[ActionViewController alloc] init];
        vc.visiteTask = self.visiteTask;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)writeSummery:(id)sender
{
    //[[LocationManagement sharedInstance] startUpdatingLocation];
    
    if ([visiteTask.is_chief isEqualToString:@"2"]) {
        
//        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"填写纪要" leftTitle:@"提交" rightTitle:@"取消" ];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"填写纪要" leftTitle:@"提交" rightTitle:@"取消" placeholderTitle:@"请填写本次拜访过程、业务洽谈情况、客户反馈、后期建议等"];
        
        alert.vsTaskVC = self;
        [alert show];
        alert.leftBlock = ^() {
            
            if (self.strSummery.length == 0) {
                ALERT_ERR_MSG(@"拜访纪要不能为空");
                return;
            }
            
            CommonService *service = [[CommonService alloc] init];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.visiteTask.visit_id, @"visitId",
                                   [NSString stringWithFormat:@"%@",self.strSummery], @"content",
                                   [Utilies GetNowDateTime], @"endtime",
                                   @"writeSummary", @"method", nil];
            
            [service getNetWorkData:param  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                if ([strState isEqualToString:@"0"] == YES) {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"填写纪要失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [self updateSignout];
                }
                
            } Failed:^(int errorCode, NSString *message) {
                
            }];
            
        };
        alert.rightBlock = ^() {
            NSLog(@"right button clicked");
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
        
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"填写纪要" leftButtonTitle:@"提交" rightButtonTitle:@"取消"];
        
        alert.vsTaskVC = self;
        [alert show];
        alert.leftBlock = ^() {
            NSLog(@"left button clicked");
            //
            /*
             visitId	拜访任务id
             content	纪要内容
             endtime	当前时间
             */
            //
            if (self.strService.length == 0) {
                ALERT_ERR_MSG(@"推荐业务不能为空");
                return;
            }
            
            if (self.strOperations.length == 0) {
                ALERT_ERR_MSG(@"挖掘业务不能为空");
                return;
            }
            
            if (self.strSummery.length == 0) {
                ALERT_ERR_MSG(@"拜访内容不能为空");
                return;
            }
            
            
            CommonService *service = [[CommonService alloc] init];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.visiteTask.visit_id, @"visitId",
                                   [NSString stringWithFormat:@"%@,%@,%@",self.strService,self.strOperations,self.strSummery], @"content",
                                   [Utilies GetNowDateTime], @"endtime",
                                   @"writeSummary", @"method", nil];
            
            [service getNetWorkData:param  Successed:^(id entity) {
                NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                if ([strState isEqualToString:@"0"] == YES) {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"填写纪要失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [self updateSignout];
                }
                
            } Failed:^(int errorCode, NSString *message) {
                
            }];
        };
        alert.rightBlock = ^() {
            NSLog(@"right button clicked");
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
    }
 
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==self.alertCancel) {
        
        if (0 == buttonIndex) {
            CommonService *service = [[CommonService alloc] init];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.visiteTask.visit_id, @"visitId",
                                   @"-1", @"state",
                                   @"cancleTask", @"method", nil];
            
            [service getNetWorkData:param  Successed:^(id entity) {
                //NSNumber *state = [entity valueForKeyPath:@"state"];
                NSString *reason = [entity valueForKeyPath:@"reason"];
                //NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } Failed:^(int errorCode, NSString *message) {
                
            }];
        }
        return;
    }
    
    if (alertView == self.alertModify) {
        if (0 == buttonIndex)
        {
            CommonService *service = [[CommonService alloc] init];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.visiteTask.visit_id, @"visitId",
                                   self.dateButton.titleLabel.text, @"time",
                                   @"changeTime", @"method", nil];
            
            [service getNetWorkData:param  Successed:^(id entity) {
                NSString *reason = [entity valueForKeyPath:@"reason"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } Failed:^(int errorCode, NSString *message) {
                
            }];
        }
        if (1 == buttonIndex) {
            ;
        }
        return;
    }
    
    if (0 == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了确认按钮");
    }
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

- (IBAction)doSelectDate:(id)sender
{
    if (!chvc) {
        chvc = [[CalendarHomeViewController alloc]init];
        chvc.calendartitle = @"选择日期";
        [chvc setAirPlaneToDay:365 ToDateforString:nil];//
    }
    
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        
        [sender setTitle:[NSString stringWithFormat:@"%@",[model toString]] forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:chvc animated:YES];
}

- (IBAction)doModifyDateCancel:(id)sender
{
    [self.viewModify removeFromSuperview];
}

- (IBAction)doModifyDateAction:(id)sender
{
    alertModify = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要变更任务吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertModify show];
}


- (void) updateSignout
{
    CommonService *service = [[CommonService alloc] init];
    NSString *lat = locaLatitude;
    NSString *lng = locaLongitude;

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.visiteTask.visit_id, @"visitId",
                           lat?lat:locaLatitude, @"endlat",
                           lng?lng:locaLongitude, @"endlont",
                           [MALocationEntity sharedInstance].name?[MALocationEntity sharedInstance].name:address, @"endbaidu_addr",
                           @"updateSignout", @"method", nil];
    
    [service getNetWorkData:param  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState= [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"填写纪要成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"签到Signout失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        //        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        //        [HUD hide:YES];
    }];
    
}

- (void)locationUpdated
{
}


- (void)locationUpdatedFailed:(int)errorCode ErrorMessage:(NSString *)message
{
    ALERT_ERR_MSG(@"获取当前经纬度失败，请退出客户经理，在【设置>隐私>定位服务>客户经理>使用应用程序期间】授权访问当前位置");
}
- (IBAction)sendMsgBtnClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定要重发短信吗？"
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"重发", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex != alert.cancelButtonIndex) {            
            NSDictionary *dict = @{@"method":@"replay_visit_sms",
                                   @"tel":visiteTask.tel};
            
            CommonService *service = [[CommonService alloc] init];
            
            [service getNetWorkData:dict
                          Successed:^(id entity) {
                              int state = [entity[@"state"] intValue];
                              NSString *reason = entity[@"reason"];
                              if (state == 1) {
                                  if (reason) {
                                      ALERT_ERR_MSG(reason);
                                  }else{
                                      ALERT_ERR_MSG(@"重发成功");
                                  }
                              }else{
                                  if (reason) {
                                      ALERT_ERR_MSG(reason);
                                  }else{
                                      ALERT_ERR_MSG(@"重发失败");
                                  }
                              }
                          } Failed:^(int errorCode, NSString *message) {
                              ALERT_ERR_MSG(@"网络连接失败!");
                          }];
        }
    }];
    
}

- (void)rightBtnClicked:(UIButton *)sender{
    
//    method = check_visit_task
//    visit_id = 任务唯一ID
//    state = 0表示接受,-1表示拒绝
//    reason = 原因说明
  
    if (sender.tag == -1) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"请填写拒绝原因" leftTitle:@"提交" rightTitle:@"取消" placeholderTitle:@""];
        alert.vsTaskVC = self;
        [alert show];
        alert.leftBlock = ^() {

            if (self.strSummery.length == 0) {
                ALERT_ERR_MSG(@"拒绝原因不能为空");
                return;
            }
            
            refuse_reason = self.strSummery;
            
            [self check_visit_task:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            
        };
        alert.rightBlock = ^() {
            NSLog(@"right button clicked");
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };

    }else{
        
        [self check_visit_task:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        
    }

    
}

- (void)check_visit_task:(NSString *)State{
    
    NSDictionary *dict = @{@"method":@"check_visit_task",
                           @"visit_id":visiteTask.visit_id,
                           @"state":State,
                           @"reason":refuse_reason
                           
                           };
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
//                      int state = [entity[@"state"] intValue];
//                      NSString *reason = entity[@"reason"];
                      UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                      [alert show];
                      
                  } Failed:^(int errorCode, NSString *message) {
                      ALERT_ERR_MSG(@"网络连接失败!");
                  }];

}

@end
